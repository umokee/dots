{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}:
let
  enable = lib.elem "matugen" (vars.desktop.enable or [ ]);

  default = {
    colorScheme = vars.colorScheme;
    variant = vars.colorScheme;
    jsonFormat = "hex";
    autoGenerate = true;
  };

  cfg = default // (vars.desktop.config.matugen or { });
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
        set_wallpaper = ${if cfg.autoGenerate then "true" else "false"}

        [colors] 
        variant = "${cfg.variant}"
        json_format = "${cfg.jsonFormat}"

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
      '';
    };

    home.activation.matugenGenerate = lib.mkIf cfg.autoGenerate (
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [[ -f "${vars.wallpaper}" ]]; then
          echo "Generating matugen colors..."
          ${inputs.matugen.packages.x86_64-linux.default}/bin/matugen image "${vars.wallpaper}" --config ~/.config/matugen/config.toml
        else
          echo "Wallpaper not found at ${vars.wallpaper}, skipping color generation"
        fi
      ''
    );
  };
}
