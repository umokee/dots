{
  config,
  lib,
  pkgs,
  vars,
  tools,
  ...
}:
let
  enable = lib.elem "screenshots" (vars.desktop.enable or [ ]);

  default = {
    directory = "${vars.dirs.home}/Pictures/Screenshots";
    tool = "auto";
  };

  cfg = default // (vars.desktop.config.screenshots or { });

  selectedTool =
    if cfg.tool == "auto" then
      if tools.needsHyprlandPortal then
        "hyprshot"
      else if tools.isWayland then
        "grim"
      else
        "maim"
    else
      cfg.tool;

  screenshotCommands = {
    hyprshot = {
      fullscreen = "hyprshot -m output -o '${cfg.directory}' --filename $(date +%Y-%m-%d_%H-%M-%S).png";
      area = "hyprshot -m region -o '${cfg.directory}' --filename $(date +%Y-%m-%d_%H-%M-%S).png";
      clipboard = "hyprshot -m region --clipboard-only";
      window = "hyprshot -m window -o '${cfg.directory}' --filename $(date +%Y-%m-%d_%H-%M-%S).png";
      active = "hyprshot -m active -o '${cfg.directory}' --filename $(date +%Y-%m-%d_%H-%M-%S).png";
    };
    grim = {
      fullscreen = "grim '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      area = "grim -g \"$(slurp)\" '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      clipboard = "grim -g \"$(slurp)\" - | wl-copy";
      window = "hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | grim -g - '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      active = "grim -g \"$(hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
    };
    maim = {
      fullscreen = "maim '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      area = "maim -s '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      clipboard = "maim -s | xclip -selection clipboard -t image/png";
      window = "maim -i $(xdotool getactivewindow) '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
      active = "maim -i $(xdotool getactivewindow) '${cfg.directory}/$(date +%Y-%m-%d_%H-%M-%S).png'";
    };
  };
in
{
  config = lib.mkIf enable (
    lib.mkMerge [
      (lib.mkIf tools.needsHyprlandPortal {
        home.packages = [
          pkgs.hyprshot
          pkgs.libnotify
        ];
      })
      (lib.mkIf (tools.isWayland && (!tools.needsHyprlandPortal)) {
        home.packages = [
          pkgs.grim
          pkgs.slurp
          pkgs.wl-clipboard
          pkgs.jq
        ];
      })
      (lib.mkIf tools.isX11 {
        home.packages = [
          pkgs.maim
          pkgs.xclip
          pkgs.xdotool
        ];
      })
      {
        home.activation.createScreenshotDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p ${cfg.directory}
        '';

        home.file.".local/bin/screenshot-tool" = {
          executable = true;
          text = ''
            #!${pkgs.bash}/bin/bash
            case "$1" in
              "window") ${screenshotCommands.${selectedTool}.window} ;;
              "area") ${screenshotCommands.${selectedTool}.area} ;;
              "full") ${screenshotCommands.${selectedTool}.fullscreen} ;;
              "clip") ${screenshotCommands.${selectedTool}.clipboard} ;;
              *)
                echo "Usage: $0 {window|area|full|clip}"
                echo "  window - Screenshot active window"
                echo "  area   - Screenshot selected area"
                echo "  full   - Screenshot entire screen"
                echo "  clip   - Screenshot area to clipboard"
                ;;
            esac
          '';
        };
      }
    ]
  );
}
