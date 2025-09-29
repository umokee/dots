{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    lsd
    btop
    zip
    upower
    ntfs3g

    obsidian
    qimgv
    pavucontrol
    onlyoffice-bin
    blueman
    easyeffects
    czkawka-full
    piper
    file-roller
    mullvad-browser
    tor-browser
    telegram-desktop
    discord

    #gtk3
    #imagemagick
  ];
}
