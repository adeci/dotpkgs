{ pkgs, wrappers, ... }:
{
  btop =
    (wrappers.wrapperModules.btop.apply {
      inherit pkgs;

      "btop.conf".path = ./btop.conf;

      # Add ROCm SMI library path for AMD GPU monitoring
      extraPackages = [ pkgs.rocmPackages.rocm-smi ];
      env.LD_LIBRARY_PATH = "${pkgs.rocmPackages.rocm-smi}/lib";

    }).wrapper;
}
