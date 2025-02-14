{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # "vm.swappiness"
  boot.kernel.sysctl = { "vm.swappiness" = 100; };

  # Networking

  # Define your hostname
  networking.hostName = "ceres";

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Choose kernel package
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.interfaces.enp0s31f6.ipv4.addresses = [ {
    address = "10.0.0.2";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" "1.0.0.1" ];

  networking.interfaces.enp0s31f6.ipv6.addresses = [ {
    address = "2c0f:f4c0:1185:8174::2";
    prefixLength = 64;
  } ];

  networking.defaultGateway6 = {
    address = "2c0f:f4c0:1185:8174::1";
    interface = "enp0s31f6";
  };


  networking.interfaces.enp0s31f6.tempAddress = "disabled";

  # networking.defaultGateway6 = {
  # address = "fe80::9ab7:85ff:fe01:e7c4";
  # interface = "enp0s31f6";
  # };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  #### ZFS ####

  # Choose latest compatible kernel for ZFS
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Automatic scrubbing
  services.zfs.autoScrub.enable = true;


  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "feab067a";

  boot.zfs.extraPools = [ "ceres" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=32000000000" ];


  # # BTRFS Array
  # fileSystems."/mnt/ceres" =
  #   { device = "/dev/disk/by-uuid/1bca9e27-fc20-4ed1-b84e-3db5a6486019";
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
  #       #"rescue=all"
  #       #"usebackuproot"
  #       #"recovery"
  #       #"nospace_cache"
  #       #"clear_cache"
  #     ];
  #   };

  # Archival BTRFS Array
  # fileSystems."/mnt/6tb" =
  #   { device = "/dev/disk/by-uuid/5018a3ea-a629-4007-b04d-51df486b0a25";
  #     fsType = "btrfs";
  #     options = [
  #      "acl"
  #      "autodefrag"
  #      "defaults"
  #      "nofail"
  #      "nossd"
  #      "compress=zstd:5"
  #      "noatime"
  #     ];
  #   };

  # Printing

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # for a WiFi printer
  services.avahi.openFirewall = true;
  services.printing.drivers = [ pkgs.pantum-driver ];
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network
  services.printing.allowFrom = [ "all" ]; # this gives access to anyone on the interface you might want to limit it see the official documentation
  services.printing.defaultShared = true; # If you want

  # Firewall
  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  # Users

  # astrid
  # create account as standard user
  users.users.astrid = {
    isNormalUser = true;
    # Name
    description = "astrid";
    # Groups
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    # SSH public keys allowed to connect to the ssh server for user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGaeHs7LX8API5+OH4brfqe31b8WMSIZnJ2PIdHsD65 astrid-pc-lux" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFi3dbVfeHJBHYqbx2UD1JkMofbWGdG9kWpu+QqesEN max-a17-lux" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBItfYtTxsE7xl6BgH3LtAoHnFureihclIkoIIyp0HSvdWXz8lyHAYTNm5fRqdb8Wl7ApDn4okCoOajsnyQmLQ/A= max@iphone" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC93Pzn2DxRZK3naV+TCa3FhSKUj+c30GXndAiNiJ0Ksb+KM/fKoxD4tndbF8fSI9e5Kgtneem/1y3ARJrQqiDM= max@ipad" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsnW2eSbP4juFbmLpaEc0E5zROGWoU6Qx3V9n73yl9M max-iphone"];
    # Specify user shell
    shell = "/run/current-system/sw/bin/zsh";
    packages = with pkgs; [];
  };

  environment.shells = with pkgs; [ zsh ];

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # System packages
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     zip
     unzip
     rclone
     yt-dlp
     ffmpeg
     aria
     borgbackup
     screen
     tailscale
     git
     pciutils
     ncdu
     smartmontools
     e2fsprogs
     dive # look into docker image layers
     podman-tui # status of containers in the terminal
     podman-compose # start group of containers for dev
     #docker-compose # start group of containers for dev
     ctop
     zsh
     bat
     nut
   ];

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 3 */2 * * astrid sh /home/astrid/containers/backup.sh >/dev/null 2>&1"
      "0 3 */2 * * astrid sh /ceres/backups/photosync/photosync-backup.sh >/dev/null 2>&1"
      "0 3 */2 * * astrid sh /ceres/media/media.sh >/dev/null 2>&1"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable legacy macs for older sftp clients, ie VLC and Photosync
  services.openssh.settings.Macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    #"umac-128-etm@openssh.com"
    "hmac-sha2-256"
    "hmac-sha2-512"
    ];

  services.openssh.hostKeys = [
    { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
    { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
    #{ type = "dsa"; bits = 1048; path = "/etc/ssh/ssh_host_dsa_key"; }
  ];

  programs.ssh.hostKeyAlgorithms = [
    "ssh-ed25519"
    "ssh-rsa"
    #"ssh-dss"
  ];


  # services.openssh.settings.KexAlgorithms = [
  # "sntrup761x25519-sha512@openssh.com"
  # "curve25519-sha256"
  # "curve25519-sha256@libssh.org"
  # "diffie-hellman-group-exchange-sha256"
  # ];


  # # Enable common container config files in /etc/containers
  # virtualisation.containers.enable = true;
  # virtualisation.containers.registries.search = [ "docker.io" "quay.io"  "ghcr.io" "lscr.io" ];
  # virtualisation = {
  #   podman = {
  #     enable = true;

  #     # Create a `docker` alias for podman, to use it as a drop-in replacement
  #     dockerCompat = true;

  #     # Required for containers under podman-compose to be able to talk to each other.
  #     defaultNetwork.settings = {
	#       dns_enabled = true;
	#       ipv6_enabled = true;
  #     };

  #     # Automaticly prune old images.
  #     autoPrune.enable = true;
  #   };
  # };


  # networking.firewall.interfaces."podman[0-9]+".allowedUDPPorts = [
  #   53
  #   80
  #   443
  # ];
  # networking.firewall.interfaces."podman[0-9]+".allowedTCPPorts = [
  #   53
  #   80
  #   443
  # ];

  # # Docker
  # virtualisation.docker = {
  #   enable = true;
  #   #setSocketVariable = true;
  #   daemon.settings = {
  #     #userland-proxy = false;
  #     ipv6 = true;
  #     ip6tables = true;
  #     fixed-cidr-v6 = "fd00:0::/64";
  #     experimental = true;
  #     #autoPrune = true;
  #   };
  # };

  # Podman

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
	      dns_enabled = true;
	      ipv6_enabled = true;
      };

      # Automaticly prune old images.
      autoPrune.enable = true;
    };
  };

  # Make sure docker starts after the storage array is mounted.
  #systemd.services.docker.after = ["mnt-ceres.mount"];

  # Services

  # Run unpatched dynamic binaries on NixOS - Required for VSCode remotes
  programs.nix-ld.enable = true;

  # Enable LVFS firmware updating system.
  services.fwupd.enable = true;

  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # KVM Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onShutdown = "shutdown";


  # UPS configuration
  power.ups = {

    # Enable
    enable = true;
    mode = "standalone";

    # Device
    ups.ceres = {
      driver = "nutdrv_qx";
      port = "auto";
      description = "My UPS";
      summary = "subdriver=cypress\nvendorid=0665\nproductid=5161\npollinterval=10";
      shutdownOrder = 0;
    };

    # Service
    upsd = {
      enable = true;
      # Bind address
      listen = [ { address = "127.0.0.1"; } ];
    };

    # Users
    users.admin = {
      # UPS Monitor
      upsmon = "primary";
      # Password
      passwordFile = "/etc/ups/password";
    };

    # Maintenance
    users.maintenance = {
      instcmds = [ "ALL" ];
      actions = [ "set" "fsd" ];
      # Password
      passwordFile = "/etc/ups/password";
    };
    # Monitor
    upsmon = {

      # Connection
      monitor.main = {
        system = "ceres@localhost";
        powerValue = 1;
        user = "admin";
        passwordFile = "/etc/ups/password";
        type = "primary";
      };
    };

  };

  # NixOS Optimise
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # do garbage collection to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # NixOS System Version
  system.stateVersion = "23.11";
}