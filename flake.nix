{
  description = "adeci tool pkgs wrapped with configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    wrappers = {
      #url = "github:adeci/wrappers?ref=adeci-wrappers";
      url = "path:///home/alex/git/wrappers";
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

        wrapperDirs = builtins.attrNames (
          pkgs.lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./wrappers)
        );

        importWrapper = dir: import ./wrappers/${dir}/module.nix { inherit pkgs wrappers; };

        allPackages = builtins.foldl' (acc: dir: acc // (importWrapper dir)) { } wrapperDirs;
      in
      {
        packages = allPackages;

        formatter = pkgs.nixfmt-tree;
      }
    );
}
