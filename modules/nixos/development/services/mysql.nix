{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "mysql" (vars.development.enable or [ ]);

  default = {
    package = pkgs.mariadb;
    databases = [ ];
    users = { };
    port = 3306;
    rootPassword = null;
  };

  cfg = default // (vars.development.config.mysql or { });
in
{
  config = lib.mkIf enable {
    services.mysql = {
      enable = true;
      package = cfg.package;
      port = cfg.port;
      ensureDatabases = cfg.databases;
      ensureUsers = lib.mapAttrsToList (
        name: user:
        {
          name = name;
        }
        // user
      ) cfg.users;

      settings = {
        mysqld = {
          innodb_buffer_pool_size = "256M";
          max_connections = 100;
          query_cache_size = "32M";
          query_cache_type = 1;
          general_log = 1;
          general_log_file = "/var/log/mysql/general.log";
          slow_query_log = 1;
          slow_query_log_file = "/var/log/mysql/slow.log";
          long_query_time = 2;
        };
      };

      initialDatabases = lib.optionals (cfg.databases != [ ]) [
        { name = "information_schema"; }
      ];
    };

    environment.systemPackages = with pkgs; [
      cfg.package
      mysql-workbench
      mytop
    ];

    systemd.tmpfiles.rules = [
      "d /var/log/mysql 0755 mysql mysql -"
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf config.networking.firewall.enable [ cfg.port ];
  };
}
