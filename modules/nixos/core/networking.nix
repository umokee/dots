{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "network" (vars.system.enable or [ ]);

  default = {
    firewall = false;
  };

  cfg = default // (vars.system.config.network or { });
in
{
  config = lib.mkIf enable {
    networking = {
      hostName = vars.hostname;
      networkmanager.enable = true;

      firewall = {
        enable = cfg.firewall;
        allowPing = true;
      };
    };
  };
}
