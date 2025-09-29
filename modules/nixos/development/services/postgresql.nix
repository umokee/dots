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
      package = pkgs."postgresql_${cfg.version}";
      port = cfg.port;
      ensureDatabases = cfg.databases;
      ensureUsers = lib.mapAttrsToList (
        name: user:
        {
          name = name;
        }
        // user
      ) cfg.users;

      extraPlugins = with pkgs.postgresql.pkgs; [
        postgis
        pg_cron
        pg_stat_statements
      ];

      settings = {
        shared_preload_libraries = "pg_stat_statements,pg_cron";
        log_statement = "all";
        log_duration = true;
        log_line_prefix = "%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ";
      };
    };

    environment.systemPackages = with pkgs; [
      postgresql
      pgadmin4
      pg_top
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf config.networking.firewall.enable [ cfg.port ];
  };
}
