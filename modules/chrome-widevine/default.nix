{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.chrome-widevine;

in {
    options.modules.chrome-widevine = { enable = mkEnableOption "chrome-widevine"; };
    config = mkIf cfg.enable {

      nixpkgs.config = {
      #allowUnfree = true;
      ungoogled.enableWideVine = true;
      chromium.enableWideVine = true;
      };

    };
}
