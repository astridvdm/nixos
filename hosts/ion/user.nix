{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        ssh.enable = true;
        starship.enable = true;
        zsh.enable = true;

        # system
        #xdg.enable = true;
        packages.enable = true;

    };
}
