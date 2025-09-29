{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "users" (vars.system.enable or [ ]);

  defaults = {
    mainUser = vars.username;
    extraUsers = [ ];
  };

  cfg = defaults // (vars.system.config.users or { });
in
{
  config = lib.mkIf enable {
    users.users = lib.mkMerge [
      {
        ${cfg.mainUser} = {
          isNormalUser = true;
          description = "Main user";
          extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
          ];
          shell = pkgs.bash;
        };
      }

      (builtins.listToAttrs (
        map (user: {
          name = user.name;
          value = {
            isNormalUser = true;
            description = user.description or "";
            extraGroups = user.groups or [ ];
            shell = user.shell or pkgs.bash;
          };
        }) cfg.extraUsers
      ))
    ];
  };
}
