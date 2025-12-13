{
  pkgs,
  wrappers,
  ...
}:
let
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs;
      settings = (import ../../modules/waybar/settings.nix) // {
        modules-right = [
          "network"
          "bluetooth"
          "custom/cpu"
          "custom/gpu"
          "memory"
          "disk"
          "backlight"
          "pulseaudio"
          "custom/battery"
          "clock"
        ];
      };
      "style.css".path = ../../modules/waybar/style.css;
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

  sway = (import ../../modules/sway/module.nix { inherit pkgs wrappers; }).sway;
  kitty = (import ../../modules/kitty/module.nix { inherit pkgs wrappers; }).kitty;
  mako = (import ../../modules/mako/module.nix { inherit pkgs wrappers; }).mako;
  fuzzel = (import ../../modules/fuzzel/module.nix { inherit pkgs wrappers; }).fuzzel;
  swaylock = (import ../../modules/swaylock/module.nix { inherit pkgs wrappers; }).swaylock;
  swayosd = (import ../../modules/swayosd/module.nix { inherit pkgs wrappers; }).swayosd;
in
{
  framework-13 = pkgs.symlinkJoin {
    name = "framework-13";
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
