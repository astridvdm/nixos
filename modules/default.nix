{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.11";
    imports = [
        # gui

        # cli
        ./ssh
        ./zsh
        ./git
        ./starship
        ./

        # system
	    ./packages
        ./nvidia
        ./asus
    ];
}
