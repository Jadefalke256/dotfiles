#!/usr/bin/env bash

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Brightness Info
backlight="$(printf "%.0f\n" `brightnessctl g`)"
card="`brightnessctl -l | grep 'backlight' | head -n1 | cut -d'/' -f3`"

if [[ $backlight -ge 0 ]] && [[ $backlight -le 29 ]]; then
    level="Low"
elif [[ $backlight -ge 30 ]] && [[ $backlight -le 49 ]]; then
    level="Optimal"
elif [[ $backlight -ge 50 ]] && [[ $backlight -le 69 ]]; then
    level="High"
elif [[ $backlight -ge 70 ]] && [[ $backlight -le 100 ]]; then
    level="Peak"
fi

# Theme Elements
prompt="${backlight}%"
mesg="Device: ${card}, Level: $level"

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='4'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='4'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='4'
	win_width='425px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='4'
	list_row='1'
	win_width='550px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Increase"
	option_2=" Decrease"
else
	option_1=""
	option_2=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		brightnessctl s +5%
	elif [[ "$1" == '--opt2' ]]; then
		brightnessctl s 5%-
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
esac
