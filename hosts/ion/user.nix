{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        gnome.enable = true;
        obs-virtualcam.enable = true;
        scripts.enable = true;
        ssh.enable = true;
        starship.enable = true;
        zsh.enable = true;

        # system
        #xdg.enable = true;
        packages.enable = true;

    };
}
