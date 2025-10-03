{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  app_deps = with pkgs; [
    xorg.libX11
    xorg.libX11.dev
    xorg.libICE
    xorg.libSM
    xorg.libXinerama
    fontconfig
    libGL
    libxkbcommon
    glib
    freetype
  ];
in
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
        dotnet-sdk_9
      ]
      ++ app_deps
      ++ lib.optionals (lib.elem "python" (vars.development.enable or [ ])) [
        (python3.withPackages (
          ps: with ps; [
            pytubefix
            requests
            numpy
          ]
        ))
      ];

    environment.variables.LD_LIBRARY_PATH = "${lib.makeLibraryPath app_deps}";
  };
}
