{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  services = {
    tumbler.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    dbus = {
      enable = true;
      implementation = "broker";
    };
  };

  programs = {
    dconf.enable = true;
  };

  system.stateVersion = "25.05";
}
