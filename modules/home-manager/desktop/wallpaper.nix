{
  config,
  pkgs,
  lib,
  vars,
  tools,
  wallpapers,
  ...
}:
let
  enable = lib.elem "wallpaper" (vars.desktop.enable or [ ]);
  wallpaper = wallpapers.${vars.wallpaperName} or wallpapers.backyard;
in
{
  config = lib.mkIf enable (
    lib.mkMerge [
      (lib.mkIf tools.isWayland {
        home.packages = [ pkgs.swaybg ];

        systemd.user.services.swaybg-daemon = {
          Unit = {
            Description = "Swaybg Wallpaper Daemon";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill";
            Restart = "on-failure";
            RestartSec = "3";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      })

      (lib.mkIf tools.isX11 {
        home.packages = [ pkgs.feh ];

        systemd.user.services.feh-daemon = {
          Unit = {
            Description = "Feh Wallpaper Daemon";
            After = [ "graphical-session-pre.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = "3";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      })
    ]
  );
}
