def main():
    pass


# This code toggles opacity and color schemes
def handle_result(args, answer, target_window_id, boss) -> None:
    import kitty.fast_data_types as f

    os_window_id = f.current_focused_os_window_id()
    current_opacity = f.background_opacity_of(os_window_id)
    if current_opacity == 1:
        boss.set_background_opacity("default")
        boss.set_colors("~/.cache/wal/colors-kitty.conf")
    else:
        boss.set_background_opacity("1")
        boss.set_colors("~/.config/kitty/themes/catppuccin.conf")


handle_result.no_ui = True
