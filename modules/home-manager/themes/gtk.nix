{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "themes" (vars.desktop.enable or [ ]);
  matugen = lib.elem "matugen" (vars.desktop.enable or [ ]);

  default = {
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    }; 
  };

  cfg = default // (vars.desktop.config.themes.gtk or { });
in
{
  config = lib.mkIf enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = if vars.colorScheme == "dark" then "prefer-dark" else "prefer-light";
        };
      };
    };

    gtk = {
      enable = true;

      font = {
        name = cfg.font.name;
        size = cfg.font.size;
        package = cfg.font.package;
      };

      theme = {
        name = cfg.theme.name;
        package = cfg.theme.package;
      };

      gtk3 = {
        extraConfig.Settings = ''
          gtk-application-prefer-dark-theme=${if vars.colorScheme == "dark" then "1" else "0"}
        '';
        extraCss = lib.mkIf matugen ''
          @import 'colors.css';
        '';
      };

      gtk4 = {
        extraConfig.Settings = ''
          gtk-application-prefer-dark-theme=${if vars.colorScheme == "dark" then "1" else "0"}
        '';
        extraCss = lib.mkIf matugen ''
          @import 'colors.css';
        '';
      };
    };
  };
}
