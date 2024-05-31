{
  # OysterOS and solistia!
  outputs = { self, std, hive, ... }@inputs:
    let
      inherit (inputs.nixpkgs-unstable) lib;
      myCollect = hive.collect // {
        renamer = cell: target: "${target}";
      };
    in
    hive.growOn
      {
        inherit inputs;
        cellsFrom = ./oyster;
        cellBlocks = with (lib.mergeAttrsList [
          std.blockTypes
          hive.blockTypes
        ]); [
          # Bee
          (functions "bee")

          # Modules
          (functions "homeModules")
          (functions "nixosModules")

          # Profiles
          (functions "nixosProfiles")
          (functions "homeProfiles")
          (functions "hardwareProfiles")

          # Configurations
          nixosConfigurations
        ];
      }
      {
        nixosConfigurations = myCollect self "nixosConfigurations";
      };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs.follows = "nixpkgs-unstable";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager.follows = "home-manager-unstable";

    std = {
      url = "github:divnix/std";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hive = {
      url = "github:divnix/hive";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nur.url = "github:nix-community/NUR";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm.url = "github:astro/microvm.nix";
  };
}
