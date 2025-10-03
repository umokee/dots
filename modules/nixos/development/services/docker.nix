{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "docker" (vars.development.enable or [ ]);

  default = {
    users = [ vars.username ];
    compose = true;
    buildkit = true;
    nvidia = false;
    registries = { };
  };

  cfg = default // (vars.development.config.docker or { });
in
{
  config = lib.mkIf enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = cfg.nvidia;

      daemon.settings = {
        features = lib.mkIf cfg.buildkit { buildkit = true; };
        registry-mirrors = lib.attrValues cfg.registries;
      };
    };

    users.extraGroups.docker.members = cfg.users;

    environment.systemPackages =
      with pkgs;
      [
        docker
        docker-client
      ]
      ++ lib.optionals cfg.compose [
        docker-compose
      ]
      ++ lib.optionals cfg.nvidia [
        nvidia-docker
      ];
  };
}
