{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        ./gnome
        ./obs-virtualcam
        ./packages
        ./scripts
        ./ssh
        ./starship
        ./zsh
    ];
}
