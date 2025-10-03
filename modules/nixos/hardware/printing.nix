{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "print" (vars.hardware.enable or [ ]);

  default = {
    wifi = false;
    scanner = false;
  };

  cfg = default // (vars.hardware.config.print or { });
in
{
  config = lib.mkIf enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        cups-filters
      ];
    };

    services.avahi = lib.mkIf cfg.wifi {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.sane = lib.mkIf cfg.scanner {
      enable = true;
    };

    environment.systemPackages =
      with pkgs;
      [
        system-config-printer
      ]
      ++ lib.optionals cfg.scanner [
        simple-scan
        sane-frontends
      ];

    users.groups.scanner = lib.mkIf cfg.scanner { };
  };
}
