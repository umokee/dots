{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gvfs
    xfce.xfconf

    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
  ];
}
