if [ -f ~/scripts/setup-monitor.sh.local ]; then
    ~/scripts/setup-monitor.sh.local
else
    xrandr -s 0  # Just resetting everything by default
fi
