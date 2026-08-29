#!/usr/bin/env bash
# Watch Hyprland's event socket and re-apply the wallpaper whenever the
# focused workspace changes on any monitor.
set +e
set -uo pipefail

sock="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
STATE="${WALLPAPER_STATE:-${XDG_RUNTIME_DIR:-/tmp}/hypr-wallpaper.state}"

# Nothing is on screen yet, so whatever the last session recorded is a lie.
rm -f "$STATE"

# awww-daemon only answers its socket once it has bound the outputs.
for _ in $(seq 1 50); do
  awww query >/dev/null 2>&1 && break
  sleep 0.2
done

hypr-wallpaper-apply

socat -U - "UNIX-CONNECT:$sock" | while IFS= read -r line; do
  case "$line" in
    workspace\>\>*|workspacev2\>\>*|focusedmon*\>\>*|monitoradded*\>\>*|monitorremoved*\>\>*)
      hypr-wallpaper-apply
      ;;
  esac
done
