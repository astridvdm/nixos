{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        git = true;
        gnome = true;
        obs-virtualcam = true;
        packages = true;
        scripts = true;
        ssh = true;
        starship = true;
        zsh = true;

    };
}
