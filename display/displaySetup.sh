#!/bin/bash
# sets up multi-monitor mode, run after x server init using optimus-manager dgpu config file

xrandr --output DP-4 --mode 1920x1080 --rate 144 --primary
xrandr --output DP-0 --mode 1920x1080 --rate 75 --right-of DP-4

xrandr --output eDP-1-1 --off


# force composition pipeline for all displays
# https://github.com/Askannz/nvidia-force-comp-pipeline
nvidia-force-comp-pipeline
