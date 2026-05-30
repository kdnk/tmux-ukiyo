#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

scripts_dir="$tmp_dir/scripts"
cache_dir="$tmp_dir/cache"
mkdir -p "$scripts_dir" "$cache_dir"

cp "$repo_root/scripts/weather_wrapper.sh" "$scripts_dir/weather_wrapper.sh"
chmod +x "$scripts_dir/weather_wrapper.sh"

cat >"$scripts_dir/weather.sh" <<'STUB'
#!/usr/bin/env bash
printf 'fresh weather for %s %s %s\n' "$1" "$2" "$3"
STUB
chmod +x "$scripts_dir/weather.sh"

printf 'stale weather\n' >"$cache_dir/.ukiyo-tmux-data"
date +%s >"$cache_dir/.ukiyo-tmux-weather-last-exec"

actual="$(UKIYO_WEATHER_CACHE_DIR="$cache_dir" "$scripts_dir/weather_wrapper.sh" false true Tokyo)"

if [ "$actual" != "fresh weather for false true Tokyo" ]; then
  echo "weather wrapper should not reuse cache from a different argument set"
  echo "actual: $actual"
  exit 1
fi
