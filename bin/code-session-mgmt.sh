#!/usr/bin/env bash
# List, pick, resume and delete Claude Code and Codex sessions for the current project.
#
# Requires: bash 4+, jq, fzf 0.59+ (picker), coreutils, awk, sed
# Optional: sqlite3 + codex (Codex sessions), claude (resume/new)
#
# Install (Debian/Ubuntu):
#   echo "alias csm='~/path-to/code-session-mgmt.sh'" >> ~/.bashrc
#
# Usage:
#   code-session-mgmt.sh                         interactive picker (vim keys; / or i to search, q to quit)
#   code-session-mgmt.sh list [--all]            tool, id, time, hint; --all includes empty sessions
#   code-session-mgmt.sh rm <claude|codex> <id>  delete a session permanently (asks y/N)
#   code-session-mgmt.sh hint [skip-id]          recent 5 as resume commands (CA_SESSIONS_MAX to change)
#   code-session-mgmt.sh help                    show this help
set -euo pipefail

CWD=${CA_PROJECT_CWD:-$PWD}
DIR="$HOME/.claude/projects/$(sed 's/[^A-Za-z0-9]/-/g' <<<"$CWD")"
CODEX_DB="$HOME/.codex/state_5.sqlite"
SELF=$(readlink -f "$0")
UUID_RE='^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'

