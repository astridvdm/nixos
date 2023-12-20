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

  # Choose kernel package
  boot.kernelPackages = pkgs.linuxPackages_zen;


  # Networking

  # Define your hostname
  networking.hostName = "ceres";
  networking.networkmanager.enable = true;


  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";


  # Users

  # Max
  # create account as standard user
  users.users.max.isNormalUser = true;
  # Name
  users.users.max.description = "Max";
  # Groups
  users.users.max.extraGroups = [ "wheel" "docker" ];
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
   ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
  };

  # Make sure docker starts after the storage array is mounted.
  #systemd.services.docker.after = ["mnt-terra.mount"];

  # Services

  # Run unpatched dynamic binaries on NixOS - Required for VSCode remotes
  programs.nix-ld.enable = true;

  # Enable LVFS firmware updating system.
  services.fwupd.enable = true;

  # Tailscale
  services.tailscale.enable = true;
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
  system.stateVersion = "23.11";
}


