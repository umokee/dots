{ lib }:
rec {
  hostname = "nixos-laptop";
  username = "user";

  dirs = {
    home = "/home/${username}";
    config = "${dirs.home}/.config";
  };

  colorScheme = "dark";
  wallpaperName = "backyard";

  userEmail = "hituaev@gmail.com";
  gitUsername = "umokee";

  default = {
    terminal = "alacritty";
    editor = "nvim";
    visual = "nvim";
    browser = "firefox";
  };

  displays = {
    monitors = [
      {
        name = "eDP-1";
        resolution = "2240x1400";
        refreshRate = "60";
        position = "0,0";
        rotate = "normal";
        scale = 1.5;
        enabled = true;
        primary = true;
      }
    ];
  };

  system = {
    enable = [
      "bootloader"
      "nix"
      "security"
      "locale"
      "network"
      "users"
    ];
  };

  hardware = {
    enable = [
      "peripherals"
      "amd_cpu"
      "power-management"
    ];

    config = {
      amd_cpu.laptop = true;
    };
  };

  desktop = {
    enable = [
      "displayManager"
      "niri"
      "fonts"
      "matugen"
      "wallpaper"
      "themes"
      "screenshots"
    ];
  };

  services = {
    enable = [
      "openssh"
      "kanata"
      "night_mode"
    ];
  };

  development = {
    enable = [
      "python"
      "nodejs"
      "tools"
    ];
  };
}