# nvm puts codex on PATH only in interactive shells; fall back to the newest install.
codex_bin() { command -v codex 2>/dev/null || ls -1 "$HOME"/.nvm/versions/node/*/bin/codex 2>/dev/null | sort -V | tail -1; }

HINT_JQ='([.[]|select(.subtype=="away_summary")|.content]|last|if . then sub(" \\(disable recaps.*\\)$";"") else null end)
  // ([.[]|select(.type=="ai-title")|.aiTitle]|last)
  // ([.[]|select(.type=="last-prompt")|.lastPrompt]|last) // empty'

hint_of() { jq -rs "$HINT_JQ" "$1" 2>/dev/null | tr '\n\t' '  '; }
codex_sql() { sqlite3 -readonly -separator $'\t' "$CODEX_DB" "$@" 2>/dev/null; }

# Rows: <epoch>\t<tool>\t<id>\t<when>\t<hint>; callers strip the epoch after sorting.
list_claude() {
  local all=$1 f id hint
  [ -d "$DIR" ] || return 0
  for f in "$DIR"/*.jsonl; do
    [ -f "$f" ] || continue
    id=$(basename "$f" .jsonl); hint=$(hint_of "$f")
    if [ -z "$hint" ]; then [ "$all" = --all ] || continue; hint="(empty)"; fi
    printf '%s\tclaude\t%s\t%s\t%s\n' "$(date -r "$f" +%s)" "$id" "$(date -r "$f" '+%m-%d %H:%M')" "$hint"
  done
}

list_codex() {
  local all=$1
  [ -f "$CODEX_DB" ] && command -v sqlite3 >/dev/null || return 0
  codex_sql "select updated_at, 'codex', id, strftime('%m-%d %H:%M', updated_at, 'unixepoch', 'localtime'),
      replace(replace(coalesce(nullif(name,''), nullif(title,''), '(empty)'), char(10), ' '), char(9), ' ')
    from threads where archived = 0 and cwd = '${CWD//\'/\'\'}'" \
    | { [ "$all" = --all ] && cat || awk -F'\t' '$5 != "(empty)"'; }
}

cmd_list() {
  local all=${1:-}
  { list_claude "$all"; list_codex "$all"; } | sort -t$'\t' -k1,1nr | cut -f2-
}

cmd_preview() {
  local tool=$1 id=$2 f
  if [ "$tool" = codex ]; then
    f=$(codex_sql "select rollout_path from threads where id = '${id//\'/}'")
    [ -f "$f" ] || return 0
    echo "== codex: $(codex_sql "select replace(title, char(10), ' ') from threads where id = '${id//\'/}'")"; echo
    echo "== Last prompts"
    jq -r 'select(.type=="event_msg" and .payload.type=="user_message") | .payload.message | gsub("\n";" ") | .[0:200]' \
      "$f" 2>/dev/null | tail -3 | sed 's/^/- /'
  else
    f="$DIR/$id.jsonl"
    [ -f "$f" ] || return 0
    echo "== claude: $(hint_of "$f")"; echo
    echo "== Last prompts"
    jq -r 'select(.type=="user" and (.message.content|type)=="string" and (.isMeta|not) and (.message.content|startswith("<")|not))
           | .message.content | gsub("\n";" ") | .[0:200]' "$f" 2>/dev/null | tail -3 | sed 's/^/- /'
  fi
  echo; echo "$(du -h "$f" | cut -f1)  $id"
}

cmd_rm() {
  local tool=$1 id=$2 ans
  [[ $id =~ $UUID_RE ]] || { echo "refusing: not a session id: $id" >&2; return 1; }
  if [ "$tool" = codex ]; then
    [ -n "$(codex_sql "select 1 from threads where id = '$id' and cwd = '${CWD//\'/\'\'}'")" ] \
      || { echo "no such codex session in $CWD: $id" >&2; return 1; }
  else
    [ -f "$DIR/$id.jsonl" ] || { echo "no such claude session in $DIR: $id" >&2; return 1; }
  fi
  read -r -p "Delete $tool session $id? [y/N] " ans </dev/tty
  [[ $ans =~ ^[Yy]$ ]] || return 0
  if [ "$tool" = codex ]; then
    "$(codex_bin)" delete --force "$id" </dev/null
  else
    rm -rf -- "$DIR/$id.jsonl" "$DIR/$id" "$HOME/.claude/file-history/$id" "$HOME/.claude/session-env/$id"
  fi
  echo "deleted $tool $id"
}

resume_cmd() { [ "$1" = codex ] && echo "codex resume $2" || echo "claude --resume $2"; }

cmd_hint() {
  local skip=${1:-}
  cmd_list | awk -F'\t' -v s="$skip" '$2 != s' | head -"${CA_SESSIONS_MAX:-5}" \
    | while IFS=$'\t' read -r tool id when hint; do printf '# [%s] %s\n%s\n' "$when" "$hint" "$(resume_cmd "$tool" "$id")"; done
}

cmd_pick() {
  local out key tool id codex
  export CA_PROJECT_CWD=$CWD
  codex=$(codex_bin || true)
  # Vim-style modal picker: starts in normal mode (search hidden); / or i enters insert, esc leaves it.
  local n='[[ $FZF_INPUT_STATE = hidden ]] &&'
  local hdr='NORMAL j/k g/G ^d/^u · enter resume · o new claude · O new codex · d delete · / or i search · q quit'
  out=$(cmd_list --all | fzf --delimiter='\t' --with-nth=1,3,4 --no-sort --cycle \
    --header="$hdr" \
    --preview="$SELF preview {1} {2}" --preview-window=down,40%,wrap \
    --bind="start:hide-input" \
    --bind="j:transform:$n echo down || echo 'put(j)'" \
    --bind="k:transform:$n echo up || echo 'put(k)'" \
    --bind="g:transform:$n echo first || echo 'put(g)'" \
    --bind="G:transform:$n echo last || echo 'put(G)'" \
    --bind="ctrl-d:half-page-down,ctrl-u:half-page-up" \
    --bind="J:transform:$n echo preview-down || echo 'put(J)'" \
    --bind="K:transform:$n echo preview-up || echo 'put(K)'" \
    --bind="o:transform:$n echo 'become(claude)' || echo 'put(o)'" \
    --bind="O:transform:$n echo 'become(${codex:-codex})' || echo 'put(O)'" \
    --bind="d:transform:$n echo 'execute($SELF rm {1} {2})+reload($SELF list --all)' || echo 'put(d)'" \
    --bind="q:transform:$n echo abort || echo 'put(q)'" \
    --bind="i:transform:$n echo 'show-input+change-header(INSERT · esc: normal)' || echo 'put(i)'" \
    --bind="/:transform:$n echo 'show-input+change-header(INSERT · esc: normal)' || echo 'put(/)'" \
    --bind="esc:transform:$n echo abort || echo 'hide-input+change-header($hdr)'" \
  ) || return 0
  IFS=$'\t' read -r tool id _ <<<"$out"
  [ -n "$id" ] || return 0
  if [ "$tool" = codex ]; then exec "${codex:-codex}" resume "$id"; else exec claude --resume "$id"; fi
}

case "${1:-pick}" in
  list) cmd_list "${2:-}" ;;
  pick) cmd_pick ;;
  preview) cmd_preview "$2" "$3" ;;
  rm) cmd_rm "$2" "$3" ;;
  hint) cmd_hint "${2:-}" ;;
  help|-h|--help) sed -n '2,/^set -e/{/^set -e/d;s/^# \{0,1\}//;p}' "$SELF" ;;
  *) sed -n '2,/^set -e/{/^set -e/d;s/^# \{0,1\}//;p}' "$SELF" >&2; exit 2 ;;
esac
