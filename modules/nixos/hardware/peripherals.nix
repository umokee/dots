{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "peripherals" (vars.hardware.enable or [ ]);

  default = {
    keyboard = {
      layout = "us";
      variant = "";
      options = "grp:alt_shift_toggle";
    };
    mouse = {
      accelProfile = "adaptive";
      sensitivity = 0.0;
    };
  };

  cfg = default // (vars.hardware.config.peripherals or { });
in
{
  config = lib.mkIf enable {
    services.xserver.xkb = {
      layout = cfg.keyboard.layout;
      variant = cfg.keyboard.variant;
      options = cfg.keyboard.options;
    };

    console.keyMap = lib.mkDefault (lib.head (lib.splitString "," cfg.keyboard.layout));

    services.libinput = {
      enable = true;
      mouse = {
        accelProfile = cfg.mouse.accelProfile;
        accelSpeed = toString cfg.mouse.sensitivity;
      };

      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
      };
    };
  };
}
