{
  description = "adeci tool pkgs wrapped with configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    wrappers = {
      url = "github:adeci/wrappers?ref=adeci-wrappers";
      #url = "path:///home/alex/git/wrappers";
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

        # Get all directories from modules/
        moduleDirs = builtins.attrNames (
          pkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./modules)
        );

        # Get all directories from bundles/
        bundleDirs = builtins.attrNames (
          pkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./bundles)
        );

        # Import a module
        importModule = dir: import ./modules/${dir}/module.nix { inherit pkgs wrappers; };

        # Import a bundle
        importBundle = dir: import ./bundles/${dir}/module.nix { inherit pkgs wrappers; };

        # Combine all packages from modules and bundles
        modulePackages = builtins.foldl' (acc: dir: acc // (importModule dir)) { } moduleDirs;
        bundlePackages = builtins.foldl' (acc: dir: acc // (importBundle dir)) { } bundleDirs;
      in
      {
        packages = modulePackages // {
          bundles = bundlePackages;
        };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
