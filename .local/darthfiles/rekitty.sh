
function restart_kitty() {
    kill -SIGUSR1 $KITTY_PID
}
