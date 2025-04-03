from enum import Enum


class Theme(Enum):
    CATPPUCCIN = "catppuccin"
    TOKYO_NIGHT = "tokyo-night"


theme = Theme.CATPPUCCIN.value  # or Theme.CATPPUCCIN.value


def main():
    pass


def handle_result(args, answer, target_window_id, boss) -> None:
    import kitty.fast_data_types as f

    os_window_id = f.current_focused_os_window_id()
    current_opacity = f.background_opacity_of(os_window_id)

    if current_opacity == 1:
        boss.set_background_opacity("default")
        boss.set_colors("~/.cache/wal/colors-kitty.conf")
    else:
        boss.set_background_opacity("1")
        boss.set_colors(f"~/.config/kitty/themes/{theme}.conf")


handle_result.no_ui = True
