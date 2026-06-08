{
  description = "go devshell and package, created by scaffolder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "go-devshell";

          packages = with pkgs; [
            dub
            ldc
          ];
        };

        packages.example = pkgs.stdenv.mkDerivation {
          pname = "example"; # TODO: Change
          version = "0.0.0"; # TODO: Change

          src = ./.;

          nativeBuildInputs = [
            pkgs.dub
            pkgs.ldc
          ];

          buildPhase = ''
            runHook preBuild

            dub build --build=release

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp bin/example $out/bin/ # TODO: Change

            runHook postInstall
          '';
        };

        apps.example = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.example}/bin/example"; # TODO: Change
        };
      });
}
