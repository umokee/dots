{
  config,
  lib,
  pkgs,
  vars,
  tools,
  ...
}:
let
  enable = vars ? displays;

  default = {
    monitors = [
      {
        name = "";
        resolution = "1920x1080";
        refreshRate = "60";
        position = "0,0";
        rotate = "normal";
        scale = 1.0;
        enabled = true;
        primary = true;
      }
    ];
    hotplug = true;
  };

  toKanshiTransform = rotation: {
    normal = "normal";
    left = "90";
    right = "270";
    inverted = "180";
  }.${rotation} or "normal";

  cfg = default // (vars.displays or { });

  kanshiConfig = ''
    profile default {
      ${lib.concatMapStringsSep "\n  " (monitor: 
        "output \"${monitor.name}\" " +
        (if monitor.enabled then 
          "mode ${monitor.resolution}@${monitor.refreshRate}Hz " +
          "position ${monitor.position}" +
          "${lib.optionalString (monitor.rotate != "normal") " transform ${toKanshiTransform monitor.rotate}"}" +
          "${lib.optionalString (monitor.scale or 1.0 != 1.0) " scale ${toString monitor.scale}"}"
        else "disable")
      ) cfg.monitors}
    }
  '';

  xrandrCommands = lib.concatMapStringsSep " && " (
    monitor:
    "${pkgs.xorg.xrandr}/bin/xrandr --output ${monitor.name} "
    + "${lib.optionalString (!monitor.enabled) "--off"}"
    + "${lib.optionalString monitor.enabled (
      "--mode ${monitor.resolution} --rate ${monitor.refreshRate} --pos ${monitor.position}"
      + "${lib.optionalString (monitor.primary or false) " --primary"}"
      + "${lib.optionalString (monitor.rotate != "normal") " --rotate ${monitor.rotate}"}"
      + "${lib.optionalString (monitor.scale or 1.0 != 1.0)
        " --scale ${toString (monitor.scale or 1.0)}"
      }"
    )}"
  ) cfg.monitors;
in
{
  config = lib.mkIf enable (
    lib.mkMerge [
      {
        environment.systemPackages =
          with pkgs;
          lib.mkMerge [
            (lib.mkIf tools.isX11 [ xorg.xrandr ])
            (lib.mkIf tools.isWayland [ kanshi ])
          ];
      }
      (lib.mkIf tools.isX11 {
        systemd.user.services.displays-x11 = {
          description = "Setup X11 displays";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash -c '${xrandrCommands}'";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = "3";
          };
        };
      })
      (lib.mkIf tools.isWayland {
        environment.etc."kanshi/config".text = kanshiConfig;

        systemd.user.services.kanshi = {
          description = "Kanshi display daemon";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.kanshi}/bin/kanshi -c /etc/kanshi/config";
            Restart = "always";
            RestartSec = "3";
          };
        };
      })
    ]
  );
}
