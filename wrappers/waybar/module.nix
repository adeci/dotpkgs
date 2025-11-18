{ pkgs, wrappers, ... }:
{
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs;

      configFile.path = ./config;
      style.path = ./style.css;

    }).wrapper;
}
