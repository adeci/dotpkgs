{
  description = "adeci tool pkgs wrapped with configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    wrappers = {
      url = "github:adeci/wrappers?ref=adeci-wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      wrappers,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        wrapperDirs = builtins.readDir ./wrappers;

        wrapperNames = builtins.attrNames (
          pkgs.lib.filterAttrs (name: type: type == "directory") wrapperDirs
        );

        packages = builtins.listToAttrs (
          map (name: {
            inherit name;
            value =
              let
                module = import ./wrappers/${name}/module.nix { inherit pkgs wrappers; };
              in
              module.${name};
          }) wrapperNames
        );
      in
      {
        packages = packages;
        formatter = pkgs.nixfmt-tree;
      }
    );
}
