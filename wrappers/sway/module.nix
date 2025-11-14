{ pkgs, wrappers, ... }:
let
  backgroundImage = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/adeci/wallpapers/main/tokyo-night/tokyo-night_nix.png";
    sha256 = "sha256-W5GaKCOiV2S3NuORGrRaoOE2x9X6gUS+wYf7cQkw9CY=";
  };
  swayConfig = pkgs.runCommand "sway-config" { } ''
    substitute ${./config} $out \
      --replace "@backgroundImage@" "${backgroundImage}" \
  '';
in
{
  sway =
    (wrappers.wrapperModules.sway.apply {
      inherit pkgs;
      swayconfig.path = swayConfig;
    }).wrapper;
}
