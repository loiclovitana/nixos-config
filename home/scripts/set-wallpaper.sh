#!/usr/bin/env bash
# set-wallpaper <workspace-id|default> <image>
#
# Links the image into the wallpaper directory under the workspace's name and
# refreshes hyprpaper. Use "default" for workspaces without their own image.
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers}"

usage() {
  echo "usage: set-wallpaper <workspace-id|default> <image>" >&2
  echo "       set-wallpaper --unset <workspace-id|default>" >&2
  exit 2
}

if [ "${1:-}" = "--unset" ]; then
  [ $# -eq 2 ] || usage
  rm -f "$WALLPAPER_DIR/$2".*
  hypr-wallpaper-apply || true
  echo "unset wallpaper for $2"
  exit 0
fi

[ $# -eq 2 ] || usage
target=$1
image=$2

case "$target" in
  default|[0-9]*) ;;
  *) echo "set-wallpaper: target must be a workspace id or 'default'" >&2; exit 2 ;;
esac

[ -f "$image" ] || { echo "set-wallpaper: no such file: $image" >&2; exit 1; }

image=$(realpath "$image")
ext=${image##*.}
[ "$ext" != "$image" ] || { echo "set-wallpaper: image needs a file extension" >&2; exit 1; }

mkdir -p "$WALLPAPER_DIR"
rm -f "$WALLPAPER_DIR/$target".*
ln -sf "$image" "$WALLPAPER_DIR/$target.$ext"

hypr-wallpaper-apply || true
echo "wallpaper for $target -> $image"
