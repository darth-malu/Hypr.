# Apply settings only if inteactive shell
case $- in
    *i*) 
        # Enable bash completion
        #if [ -f /etc/bash_completion ]; then
            #. /etc/bash_completion
        #fi
        # https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
        shopt -s globstar #  pattern ** used in a path name expansion
        # shopt -s autocd # cd to dir without cd basically
        shopt -s extglob    #  extended pattern matching
        shopt -s histappend #  append to history file specified by `HISTFILE`
        shopt -s cmdhist    # save all lines of a multiple-line command in the same history entry
        shopt -s lithist    # multi-line commands are saved to the history with embedded newlines
        #shopt -s nocaseglob #case-insensitive search
        shopt -s nullglob
        shopt -s failglob
        #shopt -s extquote # on by default
        shopt -s cdspell
        shopt -s direxpand
        shopt -s dotglob

        # Enabled by default
        #resize bash
        #[[ $DISPLAY ]] && shopt -s checkwinsize #updates $LINES and $COLUMNS on window size change
        #shopt -s expand_aliases 

        #complete command + file names
        complete -cf sudo

        function ps1_def() {
            ###------------------- PROMPT -----------------------###
            function parse_git_dirty {
                STATUS="$(git status 2> /dev/null)"
                #if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
                if [[ ! STATUS = "$(git status 2> /dev/null)" ]]; then printf ""; return; else printf " ["; fi
                if echo "${STATUS}" | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
                if echo "${STATUS}" | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
                if echo "${STATUS}" | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
                if echo "${STATUS}" | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
                if echo "${STATUS}" | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
                if echo "${STATUS}" | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
                printf " ]"
            }

            parse_git_branch() {
                    # Try to get the current branch name
                    local branch
                    
                # Check if we're in a Git repository and if a branch name was found
                if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
                    # If there is a branch name, print it
                    echo " $branch"
                elif [ "$branch" = "HEAD" ]; then
                    # Detached HEAD state
                    echo "  detached HEAD"
                fi
            }

            exitstatus() {
                # Capture the exit status of the last command
                local status=$?

                # Check if the status is non-zero
                if [[ $status -ne 0 ]]; then
                    # Set color to red and display the status
                    tput setaf 161
                    echo -n " $status "
                    tput sgr0
                    # Reset color
                fi
            }

            workon_env_indicator() {
                if [ -n "$VIRTUAL_ENV" ];then
                    x="${VIRTUAL_ENV##*/}"
                    printf '%s \n' "$x"
                fi
            }

            #217 -pink
            CLEAR="\[$(tput el1)\]"
            RESET="\[$(tput sgr0)\]"
            DARK_GREEN="\[$(tput setaf 43 bold)\]"
            # GREEN="\[$(tput setaf 2)\]"
            # BRIGHTER_GREEN="\[$(tput setaf 23)\]"
            # HOT_PINK="\[$(tput setaf 204)\]"
            # TEXT_GREEN="\[$(tput setaf 36)\]"
            # NICE_RED="\[$(tput setaf 161)\]"
            GIT_COLOR="\[$(tput setaf 183)\]"
            BOLD="\[$(tput bold)\]"
            DIM="\[$(tput dim)\]"

            GITT="$GIT_COLOR\[\$(parse_git_branch)\$(parse_git_dirty)\]"
            EXITT="\[\$(exitstatus)\]"
            WORK="\[\$(workon_env_indicator)\]"
            CARET=" "
            GIT_PWD="\n$DIM$BOLD\[\w\] $RESET$EXITT$RESET"

            # PS1="$CLEAR$DARK_GREEN$LEFT_PROMPT$RESET$GITT$EXITT\n$DARK_GREEN$CARET$RESET"
            PS1="$CLEAR$DARK_GREEN$GIT_PWD$RESET$GITT$EXITT\n$WORK$DARK_GREEN$CARET$RESET"
        }

        PS2="* -->"

        function aliaser() {
            #---------------FILE NAVIGATIONS-------------#
            alias dir.name='wl-copy -n <<< $(pwd)'
            #alias rofi_font='ls ~/.local/share/fonts /usr/share/fonts|grep -vE "\.+|malu" | rofi -dmenu -i -p "Ingester themes" | wl-copy -n'
            alias rofi_font='ls ~/.local/share/fonts /usr/share/fonts |grep -vE "^\.+$" | rofi -dmenu -i -p "Ingester themes" | wl-copy -n'
            alias rofi_theme='ls /usr/share/themes/ | rofi -dmenu -i -p "/usr/share/theme" | wl-copy -n'
            alias rofi_desktop='ls /usr/share/applications/ | rofi -dmenu -i -p ".desktop"| wl-copy -n'
            alias lx='exa -lah'
            alias lss='ls -lah --color=auto'
            alias ls='ls -a --color=auto'
            alias ..="cd .."
            alias _="cd -"
            #alias -="cd $OLDPWD"
            alias duf="duf -hide special"

            # dunst
            alias dunstconf='nvim ~/.config/dunst/dunstrc'

            #---------------CONFIGURATION FILES--------------#
            #alias kittyconf='v ~/.config/kitty/kitty.conf'
            alias diff='diff --color=auto'
            alias grep='grep --color=auto'

            alias sudo='sudo -v; sudo '
            alias q="exit"

            #█▄░█ █░█ █ █▀▄▀█
            #█░▀█ ▀▄▀ █ █░▀░█
            alias v="nvim"
            alias sv="sudo nvim"
            alias hypr="cd ~/.config/hypr/hypr-configs"
            #alias mime="nvim ~/.config/mimeapps.list"
            alias bashv="nvim ~/.bashrc"

            #▄▀█ █▀█ █▀▀ █░█ ▄▄ █░█░█ █ █▄▀ █
            #█▀█ █▀▄ █▄▄ █▀█ ░░ ▀▄▀▄▀ █ █░█ █
            alias wiki="brave /usr/share/doc/arch-wiki/html/en"

            #█▄█ █▀█ █░█ ▀█▀ █░█ █▄▄ █▀▀
            #░█░ █▄█ █▄█ ░█░ █▄█ █▄█ ██▄
            alias yta="yt-dlp --extract-audio --audio-format mp3"
            alias yt="yt-dlp"

            #█▀▀ █ ▀█▀
            #█▄█ █ ░█░
            alias .file="/usr/bin/git --git-dir=$HOME/GitLab --work-tree=$HOME"

            alias p='pacman'
            alias sp='sudo pacman'
        }

        function functioner() {

            fuego () {
                #wl-copy -n < ~/Documents/rupurupu.txt && echo "Copy success :)"
                #wl-copy -n < ~/Documents/fragger.txt && echo "Copy success :)"
                wl-copy -n < ~/Documents/frag.txt && echo "Copy success :)"
            }

            #lusb () {
                #lsusb | grep -v Linux
            #}

            #█▀█ ▄▀█ █▀▀ █▀▄▀█ ▄▀█ █▄░█
            #█▀▀ █▀█ █▄▄ █░▀░█ █▀█ █░▀█

            #alias pac_cache_dir="cd /var/cache/pacman/pkg/"
            #alias last50="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 50"
            pacfzf () {
                pacman -Qq | fzf --multi --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)' 
            }

            cleanpac () {
                sudo pacman -Rns $(pacman -Qtdq) # you want word splits for each result...dont quote
            }

            unlock () {
                sudo rm /var/lib/pacman/db.lck
            }

            last_install () {
                expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 20
            }

            #show_deps () {
                #expac -S "%o" package
            #}

            update_pkg_size () {
                expac -S -H M '%k\t%n' $(pacman -Qqu) | sort -sh
            }

            speedtest () {
                curl -S https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
            }

            ###---------- ARCHIVE EXTRACT ----------###
            # unzip ()
            # {
                # if [ -f $1 ] ; then
                    # case $1 in
                        # *.tar.bz2)   tar xjf $1   ;;
                        # *.tar.gz)    tar xzf $1   ;;
                        # *.bz2)       bunzip2 $1   ;;
                        # *.rar)       unrar x $1   ;;
                        # *.gz)        gunzip $1    ;;
                        # *.tar)       tar xf $1    ;;
                        # *.tbz2)      tar xjf $1   ;;
                        # *.tgz)       tar xzf $1   ;;
                        # *.zip)       unzip $1     ;;
                        # *.Z)         uncompress $1;;
                        # *.7z)        7za e x $1   ;;
                        # *.deb)       ar x $1      ;;
                        # *.tar.xz)    tar xf $1    ;;
                        # *.tar.zst)   unzstd $1    ;;
                        # *)           echo "'$1' cannot be extracted via unzip()" ;;
                    # esac
                # else
                    # echo "'$1' is not a valid file or other errror :)"
                # fi
            # }

            #run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
            #bind -m vi-insert -x '"\eh": run-help'

            function yy() {
                local yazi_tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$yazi_tmp"
                if cwd="$(cat -- "$yazi_tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                    builtin cd -- "$cwd"
                fi
                rm -f -- "$yazi_tmp"
            }

            function gset() {
                case "$1" in
                    "theme")
                        #Adapta-Nokto
                        gsettings set org.gnome.desktop.interface gtk-theme "$2"
                        ;;
                    "cursor")
                        #Bibata-Modern-Ice
                        gsettings set org.gnome.desktop.interface cursor-theme "$2"
                        ;;
                    "color")
                        #prefer-dark
                        gsettings set org.gnome.desktop.interface color-scheme "$2" 
                        ;;
                    "font")
                        #JetBrainsMonoNL Nerd Font Propo Bold Italic 10
                        gsettings set org.gnome.desktop.interface font-name "$2"
                        ;;
                    "icon")
                        gsettings set org.gnome.desktop.interface icon-theme "$2" 
                esac
            }

            function gget() {
                case "$1" in
                    "theme")
                        #Adapta-Nokto
                        gsettings get org.gnome.desktop.interface gtk-theme
                        ;;
                    "cursor")
                        #Bibata-Modern-Ice
                        gsettings get org.gnome.desktop.interface cursor-theme 
                        ;;
                    "color")
                        #prefer-dark
                        gsettings get org.gnome.desktop.interface color-scheme
                        ;;
                    "font")
                        #JetBrainsMonoNL Nerd Font Propo Bold Italic 10
                        gsettings get org.gnome.desktop.interface font-name
                        ;;
                    "icon")
                        gsettings get org.gnome.desktop.interface icon-theme 
                esac
            }

            function t ()
            {
                case $1 in
                    "-a")
                        #t -a "Bok"
                        task add project:arch "$2"
                        ;;
                    "-t")
                        #t -a "Bok"
                        task add project:teal "$2"
                        ;;
                    "-p")
                        task project:"$2" add "$3"
                        ;;
                    "-n")
                        task project:nvim add "$2"
                        ;;
                    "-l")
                        task list
                        ;;
                    "-ln"|"-nl")
                        task list project:nvim
                        ;;
                    "-la"|"-al")
                        task list project:arch
                        ;;
                    *)
                        task add "${1}"
                        ;;
                esac
            }

            #function so ()
            #{
                #source ~/.bashrc
            #}

            #function libcan ()
            #{
                #case $1 in
                    #"list")
                        #eza -l /usr/share/sounds/freedesktop/stereo/
                        #;;
                    #"cd")
                        #cd /usr/share/sounds/freedesktop/stereo/
                        #;;
                #esac
            #}

            #tput_colors ()
            #{
                #for C in {0..255}; do
                    #tput setab $C
                    #echo -n "$C "
                #done
                #echo
                #tput sgr0
            #}

            hyprl () {
                hyprctl clients | less
            }

            sys () {
                case $1 in
                    "user")
                        case $2 in
                            "start")
                                systemctl --user start $3
                                ;;
                            "stop")
                                systemctl --user stop $3
                                ;;
                            "status")
                                systemctl --user status $3
                                ;;
                            "enable")
                                systemctl --user enable $3
                                ;;
                            "restart")
                                systemctl --user restart $3
                                ;;
                            "daemon")
                                systemctl --user daemon-reload
                                ;;
                        esac
                        ;;
                    "start")
                        systemctl start $2
                        ;;
                    "stop")
                        systemctl stop $2
                        ;;
                    "status")
                        systemctl status $2
                        ;;
                    "restart")
                        systemctl restart $2
                        ;;
                    "enable")
                        systemctl enable $2
                        ;;
                    "disable")
                        systemctl disable $2
                        ;;
                    "daemon")
                        systemctl daemon-reload
                        ;;
                    *)
                        echo "Sys function failed...check bashv"
                        ;;
                esac
            }

            math ()
            {
                echo "scale=2;$1" | bc
            }

            sec_to_min() {
                local total_seconds=$1

                # Check if the input is a valid number
                if ! [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input: Please provide a positive integer."
                    return 1
                fi

                # Calculate hours, minutes, and seconds
                local hours=$((total_seconds / 3600))
                local minutes=$(((total_seconds % 3600) / 60))
                local seconds=$((total_seconds % 60))

                # Format the output
                echo "${hours} hours, ${minutes} minutes, and ${seconds} seconds"
            }

            min_to_sec() {
                local minutes=$1

                # Check if the input is a valid number
                if ! [[ "$minutes" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input: Please provide a positive integer."
                    return 1
                fi

                # Calculate seconds
                local seconds=$((minutes * 60))

                # Format the output
                echo "${minutes} minutes == ${seconds} seconds"
            }

            hour_to_sec() {
                local hours=$1

                # Check if the input is a valid number
                if ! [[ "$hours" =~ ^[0-9]+$ ]]; then
                    echo "Invalid input: Please provide a positive integer."
                    return 1
                fi

                # Calculate seconds
                local seconds=$((hours * 3600))

                # Format the output
                echo "${hours} hours is equal to ${seconds} seconds"
            }

        }

        #---------------SYSTEM MANAGEMENT--------------#
        #alias mkdir="mkdir -vp"
        #alias cpu5="ps auxf | sort -nr -k 3 | head -5"
        #alias mem5="ps auxf |  sort -nr -k 4 | head -5"

        ps1_def
        aliaser
        functioner
        ;;
    *) 
        return
        ;;
esac


# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper_lazy.sh

alias icat="kitten icat"

# zoxide
eval "$(zoxide init --cmd cd bash)"
