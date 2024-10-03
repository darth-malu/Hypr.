#!/bin/dash

# Current Theme
#dir="$HOME/.config/rofi/powermenu/type-1"
#dir="$HOME/.darth/scripts/rofi"
#theme='style-1'

uptime="$(uptime -p | sed -e 's/up //g')"
#host="$(hostname)"

# Options
shutdown="$(printf '⏻\tShutdown')"
reboot="$(printf '\tReboot')"
lock="$(printf '\tLock')"
suspend="$(printf '󰒲\tSuspend')"
logout="$(printf '\tLogout')"
timer="$(printf '󱫣\tTimer')"
cancel="$(printf '󰔞\tCancel')"

# confirmation
yes='  Yes'
#no='  No'
no='  No'

# main Rofi menu
# Rofi - Shows options, e.g. shutdown, reboot

rofi_main() {
    #-p "" \
	rofi -dmenu \
        -theme-str '#window {location: west; fullscreen: false; width: 300px; font: "GeistMono Nerd Font 12"; padding: 4;border: 1;}' \
		-theme-str 'mainbox {children: [ "message","inputbar", "listview" ];}' \
		-theme-str 'listview {columns: 1; lines: 7;cycle: false;fixed-height: false;dynamic: false;require-input: false;flow: center;}' \
		-theme-str 'inputbar {horizontal-align: 0.0; border: 0; children: [ "entry" ];}' \
		-theme-str 'entry {horizontal-align: 0.0; border: 0; blink: false;cursor-color: rgb(220,20,60);cursor-width: 8px;}' \
		-theme-str 'message {border: 0;}' \
        -theme-str 'element-text {horizontal-align: 0.0;vertical-align: 0.5;}' \
        -theme-str 'element {orientation: horizontal;}' \
		-mesg "$uptime" \
        -i 
        #-theme-str 'element-icon { orientation: vertical;}' \
            #-theme-str 'mainbox {children: [ "message", "listview", "inputbar" ];}' 
        #for case insens :)
        #-theme-str 'mainbox {children: [ "message", "entry", "listview" ];}' \
        #-theme-str '#window {location: south west; fullscreen: false; width: 220px; font: "GeistMono Nerd Font 12"; padding: 4;border: 1;}' \
}

# confirmation box
# Confirmation yes,no
confirm_actions() {
    rofi -dmenu \
        -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 245px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.0;}' \
		-theme-str 'textbox {horizontal-align: 0.0;}' \
		-p 'Confirmation' \
		-mesg 'Uko Sure?'
}

# Ask for confirmation, pass to confirm_actions
confirm_exit() {
	printf '%s\n%s\n' "$yes" "$no" | confirm_actions
    #printf "%s\n%s\n" "$yes" "$no" | confirm_actions
}

# Pass variables to rofi dmenu, aka rofi_main
# default -sep is \n lul ... why it works
run_rofi() {
	#echo -e "$lock\n$logout\n$reboot\n$suspend\n$shutdown" | rofi_main
	#echo -e "$lock\n$logout\n$reboot\n$suspend\n$shutdown" | rofi_main
    printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n" "$lock" "$logout" "$reboot" "$suspend" "$shutdown" "$timer" "$cancel"| rofi_main
}

restart_shut_timer_confirm() {
    rofi -dmenu \
        -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 150px; font: "JetBrainsMono Nerd Font 48"; padding: 0;border: 1;}' \
		-theme-str 'mainbox {children: [  "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 2; cycle: "true"; dynamic: "true";fixed-height: "true"; fixed-columns: "true"; spacing: 15px;}' \
		-theme-str 'element {horizontal-align: 0.5;padding:25px 10px 25px 0px;border: 1;margin:0px 0px 0px 0px;}' \
		-theme-str 'element-text {horizontal-align: 0.5;vertical-align: 0.5;}' \
		-theme-str 'message {border: 0;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-p 'Confirmation' \
		-mesg 'Zima ama Restart?'
}

SHUT="$(printf '⏻ ')"
RESTART="$(printf ' ')"
# menu itself
shut_or_restart() {
	printf "%s\n%s" "$RESTART" "$SHUT"  | restart_shut_timer_confirm
}

# pass answer to function
# Execute Command
run_cmd() {
    case "$1" in
        # custom timer
        "timer")
                restart_shut="$(shut_or_restart)"

                case "$restart_shut" in
                    "$RESTART")
                        shutdown -r +5
                        #notify-send "Restart in 5 min"
                        notify-send "Restarting in 5min " \
                            -i "/home/malu/Downloads/ICONS/icons8-restart-windows-11-color/icons8-restart-96.png"
                        canberra-gtk-play -i service-logout
                        ;;
                    "$SHUT")
                        notify-send "Shutting Down in 5min  " \
                            -i "/home/malu/Downloads/ICONS/icons8-shutdown-windows-11-color/icons8-shutdown-100.png"
                        shutdown +5 
                        canberra-gtk-play -i service-logout
                        #notify-send "Shutdown in 5 min"
                        ;;
                esac

                ;;
        "cancel")
                shutdown -c
                notify-send "Shutdown -c  " \
                    -i "/home/malu/Downloads/ICONS/icons8-multiply-windows-11-color/icons8-multiply-100.png"
                canberra-gtk-play -i window-attention
                ;;
            *)
                # standard options
                #selected="$(confirm_exit)"
                if [ "$(confirm_exit)" = "$yes" ]; then
                    case "$1" in
                        '--shutdown') systemctl poweroff ;;
                        '--reboot') systemctl reboot ;;
                        '--suspend') 
                            mpc -q pause
                            amixer set Master mute
                            systemctl suspend 
                            ;;
                        '--logout') hyprctl dispatch exit ;;
                    esac
                else
                    exit 0
                fi
                ;;
                esac
}

# Actions: rofi_main to run_cmd(action affirmation. eg. shutdown)
chosen="$(run_rofi)"
case ${chosen} in
    "$shutdown")run_cmd --shutdown;;
    "$reboot")run_cmd --reboot;;
    #"$lock")hyprlock;;
    "$lock")dash -c ~/.config/hypr/scripts/sway_lock_idle/lock.sh;;
    "$suspend")run_cmd --suspend;;
    "$logout")run_cmd --logout;;
    "$timer")run_cmd timer;;
    "$cancel")run_cmd cancel;;
esac
		#if [[ $1 == '--shutdown' ]]; then
			#systemctl poweroff
		#elif [[ $1 == '--reboot' ]]; then
			#systemctl reboot
		#elif [[ $1 == '--suspend' ]]; then
			#mpc -q pause
			#amixer set Master mute
			#systemctl suspend
		#elif [[ $1 == '--logout' ]]; then
            #hyprctl dispatch exit
		#fi
