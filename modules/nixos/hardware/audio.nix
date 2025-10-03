{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "sound" (vars.hardware.enable or [ ]);
in
{
  config = lib.mkIf enable {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };
}
