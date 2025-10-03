{ config, pkgs, ... }:
{
  config = {
    services.syncthing = {
      enable = true;

      settings = {
        devices = {
          "laptop" = { id = ""; };
          "desktop" = { id = "NZMYWC2-2H5BVS2-LDRCCAI-N3XDPFG-UMTK7UM-LFVWFU7-G2RPGPX-SYKFQQU"; };
        };

        folders = {
          "DotFiles" = {
            path = "/home/user/nixos";
            devices = [ "laptop" "desktop" ];

            versioning = {
              type = "simple";
              params = {
                keep = "5";
              };
            };
          };
        };
        
        options = {
          urAccepted = -1;
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
          relaysEnabled = false;
        };
      };
    };
  };
}
