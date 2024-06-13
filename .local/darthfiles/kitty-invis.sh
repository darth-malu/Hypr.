default="hyprctl keyword dwindle:no_gaps_when_only 1"
glass_kitty="hyprctl keyword dwindle:no_gaps_when_only 0"
# Arbitrary but unique message tag
# For dunst classifaction
msgTag="kitty_invis"

gaps_status=$(hyprctl getoption dwindle:no_gaps_when_only | grep int | awk '{print $2}')

if [[ "$gaps_status" == "1" ]]; then
    dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid \
        -h string:x-dunst-stack-tag:$msgTag "Gaps:Zero " 
    $gaps_0 > /dev/null
elif [[ "$gaps_status" == "0" ]]; then
    dunstify -t 1000 -a "changegaps" -u low -i volume-xmark-solid \
        -h string:x-dunst-stack-tag:$msgTag "Gaps:True" 
    $gaps_1 > /dev/null
fi



