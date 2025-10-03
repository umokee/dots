{ config, pkgs, lib, vars, ... }:
let
  matugen = lib.elem "matugen" (vars.desktop.enable or [ ]);
in
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;

    settings = {
      general = lib.mkIf matugen {
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
