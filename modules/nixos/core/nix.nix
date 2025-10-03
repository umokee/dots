{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "nix" (vars.system.enable or [ ]);

  default = {
    optimiseStore = true;
    garbageCollection = {
      enable = true;
      dates = "weekly";
    };
  };

  cfg = default // (vars.system.config.nix or { });
in
{
  config = lib.mkIf enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = cfg.optimiseStore;
      trusted-users = [
        "root"
        "@wheel"
      ];

      max-jobs = "auto";
      cores = 0;
    };

    nixpkgs.config.allowUnfree = true;

    nix.gc = lib.mkIf cfg.garbageCollection.enable {
      automatic = true;
      dates = cfg.garbageCollection.dates;
      options = "--delete-older-than 7d";
    };
  };
}
