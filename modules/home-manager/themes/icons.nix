{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "themes" (vars.desktop.enable or [ ]);
  matugen = lib.elem "matugen" (vars.desktop.enable or [ ]);

  colorDetectionScript = ''
    import sys, colorsys, math

    hex_color = '$requested_hex'.strip()
    cache_path = '$CACHE_NEAREST_FILE'

    try:
      with open(cache_path, 'r', encoding='utf-8') as fh:
        cached_hex, cached_name = fh.read().split('\n', 1)
        if cached_hex.strip().lower() == hex_color.lower():
          print(cached_name.strip())
          exit(0)
    except Exception:
      pass

    papirus_colors = {
        'adwaita': '#9a9996', 'black': '#2e3440', 'blue': '#5294e2',
        'bluegrey': '#607d8b', 'breeze': '#3daee9', 'brown': '#8d6e63',
        'carmine': '#d32f2f', 'cyan': '#00bcd4', 'darkcyan': '#00695c',
        'deeporange': '#ff5722', 'green': '#4caf50', 'grey': '#9e9e9e',
        'indigo': '#3f51b5', 'magenta': '#e91e63', 'nordic': '#5e81ac',
        'orange': '#ff9800', 'palebrown': '#bcaaa4', 'paleorange': '#ffcc80',
        'pink': '#f06292', 'red': '#f44336', 'teal': '#009688',
        'violet': '#9c27b0', 'white': '#fafafa', 'yaru': '#e95420',
        'yellow': '#ffeb3b',
    }

    def hex_to_hsl(hex_color):
        hex_color = hex_color.lstrip('#')
        r, g, b = tuple(int(hex_color[i:i+2], 16)/255.0 for i in (0, 2, 4))
        h, l, s = colorsys.rgb_to_hls(r, g, b)
        return (h*360, s, l)

    def color_distance(hsl1, hsl2):
        dh = min(abs(hsl1[0] - hsl2[0]), 360 - abs(hsl1[0] - hsl2[0])) / 180.0
        ds = abs(hsl1[1] - hsl2[1])
        dl = abs(hsl1[2] - hsl2[2])
        return 0.6*dh + 0.25*ds + 0.15*dl

    input_hsl = hex_to_hsl(hex_color)
    min_distance = float('inf')
    nearest_color = 'blue'

    for name, papirus_hex in papirus_colors.items():
        papirus_hsl = hex_to_hsl(papirus_hex)
        distance = color_distance(input_hsl, papirus_hsl)
        if distance < min_distance:
            min_distance = distance
            nearest_color = name

    try:
      from pathlib import Path
      Path(cache_path).parent.mkdir(parents=True, exist_ok=True)
      with open(cache_path, 'w', encoding='utf-8') as fh:
        fh.write(f'{hex_color}\n{nearest_color}\n')
    except Exception:
      pass

    print(nearest_color)
  '';

  applyPapirusColor = ''
    if command -v ${pkgs.papirus-folders}/bin/papirus-folders >/dev/null 2>&1; then
      export PATH="${pkgs.gawk}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:$PATH"
      
      current_theme=$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo "'Papirus-Dark'")
      current_theme=''${current_theme//\'/}
      
      case "$current_theme" in
        Papirus*) theme_name="$current_theme" ;;
        *) theme_name="Papirus-Dark"
           ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true ;;
      esac
      
      ${pkgs.papirus-folders}/bin/papirus-folders -C "$papirus_color" --theme "$theme_name" 2>/dev/null || \
      ${pkgs.bash}/bin/bash -c "
        source ~/.bashrc 2>/dev/null || true
        export PATH=\$PATH:${pkgs.gawk}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin
        ${pkgs.papirus-folders}/bin/papirus-folders -C '$papirus_color' --theme '$theme_name' 2>/dev/null
      " || true
      
      ${pkgs.gtk3}/bin/gtk-update-icon-cache -f ~/.local/share/icons 2>/dev/null || true
      ${pkgs.gtk3}/bin/gtk-update-icon-cache -f /usr/share/icons/"$theme_name" 2>/dev/null || true
    fi
  '';
in
{
  config = lib.mkIf enable {
    home.packages =
      with pkgs;
      [
        papirus-icon-theme
      ]
      ++ lib.optionals matugen [
        papirus-folders
        python3
        gawk
      ];

    home.activation = lib.mkIf matugen {
      papirusColorDetector = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        readonly FOLDER_HEX_FILE="$HOME/.cache/wal/folder-color.txt"
        readonly CACHE_DIR="$HOME/.cache/wal"
        readonly CACHE_NEAREST_FILE="$CACHE_DIR/papirus-folder-color.nearest"

        if [[ ! -f "$FOLDER_HEX_FILE" ]]; then
          papirus_color="blue"
        else
          requested_hex=$(<"$FOLDER_HEX_FILE")
          mkdir -p "$CACHE_DIR"
          papirus_color=$(${pkgs.python3}/bin/python3 -c "${colorDetectionScript}" | tail -n 1)
        fi

        ${applyPapirusColor}
      '';
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
