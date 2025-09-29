{
  config,
  lib,
  pkgs,
  inputs,
  tools,
  vars,
  ...
}:
let
  enable = lib.elem "niri" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    programs.niri.enable = true;

    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    environment.systemPackages = with pkgs; [
      alacritty
      wl-clipboard
      libnotify
      (xwayland-satellite.override { withSystemd = false; })
    ];

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf tools.isWayland {
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland,x11";
        WLR_NO_HARDWARE_CURSORS = "1";
      })
      (lib.mkIf tools.hasNvidia {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      })
    ];
  };
}
