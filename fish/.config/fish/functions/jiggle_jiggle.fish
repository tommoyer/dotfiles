
# Move the mouse
#
function jiggle_jiggle -d "Move the mouse"
  while true
    xdotool mousemove 100 500
    sleep 60
    xdotool mousemove 500 100
    sleep 60
  end
end
