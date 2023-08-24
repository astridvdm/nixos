{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      #(fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Networking
  networking.hostName = "ares"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

 fileSystems."/mnt/ares" =
   { device = "/dev/disk/by-uuid/ff2ccb7b-e932-4f33-9297-fb27f485c62c";
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
         "git.maxvdm.com" = {
          hostname = "10.0.0.3";
          user = "git";
          port = 2202;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     zip
     unzip
     rclone
     docker-compose
     tailscale
     borgbackup
     screen
     offlineimap
     imapsync
     git
     duf
#     dust
#     dua-cli
  ];

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 3 * * 1,3,6      max    sh /mnt/ares/photosync/photosync-backup.sh >> /dev/null"
      "0 2 * * 1,3,6      max    sh /home/max/ares-docker/backup.sh >> /dev/null"
    ];
  };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.openssh.settings.Macs = [
     "hmac-sha2-512-etm@openssh.com"
     "hmac-sha2-256-etm@openssh.com"
     "umac-128-etm@openssh.com"
     "hmac-sha2-512"
     "hmac-sha2-256"
     "umac-128@openssh.com"
    ];

  # Services
  services.tailscale.enable = true;
  programs.nix-ld.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  systemd.services.docker.after = ["mnt-ares.mount"];

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

  networking.firewall.checkReversePath = "loose";

  system.stateVersion = "23.05";
}
