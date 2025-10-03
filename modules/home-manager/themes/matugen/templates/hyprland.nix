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
      ".config/matugen/templates/hyprland.conf".text = ''
        general {
          col.active_border = rgba({{colors.primary_fixed.default.hex_stripped}}ee)
          col.inactive_border = rgba({{colors.secondary_fixed_dim.default.hex_stripped}}ee)
        }

        misc {
          background_color = rgba({{colors.surface.default.hex_stripped}}ee)
        }
      '';
    };
  };
}
