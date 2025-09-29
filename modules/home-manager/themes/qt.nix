{ config, lib, pkgs, ... }:

let
  cfg = config.themes.qt;
  globalCfg = config.themes;
in
{
  options.themes.qt = {
    enable = lib.mkEnableOption "Qt theming";
    
    theme = lib.mkOption {
      type = lib.types.str;
      default = if globalCfg.colorScheme == "dark" then "Adwaita-dark" else "Adwaita";
      description = "Qt theme name";
    };
    
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.adwaita-qt;
      description = "Qt theme package";
    };
    
    platformTheme = lib.mkOption {
      type = lib.types.enum [ "qtct" "kde" "gnome" ];
      default = "qtct";
      description = "Qt platform theme";
    };
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = cfg.platformTheme;
      style = {
        name = cfg.theme;
        package = cfg.package;
      };
    };
    
    home.sessionVariables = {
      QT_STYLE_OVERRIDE = cfg.theme;
      QT_QPA_PLATFORMTHEME = lib.mkForce cfg.platformTheme;
    };
  };
}
