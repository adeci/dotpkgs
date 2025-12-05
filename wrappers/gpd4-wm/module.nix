{
  pkgs,
  wrappers,
  ...
}:
let
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs;
      settings = import ../waybar-laptop/settings.nix;
      "style.css".content = builtins.replaceStrings [ "font-size: 11px" ] [ "font-size: 10px" ] (
        builtins.readFile ../waybar-laptop/style.css
      );
    }).wrapper;

  kanshi =
    (wrappers.wrapperModules.kanshi.apply {
      inherit pkgs;
      configFile.content = ''
        profile {
          output eDP-1 mode 1600x2560@144Hz scale 2 position 0,0
        }
      '';
    }).wrapper;

  sway = (import ../sway/module.nix { inherit pkgs wrappers; }).sway;
  kitty = (import ../kitty/module.nix { inherit pkgs wrappers; }).kitty;
  mako = (import ../mako/module.nix { inherit pkgs wrappers; }).mako;
  fuzzel = (import ../fuzzel/module.nix { inherit pkgs wrappers; }).fuzzel;
  swaylock = (import ../swaylock/module.nix { inherit pkgs wrappers; }).swaylock;

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
  gpd4-wm = pkgs.symlinkJoin {
    name = "gpd4-wm";
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
