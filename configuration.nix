{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking

  # Define your hostname
  networking.hostName = "ceres";


  networking.interfaces.enp0s31f6.ipv4.addresses = [ {
    address = "10.0.0.2";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" "1.1.1.1" "9.9.9.9" "1.0.0.1" ];

  networking.interfaces.enp0s31f6.ipv6.addresses = [ {
    address = "2c0f:f4c0:1185:80c8::2";
    prefixLength = 64;
  } ];

  networking.defaultGateway6 = {
    address = "2c0f:f4c0:1185:80c8::1";
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
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Automatic scrubbing
  services.zfs.autoScrub.enable = true;


  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "feab067a";

  boot.zfs.extraPools = [ "ceres" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=32000000000" ];
 # # Ceres ZFS Mount
 # fileSystems."/mnt/ceres" =
 #   { device = "ceres/data";
 #     fsType = "zfs";
 #   };



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
  services.avahi.nssmdns = true;

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

  # Max
  # create account as standard user
  users.users.max.isNormalUser = true;
  # Name
  users.users.max.description = "Max";
  # Groups
  users.users.max.extraGroups = [ "wheel" "docker" "libvirtd" ];
  # Set user ID
  users.users.max.uid = 1000;
  # SSH public keys allowed to connect to the ssh server for user.
  users.users.max.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGaeHs7LX8API5+OH4brfqe31b8WMSIZnJ2PIdHsD65 max-pc-lux" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFi3dbVfeHJBHYqbx2UD1JkMofbWGdG9kWpu+QqesEN max-a17-lux" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBItfYtTxsE7xl6BgH3LtAoHnFureihclIkoIIyp0HSvdWXz8lyHAYTNm5fRqdb8Wl7ApDn4okCoOajsnyQmLQ/A= max@iphone" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC93Pzn2DxRZK3naV+TCa3FhSKUj+c30GXndAiNiJ0Ksb+KM/fKoxD4tndbF8fSI9e5Kgtneem/1y3ARJrQqiDM= max@ipad" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsnW2eSbP4juFbmLpaEc0E5zROGWoU6Qx3V9n73yl9M max-iphone"];
  # Specify user shell
  users.users.max.shell = "/home/max/.nix-profile/bin/zsh";
  # User packages
  home-manager.users.max = { pkgs, ... }: {
    home.packages = with pkgs; [
    ];
     # Config SSH
     programs.ssh = {
       enable = true;
       compression = true;

       # Server conigs
       matchBlocks = {
         # Hetzer storage
         "u334582.your-storagebox.de" = {
         hostname = "u334582.your-storagebox.de";
         user = "u334582";
         port = 23;
         identityFile = "/home/max/.ssh/hetzner-borg";
         };
         "github.com" = {
         hostname = "github.com";
         user = "git";
         identityFile = "/home/max/.ssh/max-git";
         };
         "lux" = {
         hostname = "172.16.0.212";
         proxyJump = "duck";
         user = "brock";
         identityFile = "/home/max/.ssh/max-a17-lux";
         };
         "duck" = {
         hostname = "100.96.163.55";
         user = "max";
         identityFile = "/home/max/.ssh/max-a17-lux";
         };
       };
     };
     programs.zsh.enable = true;
     programs.starship = {
       enable = true;
       # Configuration written to ~/.config/starship.toml
       settings = {
       # add_newline = false;

       # character = {
       #   success_symbol = "[➜](bold green)";
       #   error_symbol = "[➜](bold red)";
       # };

       # package.disabled = true;
       };
     };
     # Configure git
     programs.git = {
       enable = true;
       userName  = "Max van der Merwe";
       userEmail = "git@maxvdm.com";

       extraConfig = {
         # Sign all commits using ssh key
         commit.gpgsign = true;
         gpg.format = "ssh";
         gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
         user.signingkey = "~/.ssh/max-git.pub";
       };
     };
     home.stateVersion = "23.11";
     nixpkgs.config = import ./nixpkgs-config.nix;
    };

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
     docker-compose
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
   ];

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 3 * * 1,3,6      max    sh /mnt/ceres/media/yt-dlp.sh >> /dev/null"
      "0 2 * * 1,3,6      max    sh /home/max/docker-compose/backup-docker.sh >> /dev/null"
      "0 1 * * 1,3,6      max    sh /mnt/ceres/backups/photosync/photosync-backup.sh >> /dev/null"
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

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      #userland-proxy = false;
      ipv6 = true;
      ip6tables = true;
      fixed-cidr-v6 = "fd00:0::/64";
      #fixed-cidr-v6 = "2c0f:f4c0:1185:9dc1::/64";
      experimental = true;
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

  # NixOS System Version
  system.stateVersion = "23.11";
}


