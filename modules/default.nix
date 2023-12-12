{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        ./git
        ./gnome
        ./packages
        ./ssh
        ./starship
        ./zsh
    ];
}
