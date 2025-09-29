{ config, lib, pkgs, ... }:

let cfg = config.desktop.dwm;
in
{
  options = {
    desktop.dwm = {
      enable = lib.mkEnableOption "DWM window manager";
        
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.dwm;
        description = "DWM package to use";
      };
      
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Extra packages for DWM environment";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;

      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "bakkeby";
            repo = "dwm-flexipatch";  
            rev = "74edc27";
            hash = "sha256-...";
          };
          postPatch = ''
            cp ${.config/dwm}/* .
          '';
        });
      };
    };

    environment.systemPackages = with pkgs; [
      alacritty
      
      xorg.xrandr
      xorg.xset
      xorg.xinput
      xorg.xprop
      xorg.xwininfo
      xorg.xkill
      
      slstatus
      xclip
    ] ++ cfg.extraPackages;

    # services.picom.enable = true;
  };
}
