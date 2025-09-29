{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "ssh" (vars.services.enable or [ ]);

  default = {
    port = 22;
    passwordAuthentication = false;
    rootLogin = false;
    authorizedKeys = {
      #user = [ "ssh-rsa AAAAB3NzaC1yc2E..." ];
    };
  };

  cfg = default // (vars.services.config.ssh or {});
in
{
  config = lib.mkIf enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];

      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        PermitRootLogin = if cfg.rootLogin then "yes" else "no";
        X11Forwarding = true;

        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
    };

    users.users = lib.mapAttrs (user: keys: {
      openssh.authorizedKeys.keys = keys;
    }) cfg.authorizedKeys;

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
