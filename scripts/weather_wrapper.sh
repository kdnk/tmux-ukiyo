#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

#wrapper script for running weather on interval

fahrenheit=$1
location=$2
fixedlocation=$3

CACHE_DIR=${UKIYO_WEATHER_CACHE_DIR:-/tmp}
CACHE_KEY=$(printf '%s|%s|%s' "$fahrenheit" "$location" "$fixedlocation" | cksum | awk '{print $1}')
DATAFILE="${CACHE_DIR}/.ukiyo-tmux-data-${CACHE_KEY}"
LAST_EXEC_FILE="${CACHE_DIR}/.ukiyo-tmux-weather-last-exec-${CACHE_KEY}"
RUN_EACH=1200
TIME_NOW=$(date +%s)
TIME_LAST=$(cat "${LAST_EXEC_FILE}" 2>/dev/null || echo "0")

main() {
  current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  mkdir -p "$CACHE_DIR"

  if [ "$(expr ${TIME_LAST} + ${RUN_EACH})" -lt "${TIME_NOW}" ]; then
    # Run weather script here
    $current_dir/weather.sh $fahrenheit $location "$fixedlocation" >"${DATAFILE}"
    echo "${TIME_NOW}" >"${LAST_EXEC_FILE}"
  fi

  cat "${DATAFILE}"
}

#run main driver function
main
