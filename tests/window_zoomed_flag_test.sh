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

if [[ "$window_current_format" != *'#{?window_zoomed_flag,'*'Z,}'* ]]; then
  echo "window-status-current-format should show Z when the current window is zoomed"
  echo "$window_current_format"
  exit 1
fi

if [[ "$window_current_format" != *'#{?window_zoomed_flag,#[fg=#dcd7ba]Z,}'* ]]; then
  echo "zoomed window marker should use the readable text color"
  echo "$window_current_format"
  exit 1
fi
