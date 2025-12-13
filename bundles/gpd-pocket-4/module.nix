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
        network = (import ../../modules/waybar/settings.nix).network // {
          interface = "wlp195s0";
          format = "<span color='#41A6B5'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-wifi = "<span color='#41A6B5'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-ethernet = "<span color='#41A6B5'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-linked = "<span color='#41A6B5'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-disconnected = "<span color='#41A6B5'>--</span>";
          format-disabled = "<span color='#41A6B5'>--</span>";
        };
        "network#wwan" = (import ../../modules/waybar/settings.nix)."network#wwan" // {
          interface = "wwp197s0f4u1i4";
          format = "<span color='#bb9af7'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-wifi = "<span color='#bb9af7'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-ethernet = "<span color='#bb9af7'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-linked = "<span color='#bb9af7'>↓{bandwidthDownBytes:>5} ↑{bandwidthUpBytes:>5}</span>";
          format-disconnected = "<span color='#bb9af7'>--</span>";
          format-disabled = "<span color='#bb9af7'>--</span>";
        };
      };
      "style.css".content = builtins.replaceStrings [ "font-size: 11px" ] [ "font-size: 10px" ] (
        builtins.readFile ../../modules/waybar/style.css
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
