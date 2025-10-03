{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "bootloader" (vars.system.enable or [ ]);

  default = {
    loader = "grub";
    timeout = 3;
  };

  cfg = default // (vars.system.config.bootloader or { });
in
{
  config = lib.mkIf enable {
    boot.loader = lib.mkMerge [
      (lib.mkIf (cfg.loader == "systemd-boot") {
        systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 10;
        };
      })

      (lib.mkIf (cfg.loader == "grub") {
        grub = {
          enable = true;
          device = "nodev";
          useOSProber = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      })

      {
        timeout = cfg.timeout;
        #efi.canTouchEfiVariables = true;
      }
    ];
  };
}
