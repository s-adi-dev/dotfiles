import os
import re

LUA_CONFIG_PATH = os.path.expanduser("~/.config/nvim/lua/ui/base.lua")


def main():
    pass


def update_lua_theme(pywal: bool):
    """Update the theme in the Lua config file."""
    new_theme = "chadwal" if pywal else "catppuccin"

    # Read the Lua config
    with open(LUA_CONFIG_PATH, "r") as file:
        content = file.read()

    # Replace the theme line
    updated_content = re.sub(
        r'theme\s*=\s*".*?"', f'theme = "{new_theme}"', content
    )

    # Write back the updated config
    with open(LUA_CONFIG_PATH, "w") as file:
        file.write(updated_content)


def handle_result(args, answer, target_window_id, boss) -> None:
    import kitty.fast_data_types as f

    os_window_id = f.current_focused_os_window_id()
    current_opacity = f.background_opacity_of(os_window_id)

    if current_opacity == 1:
        boss.set_background_opacity("default")
        boss.set_colors("~/.cache/wal/colors-kitty.conf")
        update_lua_theme(pywal=True)  # Switch to "chadwal"
    else:
        boss.set_background_opacity("1")
        boss.set_colors("~/.config/kitty/themes/catppuccin.conf")
        update_lua_theme(pywal=False)  # Switch to "catppuccin"


handle_result.no_ui = True
