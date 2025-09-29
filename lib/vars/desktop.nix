{ lib }:
rec {
  hostname = "nixos-desktop";
  username = "user";

  dirs = {
    home = "/home/${username}";
    config = "${dirs.home}/.config";
  };

  colorScheme = "dark";
  wallpaper = "${dirs.home}/Pictures/wallpapers/Backyard.png"; 

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
        name = "DP-3";
        resolution = "2560x1440";
        refreshRate = "165";
        position = "0,0";
        rotate = "normal";
        scale = 1.0;
        enabled = true;
        primary = true;
      }
      {
        name = "DP-4";
        resolution = "1920x1080";
        refreshRate = "100";
        position = "2560,0";
        rotate = "right";
        scale = 1.0;
        enabled = true;
        primary = false;
      }
      {
        name = "HDMI-A-5";
        resolution = "1920x1080";
        refreshRate = "60";
        position = "510,1440";
        rotate = "normal";
        scale = 1.5;
        enabled = true;
        primary = false;
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
      "sound"
      "peripherals"
      "intel_cpu"
      "nvidia"
      "power-management"
    ];
  };

  desktop = {
    enable = [
      "displayManager"
      "hyprland"
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
      "singbox"
      "night_mode"
      "vm"
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
