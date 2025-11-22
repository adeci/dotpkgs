{ pkgs, wrappers, ... }:
let
  backgroundImage = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/adeci/wallpapers/main/tokyo-night/tokyo-night_nix.png";
    sha256 = "sha256-W5GaKCOiV2S3NuORGrRaoOE2x9X6gUS+wYf7cQkw9CY=";
  };
  openTerminalCwdScript = pkgs.writeShellScript "open-terminal-cwd" ''
    PATH=${pkgs.swaycwd}/bin:$PATH
    ${builtins.readFile ./scripts/open-terminal-cwd.sh}
  '';
  swayConfig = pkgs.runCommand "sway-config" { } ''
    substitute ${./config} $out \
      --replace "@backgroundImage@" "${backgroundImage}" \
      --replace "@openTerminalCwdScript@" "${openTerminalCwdScript}"
  '';
in
{
  sway =
    (wrappers.wrapperModules.sway.apply {
      inherit pkgs;
      swayConfig.path = swayConfig;
    }).wrapper;
}
