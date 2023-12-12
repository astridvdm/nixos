{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        gnome = false;
        obs-virtualcam = true;
        packages = true;
        scripts = true;
        ssh = true;
        starship = true;
        zsh = true;

    };
}
