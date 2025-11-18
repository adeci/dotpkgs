{
  description = "adeci tool pkgs wrapped with configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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

        wrapperPaths = {
          btop = ./wrappers/btop/module.nix;
          kitty = ./wrappers/kitty/module.nix;
          sway = ./wrappers/sway/module.nix;
          waybar = ./wrappers/waybar/module.nix;
        };

        packages = builtins.mapAttrs (
          name: path:
          let
            module = import path { inherit pkgs wrappers; };
          in
          module.${name}
        ) wrapperPaths;
      in
      {
        packages = packages;
        formatter = pkgs.nixfmt-tree;
      }
    );
}
