{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "postgresql" (vars.development.enable or [ ]);

  default = {
    databases = [ ];
    users = { };
    port = 5432;
  };

  cfg = default // (vars.development.config.postgresql or { });
in
{
  config = lib.mkIf enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = cfg.databases;
      ensureUsers = lib.mapAttrsToList (
        name: user:
        {
          name = name;
        }
        // user
      ) cfg.users;

      settings = {
        port = cfg.port;
      };

      authentication = pkgs.lib.mkOverride 10 ''
        #type database user address        auth-method
        local all      all                 trust
        host  all      all  127.0.0.1/32   trust
        host  all      all  ::1/128        trust
      '';
    };

    environment.systemPackages = with pkgs; [
      postgresql
      pgadmin4-desktopmode
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf config.networking.firewall.enable [ cfg.port ];
  };
}
