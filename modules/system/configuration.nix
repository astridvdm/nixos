{ config, pkgs, inputs, ... }:

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;

    programs.zsh.enable = true;


    # System Packages

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget
      git
      zsh
      unzip
      sshfs
      screen # Allow terminal tasks to run in background
      tailscale # Remote wireguard based p2p vpn
    ];

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

    # # Install fonts
    # fonts = {
    #     fonts = with pkgs; [
    #         jetbrains-mono
    #         roboto
    #         openmoji-color
    #         (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    #     ];

    #     fontconfig = {
    #         hinting.autohint = true;
    #         defaultFonts = {
    #           emoji = [ "OpenMoji Color" ];
    #         };
    #     };
    # };


    # # Wayland stuff: enable XDG integration, allow sway to use brillo
    # xdg = {
    #     portal = {
    #         enable = true;
    #         extraPortals = with pkgs; [
    #             xdg-desktop-portal-wlr
    #             xdg-desktop-portal-gtk
    #         ];
    #         gtkUsePortal = true;
    #     };
    # };

    # Nix settings, auto cleanup and enable flakes
    boot.loader.systemd-boot.configurationLimit = 10;

    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "max" ];
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
        '';
    };

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        loader = {
        systemd-boot.enable = true;
        systemd-boot.editor = false;
        efi.canTouchEfiVariables = true;
        timeout = 0;
        };
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "Africa/Johannesburg";
    i18n.defaultLocale = "en_ZA.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_ZA.UTF-8";
      LC_IDENTIFICATION = "en_ZA.UTF-8";
      LC_MEASUREMENT = "en_ZA.UTF-8";
      LC_MONETARY = "en_ZA.UTF-8";
      LC_NAME = "en_ZA.UTF-8";
      LC_NUMERIC = "en_ZA.UTF-8";
      LC_PAPER = "en_ZA.UTF-8";
      LC_TELEPHONE = "en_ZA.UTF-8";
      LC_TIME = "en_ZA.UTF-8";
    };

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Set up user and enable sudo
    users.users.max = {
        isNormalUser = true;
        description = "Max";
        extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvrt" "input" ];
        shell = pkgs.zsh;
    };

    # Set up networking and secure it
    networking = {
      networkmanager.enable = true;
    };

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        EDITOR = "code";;
        sessionVariables.NIXOS_OZONE_WL = "1";
    };


    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Do not touch
    system.stateVersion = "23.11";
}
