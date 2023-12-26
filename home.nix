{ config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "max";
  home.homeDirectory = "/home/max";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
#   xresources.properties = {
#     "Xcursor.size" = 16;
#     "Xft.dpi" = 172;
#   };

  # basic configuration of git, please change to your own
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

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #### Web ####
    firefox
    ungoogled-chromium
    # protonvpn-gui

    #### Mail #####
    mailspring
    #evolution

    #### Media ####
    vlc
    filebot

    #### Discord ####
    #betterdiscordctl
    #betterdiscord-installer
    #discord
    (pkgs.discord.override {
    # remove any overrides that you don't want
    withOpenASAR = true;
    withVencord = true;
    })

    #### Spotify ####
    #spotify
    spicetify-cli

    #### Telegram ####
    telegram-desktop

    #### Signal ####
    unstable.signal-desktop

    #### Matrix ####
    #fluffychat
    # #fractal-next

    #### VSCode ####
    vscode

    #### Networking ####
    winbox # Mikrotik manager
    #trayscale # Tailscale gui manager
    mtr # A network diagnostic tool
    iperf3 # tool to test network throughput with matching server/client
    dnsutils  # `dig` + `nslookup`
    #ipcalc  # it is a calculator for the IPv4/v6 addresses
    dig

    #### Rclone ####
    rclone
    rclone-browser

    #### Emulation ####
    # ryujinx
    yuzu-mainline

    #### Minecraft ####
    prismlauncher

    #### Backup ####
    pika-backup
    borgbackup

    #### RGB ####
    ckb-next

    #### Ledger Crypto Hardware Wallet ####
    ledger-live-desktop

    #### Web Dev ####
    hugo

    #### RPI ####
    #rpi-imager

    #### Teamviewer ####
    #teamviewer

    #### Proton manager ####
    lutris

    #### Archive management ####
    #p7zip
    #zstd

    #### Magic wormhole P2P file transfer ####
    #magic-wormhole-rs

    #### Unifi Game Engine
    #unityhub

    #### System ####
    pciutils # lspci
    usbutils # lsusb
    #fio # IO Benchmark
    #gnumake # Compiler
    # gccgo13 # C Compiler
    xwayland # allow x.org programs to run under wayland
    starship # theme for zsh
    nerdfonts # fonts required for starship
    #protonup-ng # downloader for proton-ge runners
    # python3
    #docker-compose # declarative manager for docker OCI containers
    btrfs-progs # Utilities for the btrfs filesystem
    wineWowPackages.full # wine packages for running windows software/games
    # wineWowPackages.waylandFull # same as above for wayland
    #winetricks # wine manager
    #protontricks # steam game bases wine manager
    protonup-qt # Proton runtime manager
    zip
    lm_sensors
    supergfxctl
    asusctl
    gtop

    #### Virtualization ####
    qemu
    OVMF
    libguestfs
    dmg2img
    virt-manager

    #### Neofetch ####
    neofetch

    #### Gnome ####
    gnome-extension-manager
    gnome.gnome-tweaks
    catppuccin
    catppuccin-cursors
    bibata-cursors

  ];
  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "ceres" = {
      hostname = "10.0.0.242";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "ares" = {
      hostname = "10.0.0.2";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "terra" = {
      hostname = "10.0.0.3";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "hera" = {
      hostname = "10.0.0.21";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "orion" = {
      hostname = "100.112.75.88";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "lux" = {
      hostname = "172.16.0.212";
      proxyJump = "100.96.163.55";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "u334582.your-storagebox.de" = {
      hostname = "u334582.your-storagebox.de";
      user = "u334582";
      port = 23;
      identityFile = "/home/max/.ssh/hetzner-borg";
      };
      "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "/home/max/.ssh/max-git-yk";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
  };
  # starship - an customizable prompt for any shell
  programs.starship =
    let
      flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
    in
    {
      enable = true;
      settings = {
        # Other config here
        format = "$all"; # Remove this line to disable the default prompt format
        palette = "catppuccin_${flavour}";
      } // builtins.fromTOML (builtins.readFile
        (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "starship";
            rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f"; # Replace with the latest commit hash
            sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
          } + /palettes/${flavour}.toml));
    };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
