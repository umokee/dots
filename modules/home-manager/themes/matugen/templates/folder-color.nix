{
  config,
  lib,
  vars,
  ...
}:

let
  enable = lib.elem "matugen" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    home.file.".config/matugen/templates/folder-color.txt".text = ''
      {{colors.primary.default.hex}}
    '';
  };
}
