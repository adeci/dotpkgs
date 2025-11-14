{ pkgs, wrappers, ... }:
{
  waybar =
    (wrappers.wrapperModules.waybar.apply {
      inherit pkgs;

      waybarconfig.path = ./config;

    }).wrapper;
}
