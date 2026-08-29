#!/usr/bin/env bash
# Apply the per-workspace wallpaper on every monitor.
#
# Wallpapers live outside the nix config, in $WALLPAPER_DIR, named after the
# workspace they belong to: "<workspace-id>.<ext>", plus "default.<ext>" as the
# fallback. They are put there by `set-wallpaper`.
#
# awww (formerly swww) does the drawing: it keeps its own decoded-image cache and
# swaps the buffer atomically, so a change never exposes the bare background the
# way hyprpaper's redraw did.
# errexit off on purpose: a missing monitor or a stale daemon reply must not
# abort the whole pass.
set +e
set -uo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers}"

# Remembers what each monitor is showing, so an unchanged wallpaper is never
# re-sent. Lives in the runtime dir, so it is discarded on logout.
STATE="${WALLPAPER_STATE:-${XDG_RUNTIME_DIR:-/tmp}/hypr-wallpaper.state}"

# A short fade covers the gap between Hyprland announcing the workspace change
# and us reacting to it. Set to "none" for a hard cut.
TRANSITION="${WALLPAPER_TRANSITION:-wipe}"
TRANSITION_DURATION="${WALLPAPER_TRANSITION_DURATION:-0.5}"

# First file matching "<name>.*" in the wallpaper dir, resolved through symlinks.
lookup() {
  local name="$1" f
  for f in "$WALLPAPER_DIR/$name".*; do
    [ -e "$f" ] || continue
    realpath "$f"
    return 0
  done
  return 1
}

resolve() {
  lookup "$1" || lookup default
}

[ -d "$WALLPAPER_DIR" ] || exit 0

monitors=$(hyprctl -j monitors) || exit 1

# monitor name -> wallpaper it should display
declare -A want=()
while IFS=$'\t' read -r mon ws; do
  [ -n "$mon" ] || continue
  if path=$(resolve "$ws"); then
    want["$mon"]=$path
  fi
done < <(jq -r '.[] | [.name, (.activeWorkspace.id|tostring)] | @tsv' <<<"$monitors")

# What each monitor was showing at the end of the last pass.
declare -A shown=()
if [ -f "$STATE" ]; then
  while IFS=$'\t' read -r mon path; do
    [ -n "$mon" ] && shown["$mon"]=$path
  done < "$STATE"
fi

declare -A next=()
for mon in "${!want[@]}"; do
  path=${want[$mon]}
  if [ "${shown[$mon]:-}" = "$path" ]; then
    next["$mon"]=$path
    continue
  fi
  # A failure here (daemon not up yet, image rejected) leaves the monitor out of
  # the new state, so the next pass retries instead of trusting a change that
  # never landed.
  if awww img --outputs "$mon" \
       --transition-type "$TRANSITION" \
       --transition-duration "$TRANSITION_DURATION" \
       "$path" >/dev/null 2>&1; then
    next["$mon"]=$path
  fi
done

# Rewrite the state from scratch, so monitors that went away drop out.
: > "$STATE"
for mon in "${!next[@]}"; do
  printf '%s\t%s\n' "$mon" "${next[$mon]}" >> "$STATE"
done
