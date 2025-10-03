{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "tools" (vars.development.enable or [ ]);
in
{
  config = {
    environment.systemPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
