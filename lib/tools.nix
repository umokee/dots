{ lib, vars, ... }:
let
  enabledDEs = vars.desktop.enable or [ ];

  waylandCompositors = [
    "hyprland"
    "niri"
    "dwl"
    "sway"
    "river"
    "wayfire"
    "labwc"
    "gnome"
    "plasma6"
  ];

  x11WMs = [
    "i3"
    "bspwm"
    "awesome"
    "xmonad"
    "dwm"
    "openbox"
    "plasma5"
    "xfce"
    "mate"
  ];

  wlrBasedDEs = [
    "sway"
    "river"
    "dwl"
    "cagebreak"
    "labwc"
    "wayfire"
  ];
in
{
  isWayland = lib.any (de: lib.elem de enabledDEs) waylandCompositors;
  isX11 = lib.any (de: lib.elem de enabledDEs) x11WMs;

  sessionType =
    if lib.any (de: lib.elem de enabledDEs) waylandCompositors then
      "wayland"
    else if lib.any (de: lib.elem de enabledDEs) x11WMs then
      "x11"
    else
      "unknown";

  hasNvidia = lib.elem "nvidia" (vars.hardware.enable or [ ]);

  needsHyprlandPortal = lib.elem "hyprland" enabledDEs;
  needsKDEPortal = lib.elem "plasma6" enabledDEs || lib.elem "plasma5" enabledDEs;
  needsGnomePortal = lib.elem "gnome" enabledDEs;
  needsWlrPortal = lib.any (de: lib.elem de enabledDEs) wlrBasedDEs;
  needsNiriPortal = lib.elem "niri" enabledDEs;

  enabledWaylandDEs = lib.filter (de: lib.elem de waylandCompositors) enabledDEs;
  enabledX11DEs = lib.filter (de: lib.elem de x11WMs) enabledDEs;
}
