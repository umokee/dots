{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  matugen = lib.elem "matugen" (vars.desktop.enable or [ ]);
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = lib.mkIf matugen "~/.config/fuzzel/colors.ini";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
        lines = 10;
        width = 50;
        horizontal-pad = 40;
        vertical-pad = 8;
        inner-pad = 0;
        image-size-limit = 64;
        show-actions = false;
      };

      border = {
        width = 0;
        radius = 0;
      };

      fonts = {
        #font = "Inter:size=18";
        icon-theme = "Papirus-Dark";
      };
    };
  };
}
