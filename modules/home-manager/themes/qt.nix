{ config, lib, pkgs, vars, ... }:
let
  enable = lib.elem "themes" (vars.desktop.enable or []);
  matugen = lib.elem "matugen" (vars.desktop.enable or []);
in
{
  config = lib.mkIf enable {
    home.packages = with pkgs; [
      libsForQt5.qt5ct
      qt6ct
      adwaita-qt
      adwaita-qt6
    ];

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";

      style = lib.mkIf (!matugen) {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt6;
      };
    };
    
    home.sessionVariables = lib.mkMerge [
      { QT_QPA_PLATFORMTHEME = "qt6ct"; }
      
      (lib.optionalAttrs (!matugen) {
        QT_STYLE_OVERRIDE = "Adwaita-dark";
      })
    ];

    home.file.".config/qt5ct/qt5ct.conf" = lib.mkIf matugen {
      text = ''
        [Appearance]
        color_scheme_path=${vars.dirs.config}/qt5ct/colors/matugen.conf
        custom_palette=true
        icon_theme=${config.gtk.iconTheme.name or "Papirus-Dark"}
        standard_dialogs=default
        style=Adwaita-Dark
        
        [Fonts]
        fixed="monospace,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
        general="sans-serif,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      '';
    };
    
    home.file.".config/qt6ct/qt6ct.conf" = lib.mkIf matugen {
      text = ''
        [Appearance]
        color_scheme_path=${vars.dirs.config}/qt6ct/colors/matugen.conf
        custom_palette=true
        icon_theme=${config.gtk.iconTheme.name or "Papirus-Dark"}
        standard_dialogs=default
        style=Adwaita-Dark
        
        [Fonts]
        fixed="monospace,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
        general="sans-serif,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      '';
    };
  };
}
