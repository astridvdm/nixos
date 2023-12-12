{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.ssh;

in {

 programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "ares" = {
      hostname = "10.0.0.2";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "terra" = {
      hostname = "10.0.0.3";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "hera" = {
      hostname = "10.0.0.21";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "orion" = {
      hostname = "100.112.75.88";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "lux" = {
      hostname = "172.16.0.212";
      proxyJump = "100.96.163.55";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "u334582.your-storagebox.de" = {
      hostname = "u334582.your-storagebox.de";
      user = "u334582";
      port = 23;
      identityFile = "/home/max/.ssh/hetzner-borg";
      };
      "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "/home/max/.ssh/max-git-yk";
      };
    };
  };
}