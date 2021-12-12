function pre_backup() {
        mkdir -p "$HOME/dump"
}

function post_backup() {
        rm -rf "$HOME/dump"
}
