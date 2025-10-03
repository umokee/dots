{ config, pkgs, system, inputs, ... }:
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
    easyeffects
    czkawka-full
    piper
    file-roller
    mullvad-browser
    tor-browser
    telegram-desktop
    discord
    libreoffice-fresh
    jetbrains.rider
    #gtk3
    #imagemagick
    vlc

    bottles
    atool
    unrar
    peazip
  ];
}
