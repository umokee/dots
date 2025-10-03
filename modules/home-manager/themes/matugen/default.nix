{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  wallpapers,
  ...
}:
let
  enable = lib.elem "matugen" (vars.desktop.enable or [ ]);
  wallpaper = wallpapers.${vars.wallpaperName} or wallpapers.backyard;
in
{
  imports = [
    ./templates
  ];

  config = lib.mkIf enable {
    home.packages = [ inputs.matugen.packages.${pkgs.system}.default ];

    home.file = {
      ".config/matugen/config.toml".text = ''
        [config]
        set_wallpaper = true

        [colors] 
        variant = "dark"
        json_format = "hex"

        [templates.alacritty]
        input_path = "${vars.dirs.config}/matugen/templates/alacritty.toml"
        output_path = "${vars.dirs.config}/alacritty/colors.toml"

        [templates.hyprland]
        input_path = "${vars.dirs.config}/matugen/templates/hyprland.conf"
        output_path = "${vars.dirs.config}/hypr/colors.conf"

        [templates.fuzzel]
        input_path = "${vars.dirs.config}/matugen/templates/fuzzel.ini"
        output_path = "${vars.dirs.config}/fuzzel/colors.ini"

        [templates.pywalfox]
        input_path = "${vars.dirs.config}/matugen/templates/pywalfox.json"
        output_path = "${vars.dirs.home}/.cache/wal/colors.json"

        [templates.gtk3]
        input_path = "${vars.dirs.config}/matugen/templates/gtk.css"
        output_path = "${vars.dirs.config}/gtk-3.0/colors.css"

        [templates.gtk4]
        input_path = "${vars.dirs.config}/matugen/templates/gtk.css"
        output_path = "${vars.dirs.config}/gtk-4.0/colors.css"

        [templates.vs-code]
        input_path = "${vars.dirs.config}/matugen/templates/vscode.json"
        output_path = "${vars.dirs.home}/.vscode/extensions/tokyo-night-matugen/themes/tokyo-night-matugen.json"
      
        [templates.folder-color]
        input_path = "${vars.dirs.config}/matugen/templates/folder-color.txt"
        output_path = "${vars.dirs.home}/.cache/wal/folder-color.txt"
      
        [templates.qt5ct]
        input_path = '${vars.dirs.config}/matugen/templates/qtct.conf'
        output_path = '${vars.dirs.config}/qt5ct/colors/matugen.conf'

        [templates.qt6ct]
        input_path = '${vars.dirs.config}/matugen/templates/qtct.conf'
        output_path = '${vars.dirs.config}/qt6ct/colors/matugen.conf'
      '';
    };

    home.activation.matugenGenerate = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ -f "${wallpaper}" ]]; then
        echo "Generating matugen colors..."
        ${inputs.matugen.packages.x86_64-linux.default}/bin/matugen image "${wallpaper}" --config ~/.config/matugen/config.toml
      else
        echo "Wallpaper not found at ${wallpaper}, skipping color generation"
      fi
    '';
  };
}
