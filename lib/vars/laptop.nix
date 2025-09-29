{ lib }:
rec {
  hostname = "nixos-laptop";
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

  system = {
    enable = [
      "bootloader"
      "nix"
      "security"
      "locale"
      "network"
      "users"
    ];

    config = {
      bootloader.loader = "systemd-boot";
    };
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
