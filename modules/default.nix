{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        #./obs-virtualcam
        ./packages
        ./ssh
        ./starship
        ./zsh
    ];
}
