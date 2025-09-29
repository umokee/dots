{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "security" (vars.system.enable or [ ]);

  default = {
    sudo = {
      wheelNeedsPassword = true;
      timeout = 5;
    };
    polkit = true;
  };

  cfg = default // (vars.system.config.security or { });
in
{
  config = lib.mkIf enable {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = cfg.sudo.wheelNeedsPassword;
      extraConfig = ''
        Defaults timestamp_timeout=${toString cfg.sudo.timeout}
        Defaults lecture="never"
      '';
    };

    security.polkit.enable = cfg.polkit;

    users.groups = {
      networkmanager = { };
      wheel = { };
      audio = { };
      video = { };
    };

    security = {
      rtkit.enable = true;

      pam.loginLimits = [
        {
          domain = "*";
          item = "nofile";
          type = "soft";
          value = "65536";
        }
        {
          domain = "*";
          item = "nofile";
          type = "hard";
          value = "65536";
        }
      ];
    };
  };
}
