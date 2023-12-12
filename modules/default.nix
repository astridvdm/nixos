{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        ./chrome-widevine
        ./git
        ./gnome
        ./packages
        ./scripts
        ./ssh
        ./starship
        ./system
        ./zsh
    ];
}
