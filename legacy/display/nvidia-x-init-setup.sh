#!/bin/bash
# For launching picom, autotiling (https://github.com/nwg-piotr/autotiling), and setting nvidia params


s="$(nvidia-settings -q CurrentMetaMode -t)"

if [[ "${s}" != "" ]]; then
  s="${s#*" :: "}"
  nvidia-settings -a CurrentMetaMode="${s//\}/, ForceCompositionPipeline=On\}}"
  nvidia-settings -a 'SyncToVBlank=0'
  nvidia-settings -a 'AllowFlipping=0'

  xrandr --output eDP-1-1  --off
  xrandr --output DP-4 --mode 1920x1080 --rate 144 --primary

fi

/home/nicholas/.config/polybar/launch.sh
picom -b
autotiling
