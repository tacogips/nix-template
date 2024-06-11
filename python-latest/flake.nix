{
  description = "my python project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs =
          (with pkgs;
          [
            just
            nodePackages.pyright

            (python3.withPackages
              (pypkg:
                (import ./pydep.nix {
                  inherit pypkg;
                })

              ))



          ]);

        shellHook = ''

        '';
      };
    });
}
