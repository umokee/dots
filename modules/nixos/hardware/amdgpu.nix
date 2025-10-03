{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  enable = lib.elem "amd_gpu" (vars.hardware.enable or [ ]);

  default = {
    vulkan = true;
    rocm = false;
    openCL = false;
  };

  cfg = default // (vars.hardware.config.amd_gpu or { });
in
{
  config = lib.mkIf enable {
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages =
        with pkgs;
        [
          libva
          libva-utils
          amdvlk
        ]
        ++ lib.optionals cfg.vulkan [
          vulkan-loader
          vulkan-validation-layers
        ]
        ++ lib.optionals cfg.openCL [
          rocmPackages.clr
          rocmPackages.clr.icd
        ];
    };

    systemd.tmpfiles.rules = lib.optionals cfg.rocm [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    environment.systemPackages =
      with pkgs;
      [
        radeontop
      ]
      ++ lib.optionals cfg.vulkan [
        vulkan-tools
      ]
      ++ lib.optionals cfg.rocm [
        rocmPackages.rocm-smi
        rocmPackages.rocminfo
      ];

    users.groups.render = lib.mkIf cfg.rocm { };
  };
}
