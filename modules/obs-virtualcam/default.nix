{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.obs-virtualcam;

in {
    options.modules.obs-virtualcam = { enable = mkEnableOption "obs-virtualcam"; };
    config = mkIf cfg.enable {

      # OBS Virtual Cam
      boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
      security.polkit.enable = true;
    };
}