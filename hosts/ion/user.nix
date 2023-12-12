{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        scripts.enable = true;
        ssh.enable = true;
        starship.enable = true;
        zsh.enable = true;

        # system
        #xdg.enable = true;
        packages.enable = true;

    };
}
