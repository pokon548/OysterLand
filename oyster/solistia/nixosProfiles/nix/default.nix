{ inputs
, cell
, pkgs
, lib
, config
,
}:
{
  nix = {
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    gc = {
      automatic = true;
      options = "--delete-older-than 28d";
      dates = "daily";
    };

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      sandbox = false;
      trusted-users = [
        "pokon548"
      ];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://microvm.cachix.org"
        "https://pokon548.cachix.org"
        "https://cache.garnix.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "pokon548.cachix.org-1:fhQhJ1PubjdhjdqTUnUtvszMcYG4pSgyeVUWOOxKklM="
      ];
    };
  };

  system.switch = {
    enable = false;
    enableNg = true;
  };

  programs.command-not-found.enable = lib.mkForce false;
}
