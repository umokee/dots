{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      curl
      wget
      tree
      unzip
      htop
      nano
      vim
      neovim

      lsof
      pciutils
      usbutils

      fd
      ripgrep

      p7zip
      iotop
      ffmpeg
      git

      gcc
      clang
      cmake
      gnumake
      pkg-config
      gdb

      home-manager
    ];
  };
}
