{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "displayManager" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    services.displayManager.ly = {
      enable = true;

      settings = {
        animation = "none";
        clock = "%c";
	      bigclock = true;
        hide_borders = true;
        hide_f1_commands = true;
      };
    };
  };
}
