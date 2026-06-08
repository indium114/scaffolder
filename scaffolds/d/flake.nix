{
  description = "go devshell and package, created by scaffolder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "go-devshell";

          packages = with pkgs; [
            dub
            ldc
            serve-d
            dfmt
            dub-to-nix
          ];
        };

        packages.example = pkgs.buildDubPackage {
          pname = "example"; # TODO: Change
          version = "0.0.0"; # TODO: Change

          src = ./.;

          dubLock = ./dub-lock.json;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp example $out/bin/ # TODO: Change

            runHook postInstall
          '';

          meta = {
            description = "example"; # TODO: Change
            homepage = "example"; # TODO: Change
            licenses = pkgs.lib.licenses.unlicense; # TODO: Change
          };
        };

        apps.example = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.example}/bin/example"; # TODO: Change
        };
      }
    );
}
