{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "nvidia" (vars.hardware.enable or [ ]);

  default = {
    package = "stable";
    openSource = false;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    prime = {
      enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      sync = false; # always both on
      offload = true; # power save
    };
  };

  cfg = default // (vars.hardware.config.nvidia or { });

  getPackage =
    packageName:
    {
      stable = config.boot.kernelPackages.nvidiaPackages.stable;
      beta = config.boot.kernelPackages.nvidiaPackages.beta;
      legacy_470 = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      latest = config.boot.kernelPackages.nvidiaPackages.latest;
    }
    .${packageName};
in
{
  config = lib.mkIf enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = cfg.powerManagement.enable;
      powerManagement.finegrained = cfg.powerManagement.finegrained;
      nvidiaPersistenced = false;
      open = cfg.openSource;
      nvidiaSettings = true;
      package = getPackage cfg.package;

      prime = lib.mkIf cfg.prime.enable {
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;

        sync.enable = lib.mkIf cfg.prime.sync true;

        offload = lib.mkIf (!cfg.prime.sync) {
          enable = cfg.prime.offload;
          enableOffloadCmd = cfg.prime.offload;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libva-utils
    ];
  };
}
