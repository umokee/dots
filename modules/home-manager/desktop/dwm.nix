{ config, lib, pkgs, ... }:

let
  cfg = config.desktop.dwm;
in
{
  options.desktop.dwm = {
    enable = lib.mkEnableOption "DWM user configuration";
  };

  config = lib.mkIf cfg.enable {
    home.file.".xinitrc".text = ''
      feh --bg-scale ~/wallpaper.jpg &
 
      rofi &
      
      #nm-applet &
      #blueman-applet &
      
      # picom &
      
      exec dwm
    '';
  };
}
