{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.star-citizen;

in {
    options.modules.star-citizen = { enable = mkEnableOption "star-citizen"; };
    config = mkIf cfg.enable {

      # Increase vm count for Star Citizen
      boot.kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
      };
    };
}
