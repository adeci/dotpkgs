{
  pkgs,
  wrappers,
  ...
}:
let
  waybar = (import ./waybar/module.nix { inherit pkgs wrappers; }).waybar;

  kanshi =
    (wrappers.wrapperModules.kanshi.apply {
      inherit pkgs;
      configFile.content = ''
        profile {
          output eDP-1 mode 1600x2560@144Hz scale 2 position 0,0
        }
      '';
    }).wrapper;

  sway = (import ../../modules/sway/module.nix { inherit pkgs wrappers; }).sway;
  kitty = (import ../../modules/kitty/module.nix { inherit pkgs wrappers; }).kitty;
  mako = (import ../../modules/mako/module.nix { inherit pkgs wrappers; }).mako;
  fuzzel = (import ../../modules/fuzzel/module.nix { inherit pkgs wrappers; }).fuzzel;
  swaylock = (import ../../modules/swaylock/module.nix { inherit pkgs wrappers; }).swaylock;

  swayosd =
    (wrappers.wrapperModules.swayosd.apply {
      inherit pkgs;

      settings = {
        server = {
          top_margin = 0.4;
        };
      };

      style.content = ''
        window {
          background: #000000;
          border-radius: 8px;
          border: 2px solid #7aa2f7;
        }
        progressbar progress {
          background: #7aa2f7;
        }
        label, image {
          color: #c0caf5;
        }
      '';
    }).wrapper;
in
{
  gpd-pocket-4 = pkgs.symlinkJoin {
    name = "gpd-pocket-4";
    paths = [
      waybar
      kanshi
      sway
      kitty
      mako
      fuzzel
      swaylock
      swayosd
    ];
  };
}
