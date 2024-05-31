{ inputs, cell, lib }:
let
  inherit (inputs) nixpkgs;
  inherit (cell)
    bee
    hardwareProfiles
    nixosProfiles
    ;

  hostname = "partitio";
in
{
  inherit bee;

  imports =
    let
      profiles = with nixosProfiles; [
        nix
      ];
    in
    lib.concatLists [
      [
        hardwareProfiles."${hostname}"
      ]
      profiles
    ];

  users.users.foo = {
    isNormalUser = true;
    initialPassword = "foo";
  };

  environment.systemPackages = with nixpkgs; [ hello ];
  system.stateVersion = "23.11";
}
