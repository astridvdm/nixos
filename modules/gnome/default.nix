{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.gnome;

in {
    options.modules.gnome = { enable = mkEnableOption "gnome"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [ ];

      # Enable the X11/Wayland windowing system.
      services.xserver.enable = true;

      # Enable the Gnome Desktop
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      environment.gnome.excludePackages = (with pkgs; [
        #gnome-photos
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        #gnome-terminal
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);

      # Enable wayland flag for windows
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

    };
}
