#!/bin/sh
set -eu

ACTION="${1:-up}"
ROOT_DIR="${2:-$(cd "$(dirname "$0")" && pwd)}"

case "$ACTION" in
  up)   run() { docker compose up -d; } ;;
  down) run() { docker compose down; } ;;
  stop) run() { docker compose stop; } ;;
  *) echo "Usage: $0 {up|down|stop} [dir]" >&2; exit 1 ;;
esac

failed=""
for dir in "$ROOT_DIR"/*/; do
  [ -d "$dir" ] || continue
  (cd "$dir" && run) || failed="$failed $(basename "$dir")"
done

[ -n "$failed" ] && { echo "Failed:$failed" >&2; exit 1; }