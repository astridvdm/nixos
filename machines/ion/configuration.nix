{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Choose kernel package
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Nvidia config

  # # Enable OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Increase vm count for Star Citizen
  boot.kernel.sysctl = {
  "vm.max_map_count" = 16777216;
  "fs.file-max" = 524288;
  # Fix large workspaces for vscode
  "fs.inotify.max_user_watches" = "1048576"; # 128 times the default 8192
  };

  # Internel HDD WD Blue 2TB
  fileSystems."/mnt/hdd" =
    { device = "/dev/disk/by-uuid/a91a69e4-9131-49e4-83fa-dc0fcd5240a9";
      fsType = "btrfs";
      options = [ "acl" "autodefrag" "defaults" "nofail" "nossd" "compress=zstd:5" "noatime"
      ];
    };


  # SSHFS mount for Ceres's ZFS Array
  fileSystems."/ceres" =
   { device = "max@ceres:/ceres";
     fsType = "fuse.sshfs";
     options = [ "noauto" "x-systemd.automount" "_netdev" "user" "idmap=user" "follow_symlinks" "identityfile=/home/max/.ssh/max-a17" "allow_other" "default_permissions" "uid=1000" "gid=1000" ];
   };


  # Fido2 Luks
  # boot.initrd.luks.fido2Support = true;
  # boot.initrd.luks.yubikeySupport = true;
  # boot.initrd.luks.devices."/dev/nvme0n1p3".fido2.credential = "24a327c81b67c0055c6b254183b88548394df0e1916c28e62136de0686ec9278a6be8c67004e10e0272f24ba63754afa";


  # # Archival array
  # fileSystems."/mnt/6tb" =
  #   { device = "/dev/disk/by-uuid/5018a3ea-a629-4007-b04d-51df486b0a25";
  #     fsType = "btrfs";
  #     options = [
  #       "acl"
  #       "autodefrag"
  #       "defaults"
  #       "nofail"
  #       "nossd"
  #       "compress=zstd:3"
  #       "noatime"
  #       #"ro"
  #       #"usebackuproot"
  #       #"recovery"
  #       #"nospace_cache"
  #       #"clear_cache"
  #     ];
  #   };

  # Networking

  # Define your hostname
  networking.hostName = "ion";

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

  # Enable the Gnome Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable gsync for unverified monitor(s)
  services.xserver.screenSection =
  ''
    Option         "metamodes" "DP-2: nvidia-auto-select +1920+0 {AllowGSYNCCompatible=On}, DP-0: nvidia-auto-select +0+0 {AllowGSYNCCompatible=On}"
  '';

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
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirtd" "input" "plugdev" ];
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

  #nixpkgs.config.spotify.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

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
    dive # look into docker image layers
    gparted # partition manager
    steamtinkerlaunch
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
    cheese # webcam tool
    epiphany # web browser
    geary # email reader
    yelp # Help view
  ]) ++ (with pkgs.gnome; [
      gnome-music      
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      gnome-initial-setup
    ]);

  # Enable Widevine for Chrome
  nixpkgs.config = {
    #allowUnfree = true;
    ungoogled.enableWideVine = true;
    chromium.enableWideVine = true;
  };

  # List services that you want to enable:

  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # # Corsair keyboard control
  # hardware.ckb-next.enable = true;

  # RGB Control for system
  services.hardware.openrgb.enable = true;

  # Hardware crypto wallet manager
  hardware.ledger.enable = true;
  
  # #groups.plugdev = {};
  # # Required for Ledger Live to detect Ledger Nano S via USB
  # services.udev.extraRules = ''
  # # firmware 1.6.0+
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004", MODE="0660", TAG+="uaccess", TAG+="udev-acl"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1011", MODE="0660", GROUP="plugdev"
  # SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="1015", MODE="0660", GROUP="plugdev"

  # ''
  # ;

  # KVM Virtual machines
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  # Steam
  programs.steam.enable = true;

  # Docker
  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  };

  # # Enable common container config files in /etc/containers
  # virtualisation.containers.enable = true;
  # virtualisation = {
  #   podman = {
  #     enable = true;

  #     # Create a `docker` alias for podman, to use it as a drop-in replacement
  #     dockerCompat = true;

  #     # Required for containers under podman-compose to be able to talk to each other.
  #     defaultNetwork.settings.dns_enabled = true;
  #   };
  # };
  # hardware.nvidia-container-toolkit.enable = true;

# Flatpak
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
    packages = [ "hu.irl.cameractrls" "org.signal.Signal" ];
  };

  # iOS Documents
  services.usbmuxd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  ## Mullvad
  #services.mullvad-vpn.enable = true;

  # OBS Virtual Cam
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;


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
  system.stateVersion = "24.11"; # Did you read the comment?
}
