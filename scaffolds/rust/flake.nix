{
  description = "rust devshell and package, created by scaffolder";

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
          name = "rust-devshell";

          packages = with pkgs; [
            cargo
            rustc
            rustfmt
            clippy
            pkg-config
          ];
        };

        packages.example = pkgs.rustPlatform.buildRustPackage {
          name = "example"; # TODO: Change
          version = "0.1.0"; # TODO: Change

          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;
        };

        apps.example = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.example}/bin/example"; # TODO: Change
        };
      });
}
