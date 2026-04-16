# Contributing

## Contributing a Scaffold

To contribute a scaffold, it needs to meet the following requirements:
- *Must* be in `/scaffolds/<language name>`
- *Must* have a `flake.nix` file that outputs a devShell, package, and app
  - Except Swift because the Swift version in nixpkgs is outdated and broken
- *Must* have a `.gitignore` to ignore `/.direnv`, `/result`, and the directory that the language's build system puts artifacts in
- *Must* have a `.envrc` to use the flake
- *Must* have a `.github/workflows/build.yaml` GitHub action to build the project
  - *Must* build using both the language's build tool **and** Nix
    - Except Swift for reasons stated above
- Project name *Must* be `example`
- All instances of example text *must* be annotated with a `TODO: Change` comment
  - Includes things like example names, versions, and descriptions
