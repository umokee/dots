{
  config,
  lib,
  pkgs,
  vars,
  tools,
  ...
}:
let
  enable = lib.elem "hyprland" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alacritty
      wl-clipboard
      libnotify
    ];

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf tools.isWayland {
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland,x11";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      })
      (lib.mkIf tools.hasNvidia {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      })
    ];
  };
}
