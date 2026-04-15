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

        packages.spyglass = pkgs.buildGoModule {
          pname = "example"; # TODO: Change
          version = "0.0.0"; # TODO: Change

          src = self;

          vendorHash = pkgs.lib.fakeHash; # TODO: Change

          subPackages = [ "." ];
          ldflags = [ "-s" "-w" ];

          meta = with pkgs.lib; {
            description = "Placeholder"; # TODO: Change
            license = licenses.mit;
            platforms = platforms.all;
          };
        };

        apps.spyglass = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.example}/bin/example"; # TODO: Change
        };
      });
}
