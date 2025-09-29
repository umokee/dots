{
  config,
  lib,
  pkgs,
  vars,
  tools,
  inputs,
  ...
}:
let
  hasWM = tools.isWayland || tools.isX11;
in
{
  config = lib.mkIf hasWM {
    xdg.portal = {
      enable = true;
      wlr.enable = tools.needsWlrPortal;
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-gtk
        ]
        ++ lib.optionals tools.needsHyprlandPortal [
          xdg-desktop-portal-hyprland
        ]
        ++ lib.optionals tools.needsWlrPortal [
          xdg-desktop-portal-wlr
        ]
        ++ lib.optionals tools.needsKDEPortal [
          xdg-desktop-portal-kde
        ]
        ++ lib.optionals tools.needsNiriPortal [
          inputs.niri.packages.${pkgs.system}.xdg-desktop-portal-niri
        ]
        ++ lib.optionals tools.needsGnomePortal [
          xdg-desktop-portal-gnome
        ];

      config.common.default = "*";
    };

    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    environment.systemPackages = with pkgs; [
      xdg-utils
      desktop-file-utils
    ];
  };
}
