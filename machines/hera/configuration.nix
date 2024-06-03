{ config, pkgs, ... }:

{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Choose kernel package
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  # Increase vm count for Star Citizen
  boot.kernel.sysctl = {
  "vm.max_map_count" = 16777216;
  "fs.file-max" = 524288;
  };

  # SSHFS mount for Ceres's ZFS Array
  fileSystems."/mnt/ceres" =
   { device = "max@10.0.0.2:/mnt/ceres";
     fsType = "fuse.sshfs";
     options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
   };

  # Networking

  # Define your hostname
  networking.hostName = "hera";

  # Enable networking for Gnome
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
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

  # Enable the X11/Wayland windowing system.
  services.xserver.enable = true;

  # Enable the Gnome Desktop
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap
  services.xserver.xkb = {
    variant = "za";
    layout = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users

  # Max
  users.users.max = {
    # create account as standard user
    isNormalUser = true;
    # Name
    description = "Max";
    # Groups
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvrt" "input" ];
    # Specify user shell
    shell = "/run/current-system/sw/bin/zsh";
    # User packages
    packages = with pkgs; [ ];
  };

  # Enable wayland flag for windows
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable ZSH shell as default
  environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
#    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
#    gnome-terminal
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

  # List services that you want to enable:

  # Asus
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Hardware crypto wallet manager
  #hardware.ledger.enable = true;

  # KVM Virtual machines
  virtualisation.libvirtd.enable = true;

  # Steam
  programs.steam.enable = true;

  # Docker
  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  };

  # Flatpak
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
    packages = [ "hu.irl.cameractrls" ];
  };

  # iOS Documents
  services.usbmuxd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  ## Mullvad
  #services.mullvad-vpn.enable = true;

  # # OBS Virtual Cam
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   v4l2loopback
  # ];
  # boot.extraModprobeConfig = ''
  #   options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  # '';
  # security.polkit.enable = true;


  # NixOS Optimise
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
