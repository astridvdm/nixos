{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        ./git
        ./gnome
        ./obs-virtualcam
        ./packages
        ./scripts
        ./ssh
        ./starship
        ./zsh
    ];
}
