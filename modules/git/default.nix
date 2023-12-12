{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.git;

in {
    options.modules.git = { enable = mkEnableOption "git"; };
    config = mkIf cfg.enable {
        programs.git = {
            enable = true;
            userName = "Max van der Merwe";
            userEmail = "git@maxvdm.com";
            extraConfig = {
              commit.gpgsign = true;
              gpg.format = "ssh";
              gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
              user.signingkey = "~/.ssh/max-git.pub";
              init = { defaultBranch = "main"; };
              core = {
                    excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
              };
            };
        };
    };
}