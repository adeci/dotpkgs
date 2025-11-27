{ pkgs, wrappers, ... }:
{
  kanshi =
    (wrappers.wrapperModules.kanshi.apply {
      inherit pkgs;

      configFile.content = ''
        profile {
          output eDP-1 mode 2880x1920@120Hz scale 2.0 position 0,0
        }
      '';

    }).wrapper;
}
