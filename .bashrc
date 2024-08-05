# Apply settings only if interactive shell
case $- in
    *i*) 
        # Enable bash completion
        #if [ -f /etc/bash_completion ]; then
            #. /etc/bash_completion
        #fi
        # https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
        shopt -s globstar #  pattern ** used in a path name expansion
        shopt -s autocd
        shopt -s extglob    #  extended pattern matching
        shopt -s histappend #  append to history file specified by `HISTFILE`
        shopt -s cmdhist    # save all lines of a multiple-line command in the same history entry
        shopt -s lithist    # multi-line commands are saved to the history with embedded newlines
        shopt -s expand_aliases
        shopt -s nocaseglob #case-insensitive search
        shopt -s nullglob

        #resize bash
        [[ $DISPLAY ]] && shopt -s checkwinsize

        #complete command + file names
        complete -cf sudo

        function ps1_def() {
            ###------------------- PROMPT -----------------------###
            function parse_git_dirty {
                STATUS="$(git status 2> /dev/null)"
                if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
                if echo ${STATUS} | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
                if echo ${STATUS} | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
                if echo ${STATUS} | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
                if echo ${STATUS} | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
                if echo ${STATUS} | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
                if echo ${STATUS} | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
                printf " ]"
            }

            parse_git_branch() {
                    # Try to get the current branch name
                    local branch
                    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

                # Check if we're in a Git repository and if a branch name was found
                if [ $? -eq 0 ]; then
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

            #217 -pink
            CLEAR="\[$(tput el1)\]"
            RESET="\[$(tput sgr0)\]"
            GREEN="\[$(tput setaf 2)\]"
            DARK_GREEN="\[$(tput setaf 43 bold)\]"
            BRIGHTER_GREEN="\[$(tput setaf 23)\]"
            #HOT_PINK="\[$(tput setaf 204)\]"
            TEXT_GREEN="\[$(tput setaf 36)\]"
            GIT_COLOR="\[$(tput setaf 183)\]"
            NICE_RED="\[$(tput setaf 161)\]"
            BOLD="\[$(tput bold)\]"
            DIM="\[$(tput dim)\]"
            GITT="$GIT_COLOR\[\$(parse_git_branch)\$(parse_git_dirty)\]"

            EXITT="\[\$(exitstatus)\]"
            CARET=" "
            LEFT_PROMPT="\n$DIM$BOLD\[\w\] $RESET$EXITT$RESET"

            PS1="$CLEAR$DARK_GREEN$LEFT_PROMPT$RESET$GITT$EXITT\n$DARK_GREEN$CARET$RESET"
        }
        #PROMPT_COMMAND=ps1_def
        PS2="****"

        function aliaser() {
            #---------------FILE NAVIGATIONS-------------#
            alias dir.name='wl-copy -n <<< $(pwd)'
            alias lx='exa -lah'
            alias lss='ls -lah --color=auto'
            alias ls='ls -a --color=auto'
            alias ..="cd .."
            alias _="cd -"
            #alias -="cd $OLDPWD"

            #wev
            alias wev_sym="wev | grep 'sym'"

            # dunst
            alias dunstconf='nvim ~/.config/dunst/dunstrc'
            alias dunstr="killall dunst; dunstify 'Bazinga'"

            #---------------CONFIGURATION FILES--------------#
            alias kittyconf='v ~/.config/kitty/kitty.conf'
            alias diff='diff --color=auto'
            alias grep='grep --color=auto'

            alias sudo='sudo -v; sudo '
            alias q="exit"

            #█▄░█ █░█ █ █▀▄▀█
            #█░▀█ ▀▄▀ █ █░▀░█
            alias v="nvim"
            alias sv="sudo nvim"
            alias hypr="cd ~/.config/hypr/hypr-configs"
            alias customway_json='nvim ~/.config/waybar/modules_waybar.jsonc'
            alias cssway='nvim ~/.config/waybar/style.css'
            alias jway='nvim ~/.config/waybar/config.jsonc'
            alias pluglua="cd ~/.config/nvim/lua/plugins"
            alias mime="nvim ~/.config/mimeapps.list"
            alias bashv="nvim ~/.bashrc"

            #▄▀█ █▀█ █▀▀ █░█ ▄▄ █░█░█ █ █▄▀ █
            #█▀█ █▀▄ █▄▄ █▀█ ░░ ▀▄▀▄▀ █ █░█ █
            alias wiki="brave /usr/share/doc/arch-wiki/html/en"

            #█▄█ █▀█ █░█ ▀█▀ █░█ █▄▄ █▀▀
            #░█░ █▄█ █▄█ ░█░ █▄█ █▄█ ██▄
            alias ytm="yt-dlp --extract-audio --audio-format mp3"
            alias yt="yt-dlp"

            #█▀▀ █ ▀█▀
            #█▄█ █ ░█░
            alias .file="/usr/bin/git --git-dir=$HOME/GitLab --work-tree=$HOME"
        }

        function functioner() {
            fuego () {
                wl-copy -n < ~/Documents/rupurupu.txt && echo "Copy success :)"
            }

            #█▀█ ▄▀█ █▀▀ █▀▄▀█ ▄▀█ █▄░█
            #█▀▀ █▀█ █▄▄ █░▀░█ █▀█ █░▀█
            function p () {
                case $1 in
                    "S")
                        sudo pacman -S "$2"
                        ;;
                    "Ss")
                        pacman -Ss "$2"
                        ;;
                    "Rns")
                        sudo pacman -Rns "$2"
                        ;;
                    "Qm")
                        #foreign pkg/aur
                        pacman -Qm "$2"
                        ;;
                    "Qn")
                        #native pkg in sync db
                        pacman -Qn "$2"
                        ;;
                    "Qi")
                        pacman -Qi "$2"
                        ;;
                    "Qs")
                        pacman -Qs "$2"
                        ;;
                    "Qe")
                        #explicit packages
                        pacman -Qe "$2"
                        ;;
                    "Qd")
                        # filter packages , show deps only
                        pacman -Qd "$2"
                        ;;
                    "Syyu")
                        sudo pacman -Syyu
                        ;;
                    "Syu")
                        sudo pacman -Syu 
                        ;;
                    *)
                        pacman "$1"
                        ;;
                esac
            }

            #alias pac_cache_dir="cd /var/cache/pacman/pkg/"
            #alias last50="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 50"
            pacfzf () {
                pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)' 
            }

            cleanpac () {
                sudo pacman -Rns $(pacman -Qtdq)
            }

            unlock () {
                sudo rm /var/lib/pacman/db.lck
            }

            last_install () {
                expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 20
            }

            show_deps () {
                expac -S "%o" package
            }

            update_pkg_size () {
                expac -S -H M '%k\t%n' $(pacman -Qqu) | sort -sh
            }

            speedtest () {
                curl -S https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
            }

            ###---------- ARCHIVE EXTRACT ----------###
            unzip ()
            {
                if [ -f $1 ] ; then
                    case $1 in
                        *.tar.bz2)   tar xjf $1   ;;
                        *.tar.gz)    tar xzf $1   ;;
                        *.bz2)       bunzip2 $1   ;;
                        *.rar)       unrar x $1   ;;
                        *.gz)        gunzip $1    ;;
                        *.tar)       tar xf $1    ;;
                        *.tbz2)      tar xjf $1   ;;
                        *.tgz)       tar xzf $1   ;;
                        *.zip)       unzip $1     ;;
                        *.Z)         uncompress $1;;
                        *.7z)        7za e x $1   ;;
                        *.deb)       ar x $1      ;;
                        *.tar.xz)    tar xf $1    ;;
                        *.tar.zst)   unzstd $1    ;;
                        *)           echo "'$1' cannot be extracted via unzip()" ;;
                    esac
                else
                    echo "'$1' is not a valid file"
                fi
            }

            #run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
            #bind -m vi-insert -x '"\eh": run-help'

            function yy() {
                local yazi_tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
                yazi "$@" --cwd-file="$yazi_tmp"
                if cwd="$(cat -- "$yazi_tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                    cd -- "$cwd"
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
                    "-p")
                        task project:"$2" add "$3"
                        ;;
                    "-n")
                        task project:nvim add "$2"
                        ;;
                    "-d")
                        task done "${1}"
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

            function so ()
            {
                source ~/.bashrc
            }

            function libcan ()
            {
                case $1 in
                    "list")
                        eza -l /usr/share/sounds/freedesktop/stereo/
                        ;;
                    "cd")
                        cd /usr/share/sounds/freedesktop/stereo/
                        ;;
                esac
            }

            tput_colors ()
            {
                for C in {0..255}; do
                    tput setab $C
                    echo -n "$C "
                done
                echo
                tput sgr0
            }

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
                            "restart")
                                systemctl --user restart $3
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
                esac
            }

            math ()
            {
                echo "scale=2;$1" | bc
            }

            function R () {
                local r="shutdown -r"

                case "$1" in
                    "")
                        $r now
                        ;;
                    "shut")
                        case "$2" in
                            #default
                            "")
                            shutdown now
                            ;;
                        *)
                            shutdown +${2}
                            ;;
                    esac
                    ;;
                "c")
                    shutdown -c
                    ;;
                *)
                    ${r} +${1}
                    ;;
            esac
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

alias icat="kitten icat"

# zoxide
eval "$(zoxide init --cmd cd bash)"
