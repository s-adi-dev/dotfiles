is_kitty() {
  [ "$TERM" = "xterm-kitty" ]
}

nvim() {
  is_kitty && kitty @ set-spacing padding=0
  command nvim "$@"
  is_kitty && kitty @ set-spacing padding=5
}
