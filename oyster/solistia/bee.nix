#        ████  ████
#      ██    ██    ██
#        ██    ██  ██
#          ██████████
#        ████░░██░░░░██
#      ██░░██░░██░░░░░░▓▓
#  ▓▓▓▓██░░██░░██░░▓▓░░██
#      ██░░██░░██░░░░░░██
#        ████░░██░░░░██
#          ██████████

{ inputs, cell }:
let
  system = "x86_64-linux";
in
{
  inherit system;

  pkgs = import inputs.nixpkgs {
    inherit system;

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };

    overlays = with inputs; [
      nur.overlay
      microvm.overlay
      nix-vscode-extensions.overlays.default
      fenix.overlays.default

      (final: prev: {
        mkWaylandApp =
          t: e: f:
          prev.stdenv.mkDerivation {
            pname = t.pname or t.name + "-mkWaylandApp";
            inherit (t) version;
            unpackPhase = "true";
            doBuild = false;
            nativeBuildInputs = [ prev.buildPackages.makeWrapper ];
            installPhase = ''
              mkdir -p $out/bin
              ln -s "${prev.lib.getBin t}/bin/${e}" "$out/bin"
              ln -s "${prev.lib.getBin t}/share" "$out/share"
            '';
            postFixup = ''
              for e in $out/bin/*; do
                wrapProgram $e --add-flags ${prev.lib.escapeShellArg f}
              done
            '';
          };
      })
    ];
  };
}
