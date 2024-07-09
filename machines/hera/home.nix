{ config, pkgs, nix-vscode-extensions, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "max";
  home.homeDirectory = "/home/max";

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

#  catppuccin = {
#    enable = true;
#    accent = "lavender";
#    flavor = "mocha";
#  };

 xdg.enable = true;

 xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
 };

 gtk = {
  enable = true;
  theme = {
    name = "catppuccin-mocha-mauve-standard+default";
    package =
      (pkgs.catppuccin-gtk.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "gtk";
          rev = "v1.0.3";
          fetchSubmodules = true;
          hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
        };

        postUnpack = "";
      }).override
        {
          accents = [ "mauve" ];
          variant = "mocha";
          #size = "compact";
        };
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "mauve";
    };
  };
  # cursorTheme = {
  #   name = "catppuccin-cursors";
  #   package = pkgs.catppuccin-cursors.mochaLavender;
  # };
  # gtk3.extraConfig = {
  #   Settings = ''
  #     gtk-application-prefer-dark-theme=1
  #   '';
  # };
  # gtk4.extraConfig = {
  #   Settings = ''
  #    gtk-application-prefer-dark-theme=1
  #   '';
  # };
    #  catppuccin = {
  #    enable = true;
  #    size = "standard";
  #    accent = "lavender";
  #    cursor = {
  #      enable = true;
  #      accent = "dark";
  #      flavor = "mocha";
  #    };
  #  gnomeShellTheme = true;
    #  icon = { 
    #   enable = true;
    #   accent = "lavender";
    #   flavor = "mocha";
    #  };
  };


  # Set Gnome options using dconf.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-weekday = true;
      clock-format = "24h";
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
      show-battery-percentage = "true";
      enable-hot-corners = "false";
      #gtk-theme = "Catppuccin-Mocha-Standard-Lavender-Dark";
      # font-name = "Red Hat Text 10";
      # monospace-font-name = "Red Hat Mono 10";
    };
    "org/gnome/desktop/peripherals/touchpad" = {  
      natural-scroll = "false";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "catppuccin-mocha-mauve-standard+default";
    };
    # "org/gnome/desktop/interface/cursor-theme" = {
    #   name = "catppuccin-mocha-lavender-cursors";
    # };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "suspend";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control>grave";
      command = "kgx";
      name = "Open Terminal";
    };
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = false;
      num-workspaces = 1;
      workspaces-only-on-primary = false;
    };
    "org/gnome/mutter" = {
      experimental-features = ["variable-refresh-rate" "scale-monitor-framebuffer"];
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "spotify.desktop"
        "tidal-hifi.desktop"
        "org.signal.Signal.desktop"
        "org.telegram.desktop.desktop"
        "vesktop.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"     
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "sp-tray@sp-tray.esenliyim.github.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "fullscreen-avoider@noobsai.github.com"
        "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
        "grand-theft-focus@zalckos.github.com"
        "gsconnect@andyholmes.github.io"
        "mediacontrols@cliffniff.github.com"
        "notification-timeout@chlumskyvaclav.gmail.com"
        "pano@elhan.io"
        "quick-settings-audio-panel@rayzeq.github.io"
        "tailscale@joaophi.github.com"
        "tiling-assistant@leleat-on-github"
        "trimmer@hedgie.tech"
        "quick-settings-avatar@d-go"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "azwallpaper@azwallpaper.gitlab.com"
        "weatherornot@somepaulo.github.io"
        "weekstartmodifier@saccuzm.gmail.com"
        "autohide-battery@sitnik.ru"
        "autohide-volume@unboiled.info"
        "supergfxctl-gex@asus-linux.org"
      ];
    };
    # Configure Extensions
    # Configure Bluetooth Quick Connect
    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      bluetooth-auto-power-on = true;
      bluetooth-auto-power-off = true;
      keep-menu-on-toggle = true;
      refresh-button-on = true;
      show-battery-value-on = true; 
      show-battery-icon-on = true;
    };
    "org/gnome/shell/extensions/mediacontrols" = {
      show-control-icons-seek-backward = false;
      show-control-icons-seek-forward = false;
      extension-position = "Right";
    };
    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      merge-panel = true;
      always-show-input-slider = true;
    };
    "org/gnome/shell/extensions/quick-settings-avatar" = {
      avatar-position = "0";
    };
    "org/gnome/shell/extensions/azwallpaper" = {
      slideshow-directory = "/home/max/Pictures/wallpapers/sj";
      slideshow-use-absolute-time-for-duration = true;
    };
    "org/gnome/shell/extensions/weatherornot" = {
      position = "clock-right";
    };
    "org/gnome/shell/extensions/weekstartmodifier" = {
      day = "1";
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system" "qemu+ssh://max@ceres/system"];
      uris = ["qemu:///system" "qemu+ssh://max@ceres/system"];
    };
    # "org/gnome/nautilus/icon-view" = {
    #   default-zoom-level = "standard";
    # };
    # "org/gnome/nautilus/preferences" = {
    #   default-folder-viewer = "icon-view";
    #   default-sort-order = "type";
    #   migrated-gtk-settings = true;
    #   search-filter-time-type = "last_modified";
    #   search-view = "list-view";
    # };
    # "org/gtk/gtk4/settings/file-chooser" = {
    #   date-format = "regular";
    #   location-mode = "path-bar";
    #   show-hidden = false;
    #   show-size-column = true;
    #   show-type-column = true;
    #   sidebar-width = 263;
    #   sort-column = "name";
    #   sort-directories-first = true;
    #   sort-order = "ascending";
    #   type-format = "category";
    #   # window-size = mkTuple [ 100 100 ];
    # };
    # "org/gtk/settings/file-chooser" = {
    #   window-position = mkTuple [ (-1) (-1) ];
    #   window-size = mkTuple [ 300 100 ];
    # };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #### Web ####
    #firefox
    ungoogled-chromium

    #### Discord ####
    vesktop

    #### Telegram ####
    telegram-desktop

    #### Signal ####
    #signal-desktop

    # SimpleX
    #simplex-chat-desktop

    #### Matrix ####
    fluffychat
    # #fractal-next

    #### Zoom video calling.
    zoom-us

    #### Media ####
    vlc
    filebot
    jellyfin-media-player
    delfin
    tidal-hifi

    # Deluge
    deluge

    #### Rclone ####
    rclone
    rclone-browser

    #### Backup ####
    pika-backup
    borgbackup

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

    #### Invoice
    invoice

    #### Archive management ####
    #p7zip
    #zstd

    #### Magic wormhole P2P file transfer ####
    magic-wormhole-rs
    warp # Gui

    #### Gaming ####
    adwsteamgtk
    protontricks # steam game based wine manager
    protonplus
    lutris

    #### Minecraft ####
    prismlauncher

    #### Emulation ####
    ryujinx

    #### System ####
    pciutils # lspci
    usbutils # lsusb
    #fio # IO Benchmark
    #gnumake # Compiler
    # gccgo13 # C Compiler
    xwayland # allow x.org programs to run under wayland
    starship # theme for zsh
    nerdfonts # fonts required for starship
    btrfs-progs # Utilities for the btrfs filesystem
    #wineWowPackages.full # wine packages for running windows software/games
    wineWowPackages.waylandFull # same as above for wayland
    zip
    lm_sensors
    thefuck
    pavucontrol
    ncdu
    pdfarranger

    #### Networking ####
    mtr # A network diagnostic tool
    iperf3 # tool to test network throughput with matching server/client
    dnsutils  # `dig` + `nslookup`
    dig
    winbox # Mikrotik client

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
    quickemu
    quickgui

    #### Neofetch ####
    neofetch

    #### Gnome ####
    gnome-extension-manager
    gnome-tweaks
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
    gnomeExtensions.media-controls
    gnomeExtensions.fuzzy-app-search
    gnomeExtensions.fullscreen-avoider
    gnomeExtensions.grand-theft-focus
    gnomeExtensions.gsconnect
    gnomeExtensions.supergfxctl-gex
    gnomeExtensions.autohide-battery
    gnomeExtensions.autohide-volume
  ];
  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "ceres" = {
      hostname = "ceres";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17";
      };
      "polaris" = {
      hostname = "polaris";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17";
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
      "duck" = {
      hostname = "duck.taila948e.ts.net";
      user = "Brock";
      identityFile = "/home/max/.ssh/max-a17";
      };
      "austin" = {
      hostname = "austin-poweredge-r710.tail97c97.ts.net";
      user = "austin";
      identityFile = "/home/max/.ssh/max-a17";
      };
      "lux" = {
      hostname = "172.16.0.212";
      proxyJump = "duck";
      user = "brock";
      identityFile = "/home/max/.ssh/max-a17";
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
    #enableAutosuggestions = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "command-not-found" "colored-man-pages" "colorize" "docker" "git" "screen" "starship" "vscode" ];
      #theme = "robbyrussell";
    };
  };
  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with nix-vscode-extensions.extensions.x86_64-linux.open-vsx; [
      jeanp413.open-remote-ssh
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      pkief.material-product-icons
      tailscale.vscode-tailscale
      ms-azuretools.vscode-docker
      jnoortheen.nix-ide
      eamodio.gitlens
      usernamehw.errorlens
      christian-kohler.path-intellisense
      tomoki1207.pdf
      mhutchie.git-graph
      #cschleiden.vscode-github-actions
      ziyasal.vscode-open-in-github
      ms-vscode.live-server
      mtxr.sqltools
      mtxr.sqltools-driver-sqlite
      mtxr.sqltools-driver-mysql
      mblode.pretty-formatter
    ];
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
