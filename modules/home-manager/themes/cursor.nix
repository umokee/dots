{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "themes" (vars.desktop.enable or [ ]);

  default = {
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 24;
  };

  cfg = default // (vars.desktop.config.themes.cursor or { });
in
{
  config = lib.mkIf enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = cfg.name;
      package = cfg.package;
      size = cfg.size;
    };

    gtk.cursorTheme = {
      name = cfg.name;
      package = cfg.package;
      size = cfg.size;
    };
  };
}
