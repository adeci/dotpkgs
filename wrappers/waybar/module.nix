{
  pkgs,
  wrappers,
  battery ? true,
  bluetooth ? true,
  backlight ? true,
  ...
}:
let
  settings = import ./settings.nix { inherit battery bluetooth backlight; };
in
{
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs settings;
      "style.css".path = ./style.css;
    }).wrapper;
}
