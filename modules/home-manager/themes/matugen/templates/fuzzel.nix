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
    home.file = {
      ".config/matugen/templates/fuzzel.ini".text = ''
        [colors]
        background={{colors.background.default.hex_stripped}}ff
        text={{colors.on_surface.default.hex_stripped}}ff
        prompt={{colors.secondary.default.hex_stripped}}ff
        placeholder={{colors.tertiary.default.hex_stripped}}ff
        input={{colors.primary.default.hex_stripped}}ff
        match={{colors.tertiary.default.hex_stripped}}ff
        selection={{colors.primary.default.hex_stripped}}ff
        selection-text={{colors.on_surface.default.hex_stripped}}ff
        selection-match={{colors.on_primary.default.hex_stripped}}ff
        counter={{colors.secondary.default.hex_stripped}}ff
        border={{colors.primary.default.hex_stripped}}ff
      '';
    };
  };
}
