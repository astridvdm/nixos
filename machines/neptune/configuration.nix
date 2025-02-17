{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # "vm.swappiness"
  boot.kernel.sysctl = { "vm.swappiness" = 100; };

  # Networking

  # Define your hostname
  networking.hostName = "neptune";

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Choose kernel package
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.interfaces.eno1.ipv4.addresses = [ {
    address = "10.0.0.3";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" "1.0.0.1" ];

  networking.interfaces.eno1.ipv6.addresses = [ {
    address = "2c0f:f4c0:1185:8174::3";
    prefixLength = 64;
  } ];

  networking.defaultGateway6 = {
    address = "2c0f:f4c0:1185:8174::1";
    interface = "eno1";
  };


  networking.interfaces.eno1.tempAddress = "disabled";

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";
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
     #podman-tui # status of containers in the terminal
     #podman-compose # start group of containers for dev
     docker-compose # start group of containers for dev
     ctop
     zsh
     bat
     nut
   ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    #setSocketVariable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    daemon.settings = {
      #userland-proxy = false;
      ipv6 = true;
      ip6tables = true;
      fixed-cidr-v6 = "fd00:0::/64";
      experimental = true;
      live-restore = false;
    };
  };

  # # Podman

  # # Enable common container config files in /etc/containers
  # virtualisation.containers.enable = true;
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

  # boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;

  Make sure docker starts after the storage array is mounted.
  systemd.services.docker.after = ["mnt-ceres.mount"];

  # SSHFS mount for Ceres's ZFS Array
  fileSystems."/ceres" =
   { device = "astrid@10.0.0.2:/ceres";
     fsType = "fuse.sshfs";
     options = [ "noauto" "x-systemd.automount" "_netdev" "user" "idmap=user" "follow_symlinks" "identityfile=/home/astrid/.ssh/astrid-a17" "allow_other" "default_permissions" "uid=1000" "gid=1000" ];
   };

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
    mode = "client";

    # Monitor
    upsmon = {

      # Connection
      monitor.main = {
        system = "ceres@10.0.0.2";
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
  system.stateVersion = "25.05";
}