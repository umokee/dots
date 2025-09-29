{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = {
    environment.systemPackages =
      with pkgs;
      [ ]
      ++ lib.optionals (lib.elem "nodejs" (vars.development.enable or [ ])) [
        nodejs_20
        yarn
        pnpm
      ]
      ++ lib.optionals (lib.elem "dotnet" (vars.development.enable or [ ])) [
        dotnet-sdk
      ]
      ++ lib.optionals (lib.elem "python" (vars.development.enable or [ ])) [
        (python3.withPackages (
          ps: with ps; [
            pytubefix
            requests
            numpy
          ]
        ))
      ];
  };
}
