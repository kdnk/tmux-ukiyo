#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

log_file="$tmp_dir/tmux.log"
mkdir -p "$tmp_dir/bin"

cat >"$tmp_dir/bin/tmux" <<'STUB'
#!/usr/bin/env bash
case "$1" in
show-options)
  exit 0
  ;;
show-option)
  if [ "${*: -1}" = "@ukiyo-show-powerline" ]; then
    printf 'true\n'
  fi
  exit 0
  ;;
set-option | set-window-option | bind-key)
  printf '%s\n' "$*" >>"$TMUX_STUB_LOG"
  exit 0
  ;;
*)
  exit 0
  ;;
esac
STUB
chmod +x "$tmp_dir/bin/tmux"

TMUX_STUB_LOG="$log_file" PATH="$tmp_dir/bin:$PATH" bash "$repo_root/scripts/ukiyo.sh"

window_current_format="$(grep 'set-window-option -g window-status-current-format' "$log_file")"
window_format="$(grep 'set-window-option -g window-status-format' "$log_file")"
first_status_right="$(grep 'set-option -ga status-right' "$log_file" | head -n 1)"

if [[ "$window_current_format" != *'#{?client_prefix,'* ]]; then
  echo "window-status-current-format should use the prefix-aware status background"
  echo "$window_current_format"
  exit 1
fi

if [[ "$window_format" != *'#{?client_prefix,'* ]]; then
  echo "window-status-format should use the prefix-aware status background"
  echo "$window_format"
  exit 1
fi

if [[ "$first_status_right" != *'bg=#{?client_prefix,'* ]]; then
  echo "status-right should start from the prefix-aware status background"
  echo "$first_status_right"
  exit 1
fi
