{
  pkgs,
  wrappers,
  outputs ? [
    {
      name = "eDP-1";
      resolution = "2880x1920@120Hz";
      scale = 2;
      position = "0 0";
    }
  ],
  ...
}:
let
  backgroundImage = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/adeci/wallpapers/main/tokyo-night/tokyo-night_nix.png";
    sha256 = "sha256-W5GaKCOiV2S3NuORGrRaoOE2x9X6gUS+wYf7cQkw9CY=";
  };

  outputsConfig = pkgs.lib.concatStringsSep "\n" (
    map (o: "output ${o.name} pos ${o.position} res ${o.resolution} scale ${toString o.scale}") outputs
  );

  openKittyCwdScript = pkgs.writeShellScript "open-kitty-cwd" (
    builtins.readFile ./scripts/open-kitty-cwd.sh
  );

  swayConfig = pkgs.runCommand "sway-config" { } ''
    substitute ${./config} $out \
      --replace "@backgroundImage@" "${backgroundImage}" \
      --replace "@openKittyCwdScript@" "${openKittyCwdScript}" \
      --replace "@outputs@" "${outputsConfig}"
  '';
in
{
  sway =
    (wrappers.wrapperModules.sway.apply {
      inherit pkgs;
      configFile.path = swayConfig;
    }).wrapper;
}
