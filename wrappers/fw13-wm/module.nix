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
      "style.css".path = ../waybar-laptop/style.css;
    }).wrapper;

  kanshi =
    (wrappers.wrapperModules.kanshi.apply {
      inherit pkgs;
      configFile.content = ''
        profile {
          output eDP-1 mode 2880x1920@120Hz scale 2.0 position 0,0
        }
      '';
    }).wrapper;

  sway = (import ../sway/module.nix { inherit pkgs wrappers; }).sway;
  kitty = (import ../kitty/module.nix { inherit pkgs wrappers; }).kitty;
  mako = (import ../mako/module.nix { inherit pkgs wrappers; }).mako;
  fuzzel = (import ../fuzzel/module.nix { inherit pkgs wrappers; }).fuzzel;
  swaylock = (import ../swaylock/module.nix { inherit pkgs wrappers; }).swaylock;
  swayosd = (import ../swayosd/module.nix { inherit pkgs wrappers; }).swayosd;
in
{
  fw13-wm = pkgs.symlinkJoin {
    name = "fw13-wm";
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
