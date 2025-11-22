{ pkgs, wrappers, ... }:
{
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs;

      configFile.path = ./config;
      "style.css".path = ./style.css;

    }).wrapper;
}
