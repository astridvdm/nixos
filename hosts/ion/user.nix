{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        #gnome = true;
        #obs-virtualcam = true;
        scripts = true;
        ssh = true;
        starship = true;
        zsh = true;

        # system
        #xdg.enable = true;
        packages.enable = true;

    };
}
