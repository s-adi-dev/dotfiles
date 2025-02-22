is_kitty() {
  [ "$TERM" = "xterm-kitty" ]
}

nvim() {
  is_kitty && kitty @ set-spacing padding=0
  command nvim "$@"
  is_kitty && kitty @ set-spacing padding=5
}

tmux() {
  is_kitty && kitty @ set-spacing padding=0
  command tmux "$@"
  is_kitty && kitty @ set-spacing padding=5
}
