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
            go
            gopls
            gotools
            delve
            just
          ];
        };

        packages.scaffolder = pkgs.buildGoModule {
          pname = "scaffolder";
          version = "2026.04.15-a";

          src = self;

          vendorHash = "sha256-a8Alui9Ly9gYHclR3d+1EuMfT9eZmonrgnAL28O4Gvs=";

          subPackages = [ "." ];
          ldflags = [ "-s" "-w" ];

          meta = with pkgs.lib; {
            description = "A tool to initialise project scaffolds for various languages, powered by Nix";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };

        apps.scaffolder = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.scaffolder}/bin/scaffolder";
        };
      });
}
