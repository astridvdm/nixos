{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {

        chrome-widevine = true;
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
