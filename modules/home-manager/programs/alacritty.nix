{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;

    settings = {
      general = {
        import = [ "~/.config/alacritty/colors.toml" ];
      };
      window = {
        padding = { x = 15; y = 15; };
        dynamic_padding = true;
        decorations = "Full";
        startup_mode = "Windowed";
        opacity = 0.95;
      };
      font.normal = { family = "FiraCode Nerd Font"; };
      font.size = 18;
      selection.save_to_clipboard = true;
      mouse.bindings = [
        {
          mouse = "Right";
          action = "Paste";
        }
      ];
    };
  };
}
