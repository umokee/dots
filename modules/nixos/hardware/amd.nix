{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "amd_cpu" (vars.hardware.enable or [ ]);

  default = {
    laptop = false;
  };

  cfg = default // (vars.hardware.config.amd_cpu or { });
in
{
  config = lib.mkIf enable {
    boot.kernelParams = [
      "amd_pstate=active"
      "amdgpu.dcdebugmask=0x10"
      "amd_iommu=on"
    ]
    ++ lib.optionals cfg.laptop [
      "processor.max_cstate=5"
    ];

    hardware = {
      cpu.amd.updateMicrocode = true;
      enableRedistributableFirmware = true;
    };

    environment.systemPackages = lib.optionals cfg.laptop (
      with pkgs;
      [
        ryzenadj
        zenmonitor
      ]
    );
  };
}
