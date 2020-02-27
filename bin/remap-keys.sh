(killall xcape || echo "No xcape running") && xkbcomp ~/.xkb $DISPLAY && xcape -e "Hyper_L=Escape"
