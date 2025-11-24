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

        # Simple wrappers (no parameters)
        kitty = (import ./wrappers/kitty/module.nix { inherit pkgs wrappers; }).kitty;
        fuzzel = (import ./wrappers/fuzzel/module.nix { inherit pkgs wrappers; }).fuzzel;
        mako = (import ./wrappers/mako/module.nix { inherit pkgs wrappers; }).mako;
        btop = (import ./wrappers/btop/module.nix { inherit pkgs wrappers; }).btop;

        # Overridable wrappers
        waybar = pkgs.lib.makeOverridable (
          {
            battery ? false,
            bluetooth ? false,
            backlight ? false,
          }:
          (import ./wrappers/waybar/module.nix {
            inherit
              pkgs
              wrappers
              battery
              bluetooth
              backlight
              ;
          }).waybar
        ) { };

        sway = pkgs.lib.makeOverridable (
          {
            outputs ? [
              {
                name = "eDP-1";
                resolution = "2880x1920@120Hz";
                scale = 2;
                position = "0 0";
              }
            ],
          }:
          (import ./wrappers/sway/module.nix {
            inherit pkgs wrappers outputs;
          }).sway
        ) { };
      in
      {
        packages = {
          inherit
            kitty
            fuzzel
            mako
            btop
            waybar
            sway
            ;
        };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
