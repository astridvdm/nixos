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

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-lavender-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    gtk3.extraConfig = {
      gtk-theme-name = "Catppuccin-Mocha-Standard-lavender-Dark";
      gtk-application-prefer-dark-theme = "0";
      gtk-cursor-theme-name = "Bibata-Modern-Classic";
      gtk-icon-theme-name = "Papirus-Dark";
    };
    gtk4.extraConfig = {
      gtk-theme-name = "Catppuccin-Mocha-Standard-lavender-Dark";
      gtk-application-prefer-dark-theme = "0";
      gtk-cursor-theme-name = "Bibata-Modern-Classic";
      gtk-icon-theme-name = "Papirus-Dark";
    };
  };

  # Set Gnome options using dconf.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control>grave";
      command = "kgx";
      name = "open terminal";
    };
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #### Web ####
    firefox
    #ungoogled-chromium

    # Warp file transfer
    warp

    # warp terminal
    #warp-terminal

    #### Mail #####
    #mailspring
    #evolution

    # Meqdia
    kodi
    jellyfin-media-player
    # jellyfin

    #### Media ####
    vlc
    filebot

    # Deluge
    deluge

    #### Discord ####
    vesktop
    # (pkgs.discord.override {
    #  # remove any overrides that you don't want
    #   withOpenASAR = true;
    #   withVencord = true;
    # })

    #### Spotify ####
    #spotify-unwrapped
    #spicetify-cli
    #spotube

    #### Telegram ####
    telegram-desktop

    #### Signal ####
    signal-desktop

    # SimpleX
    #simplex-chat-desktop

    #### Matrix ####
    fluffychat
    # #fractal-next

    #### VSCode ####
    vscode

    #### Networking ####
    #winbox # Mikrotik manager
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
    ryujinx
    #yuzu-mainline

    #### Minecraft ####
    prismlauncher

    #steamtinkerlaunch

    #### Backup ####
    pika-backup
    borgbackup

    #### RGB ####
    #ckb-next

    #### Ledger Crypto Hardware Wallet ####
    ledger-live-desktop

    #### Web Dev ####
    hugo

    #### RPI ####
    #rpi-imager

    # Ebook Management
    calibre


    # OBS Studio
    obs-studio

    # Davinci Resolve non liner video editing
    davinci-resolve

    #### Teamviewer ####
    #teamviewer

    #### Invoice
    invoice

    #### Proton manager ####
    lutris

    #### Archive management ####
    #p7zip
    #zstd


    #### Zoom video calling.
    zoom-us

    #### Magic wormhole P2P file transfer ####
    magic-wormhole-rs

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
    #wineWowPackages.full # wine packages for running windows software/games
    wineWowPackages.waylandFull # same as above for wayland
    #winetricks # wine manager
    protontricks # steam game based wine manager
    protonup-qt
    zip
    lm_sensors
    thefuck
    pavucontrol
    adwsteamgtk

    # iOS
    libimobiledevice
    #libimobiledevice-utils
    ifuse
    usbmuxd

    #### Virtualization ####
    qemu
    OVMF
    libguestfs
    dmg2img
    virt-manager

    # Webcam control
    #nur.repos.c0deaddict.cameractrls

    #### Neofetch ####
    neofetch

    #### Gnome ####
    gnome-extension-manager
    gnome.gnome-tweaks
    #bibata-cursors

    #### Gnome Extensions ####
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.notification-timeout
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tiling-assistant
    gnomeExtensions.trimmer
    gnomeExtensions.user-avatar-in-quick-settings
    gnomeExtensions.weather-or-not
    gnomeExtensions.week-start-modifier
    gnomeExtensions.pano
    gnomeExtensions.wallpaper-slideshow
    gnomeExtensions.noannoyance
    gnomeExtensions.spotify-tray
    gnomeExtensions.fuzzy-app-search
    gnomeExtensions.fullscreen-avoider
    gnomeExtensions.no-titlebar-when-maximized
    gnomeExtensions.no-title-bar
    gnomeExtensions.forge
    gnomeExtensions.supergfxctl-gex
    gnomeExtensions.autohide-battery
    gnomeExtensions.autohide-volume
    gnomeExtensions.auto-power-profile
    gnomeExtensions.airpods-battery-status
  ];
  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "ceres" = {
      hostname = "10.0.0.2";
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
      identityFile = "/home/max/.ssh/max-git";
      };
    };
  };
  programs.zsh = {
    enable = true;
    history = {
      extended = true;
      size = 99999;
      share = true;
    };
    enableAutosuggestions = true;
    #autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "command-not-found" "colored-man-pages" "colorize" "docker" "git" "screen" "starship" "vscode" ];
      #theme = "robbyrussell";
    };
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
