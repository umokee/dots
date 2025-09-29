{
  config,
  pkgs,
  lib,
  vars,
  tools,
  ...
}:

let
  enable = lib.elem "intel_cpu" (vars.hardware.enable or [ ]);

  default = {
    hybridCodec = true;
    vulkan = true;
  };

  cfg = default // (vars.hardware.config.intel_cpu or { });
in
{
  config = lib.mkIf enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages =
        with pkgs;
        [
          intel-media-driver
          intel-vaapi-driver

          libva
          libva-utils
          libvdpau-va-gl
        ]
        ++ lib.optionals cfg.vulkan [
          intel-compute-runtime
          vulkan-loader
          vulkan-validation-layers
        ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = lib.mkIf tools.hasNvidia "va_gl";
      VAAPI_MPEG4_ENABLED = "1";
    };

    environment.systemPackages =
      with pkgs;
      [
        intel-gpu-tools
      ]
      ++ lib.optionals cfg.vulkan [
        vulkan-tools
        vdpauinfo
      ];
  };
}
