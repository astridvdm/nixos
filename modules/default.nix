{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        ./chrome-widevine
        ./git
        ./gnome
        ./obs-virtualcam
        ./packages
        ./scripts
        ./ssh
        ./star-citizen
        ./starship
        ./system
        ./zsh
    ];
}
