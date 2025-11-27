{
  pkgs,
  wrappers,
  ...
}:
let
  settings = import ./settings.nix;
in
{
  waybar-laptop =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs settings;
      "style.css".path = ./style.css;
    }).wrapper;
}
