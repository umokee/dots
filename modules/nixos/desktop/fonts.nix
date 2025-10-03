{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "fonts" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    fonts = {
      packages = with pkgs; [
        dejavu_fonts
        liberation_ttf

        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.caskaydia-cove

        font-awesome

        montserrat
        inter
        roboto

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        source-han-sans
        source-han-serif

        corefonts
        vistafonts

        nerd-fonts.hack
        nerd-fonts.inconsolata
        nerd-fonts.sauce-code-pro
      ];

      fontconfig = {
        enable = true;
        antialias = true;
        hinting.enable = true;
        hinting.style = "slight";
        subpixel.rgba = "rgb";

        defaultFonts = {
          serif = [ "DejaVu Serif" ];
          sansSerif = [ "DejaVu Sans" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };
  };
}
