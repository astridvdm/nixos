{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia-config.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Networking
  networking.hostName = "terra"; # Define your hostname.

  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" "1.0.0.1" "2620:fe::fe" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "10.0.0.3";
    prefixLength = 24;
  } ];
  networking.interfaces.eth0.ipv6.addresses = [ {
  address = "2c0f:f4c0:1185:8050:4ecc:6aff:fefc:2113";
  prefixLength = 64;
  } ];

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  fileSystems."/mnt/terra" =
    { device = "/dev/disk/by-uuid/1bca9e27-fc20-4ed1-b84e-3db5a6486019";
      fsType = "btrfs";
      options = [
        "acl"
        "autodefrag"
        "defaults"
        "nofail"
        "nossd"
        "compress=zstd:3"
        "noatime"
      ];
    };

  fileSystems."/mnt/max-12tb" =
    { device = "/dev/disk/by-uuid/5018a3ea-a629-4007-b04d-51df486b0a25";
      fsType = "btrfs";
      options = [
      "acl"
       "autodefrag"
       "defaults"
       "nofail"
       "nossd"
       "compress=zstd:5"
       "noatime"
      ];
    };


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

  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  users.users.max.isNormalUser = true;
   users.users.max.description = "Max";
   users.users.max.shell = "/home/max/.nix-profile/bin/zsh";
   users.users.max.extraGroups = [ "wheel" "docker" ];
   users.users.max.uid = 1000;
   users.users.max.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGaeHs7LX8API5+OH4brfqe31b8WMSIZnJ2PIdHsD65 max-pc-lux" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFi3dbVfeHJBHYqbx2UD1JkMofbWGdG9kWpu+QqesEN max-a17-lux" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBItfYtTxsE7xl6BgH3LtAoHnFureihclIkoIIyp0HSvdWXz8lyHAYTNm5fRqdb8Wl7ApDn4okCoOajsnyQmLQ/A= max@iphone" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC93Pzn2DxRZK3naV+TCa3FhSKUj+c30GXndAiNiJ0Ksb+KM/fKoxD4tndbF8fSI9e5Kgtneem/1y3ARJrQqiDM= max@ipad" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsnW2eSbP4juFbmLpaEc0E5zROGWoU6Qx3V9n73yl9M max-iphone"];
   home-manager.users.max = { pkgs, ... }: {
     home.packages = with pkgs; [
 ];
     programs.ssh = {
       enable = true;
       compression = true;
       matchBlocks = {
         "u334582.your-storagebox.de" = {
         hostname = "u334582.your-storagebox.de";
         user = "u334582";
         port = 23;
         identityFile = "/home/max/.ssh/hetzner-borg";
         };
         "gitea.svdm.me" = {
         hostname = "10.0.0.3";
         user = "git";
         port = 2222;
         identityFile = "/home/max/.ssh/max-git";
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
     home.stateVersion = "23.05";
     nixpkgs.config = import ./nixpkgs-config.nix;
    };

  nixpkgs.config.allowUnfree = true;

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
     #tailscale
     #iperf3
     #fio
     #smartmontools
   ];

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 3 * * 1,3,6      max    sh /mnt/terra/media/cron-sj.sh >> /dev/null"
      "0 2 * * 1,3,6      max    sh /home/max/terra-docker-compose/backup-terra-docker.sh >> /dev/null"
    ];
  };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable legacy macs for older sftp clients, ie VLC Photosync
  services.openssh.settings.Macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-256"
    "hmac-sha2-512"
    ];
  services.openssh.hostKeys = [
    { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
    { type = "ed25519"; bits = 256; path = "/etc/ssh/ssh_host_ed25519_key"; }
  ];


  # Docker
  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  };

  systemd.services.docker.after = ["mnt-terra.mount"];

  # Services
  programs.steam.enable = true;
  programs.nix-ld.enable = true;
  #services.tailscale.enable = true;

  # UPS Backup
  power.ups = {
    enable = true;
    mode = "standalone";
    ups = {
      ups = {
        driver = "nutdrv_qx";
        port = "auto";
        description = "My UPS";
        summary = "subdriver=cypress\nvendorid=0665\nproductid=5161\npollinterval=10";
      };
    };
  };

  environment.etc."nut/upsd.conf".source = ./ups/upsd.conf;
  environment.etc."nut/upsd.users".source = ./ups/upsd.users;
  environment.etc."nut/upsmon.conf".source = ./ups/upsmon.conf;

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

  # NixOS System Version
  system.stateVersion = "23.05";
}


