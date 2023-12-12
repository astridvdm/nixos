{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        #./obs-virtualcam
        ./packages
        ./scripts
        ./ssh
        ./starship
        ./zsh
    ];
}
