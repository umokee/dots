{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "night_mode" (vars.services.enable or [ ]);
in
{
  config = lib.mkIf enable {
    services.gammastep = {
      enable = true;
      package = pkgs.gammastep;

      latitude = 43.1155;
      longitude = 131.8855;

      temperature = {
        day = 6500;
        night = 3400;
      };
    };
  };
}
