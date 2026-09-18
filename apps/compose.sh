#!/bin/sh
set -eu

# Folders to skip - space separated list of folder names
EXCLUDE=""

ACTION="${1:-up}"
ROOT_DIR="${2:-$(cd "$(dirname "$0")" && pwd)}"

case "$ACTION" in
  up)   run() { docker compose up -d; } ;;
  down) run() { docker compose down; } ;;
  stop) run() { docker compose stop; } ;;
  *) echo "Usage: $0 {up|down|stop} [dir]" >&2; exit 1 ;;
esac

for dir in "$ROOT_DIR"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"

  case " $EXCLUDE " in
    *" $name "*) continue ;;
  esac

  (cd "$dir" && run) || echo "failed: $name" >&2
done