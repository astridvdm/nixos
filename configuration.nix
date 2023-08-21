# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia-config.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9f36e060-437b-4a1c-ab2e-d6304ea428f5".device = "/dev/disk/by-uuid/9f36e060-437b-4a1c-ab2e-d6304ea428f5";
  boot.initrd.luks.devices."luks-9f36e060-437b-4a1c-ab2e-d6304ea428f5".keyFile = "/crypto_keyfile.bin";

  fileSystems."/mnt/terra" =
    { device = "max@10.0.0.3:/mnt/terra";
      fsType = "fuse.sshfs";
      options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
    };

  fileSystems."/mnt/ares" =
    { device = "max@10.0.0.2:/mnt/ares";
      fsType = "fuse.sshfs";
      options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
    };

  fileSystems."/mnt/max-12tb" =
    { device = "max@10.0.0.3:/mnt/max-12tb";
      fsType = "fuse.sshfs";
      options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
    };

  fileSystems."/mnt/hdd" =
    { device = "/dev/disk/by-uuid/a91a69e4-9131-49e4-83fa-dc0fcd5240a9";
      fsType = "btrfs";
      options = [ "acl" "autodefrag" "defaults" "nofail" "nossd" "compress=zstd:5" "noatime"
      ];
    };



  networking.hostName = "max-pc"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "za";
    xkbVariant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvrt" "input" ];
    shell = "/run/current-system/sw/bin/zsh";
    packages = with pkgs; [ ];
  };

   environment.sessionVariables.NIXOS_OZONE_WL = "1";

   environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    wget
    git
    zsh
    unzip
    sshfs
    nodejs
    sass
    wireguard-tools
    cfs-zen-tweaks # Kernal tweaks to make system feel more responsive at the cost of throughput
    screen # Allow terminal tasks to run in background
    tailscale # Remote wireguard based p2p vpn
  ];

  environment.gnome.excludePackages = (with pkgs; [
#    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
#    gnome-terminal
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

  # Services
  programs.steam.enable = true;
  services.tailscale.enable = true;
  hardware.ckb-next.enable = true;
  hardware.ledger.enable = true;
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  #services.teamviewer.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Docker
  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  };

  #boot.supportedFilesystems = [ "ntfs" ];

  # nixpkgs.config = {
  #   #allowUnfree = true;
  #   ungoogled.enableWideVine = true;
  #   chromium.enableWideVine = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.checkReversePath = "loose";

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

  system.stateVersion = "23.05";
}
