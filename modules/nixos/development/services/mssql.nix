{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "mssql" (vars.development.enable or [ ]);

  default = {
    port = 1433;
    saPassword = "Pass1122!";
    edition = "Developer";
  };

  cfg = default // (vars.development.config.mssql or { });
in
{
  config = lib.mkIf enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      "d /var/lib/mssql 0755 10001 10001 -"
    ];

    virtualisation.oci-containers.containers.mssql = {
      image = "mcr.microsoft.com/mssql/server:2022-latest";

      environment = {
        ACCEPT_EULA = "Y";
        MSSQL_SA_PASSWORD = cfg.saPassword;
        MSSQL_PID = cfg.edition;
      };

      ports = [ "${toString cfg.port}:1433" ];

      volumes = [ "/var/lib/mssql:/var/opt/mssql" ];

      extraOptions = [ "--hostname=mssql-server" ];
    };

    # Только CLI + универсальный GUI
    environment.systemPackages = with pkgs; [
      sqlcmd # CLI для MS SQL
      dbeaver-bin # Универсальный GUI для всех БД
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf config.networking.firewall.enable [
      cfg.port
    ];

    warnings = lib.optional (
      cfg.saPassword == default.saPassword
    ) "MS SQL Server использует пароль по умолчанию!";
  };
}
