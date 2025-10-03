{
  config,
  lib,
  vars,
  pkgs,
  inputs,
  ...
}:
let
  enable = lib.elem "niri" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    programs.niri = {
      config = ''
        input {
          keyboard {
            xkb {
              layout "us,ru"
              options "grp:ctrl_shift_toggle"
            }
            repeat-delay 300
            repeat-rate 50
            track-layout "global"
          }

          touchpad {
            tap
            natural-scroll
            dwt
            scroll-factor 0.3
          }

          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="0%"
        }

        spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
        spawn-at-startup "systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"

        prefer-no-csd

        layout {
          gaps 10
          center-focused-column "never"

          default-column-width { proportion 1.0; }

          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
          }

          background-color "transparent"

          focus-ring {
            width 2
            active-color "#7aa2f7"
            inactive-color "#565f89"
          }

          border {
            width 2
            active-color "#7aa2f7"
            inactive-color "#565f89"
            urgent-color "#f7768e"
          }
        }

        animations {
          off
        }

        // Непрозрачные окна
        window-rule {
          match app-id=r#"^(foot|equibop|imv|swappy)$"#
          opacity 1.0
        }

        // Плавающие окна - общие утилиты
        window-rule {
          match app-id=r#"^(guifetch|yad|zenity|wev)$"#
          default-column-width {}
        }

        window-rule {
          match app-id=r#"^org\.gnome\.FileRoller$"#
          default-column-width {}
        }

        window-rule {
          match app-id=r#"^(blueman-manager|feh|imv|system-config-printer)$"#
          default-column-width {}
        }

        // Foot с nmtui
        window-rule {
          match app-id="foot" title="nmtui"
          default-column-width { proportion 0.6; }
        }

        // GNOME Settings
        window-rule {
          match app-id=r#"^org\.gnome\.Settings$"#
          default-column-width { proportion 0.7; }
        }

        // PulseAudio контроль
        window-rule {
          match app-id=r#"^org\.pulseaudio\.pavucontrol$"#
          default-column-width { proportion 0.6; }
        }

        // nwg-look
        window-rule {
          match app-id="nwg-look"
          default-column-width { proportion 0.5; }
        }

        // Диалоги - файловые операции
        window-rule {
          match title=r#"(Select|Open)( a)? (File|Folder)(s)?"#
          default-column-width {}
        }

        window-rule {
          match title=r#"File (Operation|Upload)( Progress)?"#
          default-column-width {}
        }

        window-rule {
          match title=r#".* Properties"#
          default-column-width {}
        }

        window-rule {
          match title="Export Image as PNG"
          default-column-width {}
        }

        window-rule {
          match title="GIMP Crash Debug"
          default-column-width {}
        }

        window-rule {
          match title="Save As"
          default-column-width {}
        }

        window-rule {
          match title="Library"
          default-column-width {}
        }

        // Picture-in-Picture
        window-rule {
          match title=r#"Picture(-| )in(-| )[Pp]icture"#
          default-column-width {}
        }

        // Steam игры (без дополнительных свойств)
        window-rule {
          match app-id=r#"^steam_app_[0-9]+$"#
        }

        // JetBrains окна - не фокусировать всплывающие
        window-rule {
          match app-id=r#"^.*jetbrains.*$"# title=r#"^win.*$"#
          open-focused false
        }

        binds {
          Mod+O repeat=false { toggle-overview; }

          // Запуск приложений
          Mod+A { spawn "fuzzel"; }
          Mod+Return { spawn "alacritty"; }
          Mod+W { spawn "firefox-esr"; }
          Mod+E { spawn "thunar"; }
          Mod+Shift+S { spawn "screenshot-tool" "window"; }

          // Управление окнами
          Mod+Q repeat=false { close-window; }
          Mod+F { switch-preset-column-width; }
          Mod+Shift+F { fullscreen-window; }
          Mod+V { toggle-window-floating; }

          // Перемещение фокуса
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+K { focus-window-or-workspace-up; }
          Mod+J { focus-window-or-workspace-down; }

          // Перемещение окон
          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+K { move-window-to-workspace-up; }
          Mod+Shift+J { move-window-to-workspace-down; }

          // Workspace переключение
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          // Перемещение на workspace
          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          Mod+Shift+5 { move-window-to-workspace 5; }
          Mod+Shift+6 { move-window-to-workspace 6; }
          Mod+Shift+7 { move-window-to-workspace 7; }
          Mod+Shift+8 { move-window-to-workspace 8; }
          Mod+Shift+9 { move-window-to-workspace 9; }

          // Switches focus between the current and the previous workspace.
          // Mod+Tab { focus-workspace-previous; }

          // Громкость
          XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        }

        hotkey-overlay {
          skip-at-startup
        }
      '';
    };
  };
}
