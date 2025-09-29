{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minimalFox = {
      url = "github:Jamir-boop/minimalisticfox";
      flake = false;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      commonModules = [
        ./modules/nixos
        inputs.disko.nixosModules.disko
        inputs.niri.nixosModules.niri
      ];

      commonHomeModules = [
        {
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];
        }
        ./modules/home-manager
      ];

      mkSpecialArgs = hostname: {
        inherit inputs system;
        vars = import ./lib/vars/${hostname}.nix { lib = nixpkgs.lib; };
        tools = import ./lib/tools.nix { 
          lib = nixpkgs.lib; 
          vars = import ./lib/vars/${hostname}.nix { lib = nixpkgs.lib; };
        };
      };

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = mkSpecialArgs hostname;
        modules = [./hosts/${hostname}/configuration.nix] ++ commonModules;
      };

      mkHome = hostname: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = mkSpecialArgs hostname;
        modules = [ ./hosts/${hostname}/home.nix ] ++ commonHomeModules;
      };

      hosts = ["desktop" "laptop"];
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
      homeConfigurations = nixpkgs.lib.genAttrs hosts mkHome;
    };
}
