{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui

        # cli
        zsh.enable = true;
        git.enable = true;

        # system
        packages.enable = true;
    };
}
