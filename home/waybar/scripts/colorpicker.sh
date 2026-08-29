#!/usr/bin/env bash
set -euo pipefail

loc="$HOME/.cache/colorpicker"
mkdir -p "$loc"
[ -f "$loc/colors" ] || touch "$loc/colors"

limit=10

if [[ $# -eq 1 && $1 = "-j" ]]; then
  color="$(head -n 1 "$loc/colors")"
  tooltip="COLORS\n"
  mapfile -t allcolors < <(tail -n +2 "$loc/colors")

  if [ -n "$color" ]; then
    tooltip+="-> $color\n"
  fi
  for c in "${allcolors[@]}"; do
    tooltip+="   $c\n"
  done

  icon="󰈊"
  if [ -n "$color" ]; then
    text="$icon <span color='$color'>●</span>"
  else
    text="$icon ○"
  fi

  printf '{ "text": "%s", "tooltip": "%s" }\n' "$text" "$tooltip"
  exit 0
fi

command -v hyprpicker >/dev/null || {
  notify-send -a "Color Picker" "hyprpicker is not installed"
  exit 1
}

color=$(hyprpicker -a)

if [ -n "$color" ]; then
  prevColors=$(head -n $((limit - 1)) "$loc/colors")
  {
    echo "$color"
    echo "$prevColors"
  } | sed '/^$/d' >"$loc/colors.tmp"
  mv "$loc/colors.tmp" "$loc/colors"
fi

pkill -RTMIN+1 waybar || true
