{ pkgs, lib, config, ... }:

with lib;
let cfg =
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [

          #### Web ####
          ungoogled-chromium

          #### Mail #####
          mailspring

          #### Media ####
          vlc
          filebot

          #### Discord ####
          (pkgs.discord.override {
           # remove any overrides that you don't want
            withOpenASAR = true;
            withVencord = true;
          })

          #### Spotify ####
          #spotify-unwrapped
          spicetify-cli

          #### Telegram ####
          telegram-desktop

          #### Signal ####
          signal-desktop

          # SimpleX
          simplex-chat-desktop

          #### Matrix ####
          #fluffychat
          # #fractal-next

          #### VSCode ####
          vscode

          #### Networking ####
          winbox # Mikrotik manager
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
          yuzu-mainline # Nintendo Switch Emulator

          #### Minecraft ####
          prismlauncher

          #### Backup ####
          pika-backup
          borgbackup

          #### RGB ####
          ckb-next # Logitech keyboard and mouse RGB and macro control

          #### Ledger Crypto Hardware Wallet ####
          ledger-live-desktop

          #### Web Dev ####
          hugo # Static site generator

          #### RPI ####
          #rpi-imager

          # OBS Studio
          obs-studio

          # Davinci Resolve non liner video editing
          davinci-resolve

          #### Teamviewer ####
          #teamviewer

          #### Proton manager ####
          lutris

          #### Archive management ####
          #p7zip
          #zstd

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
          wineWowPackages.full # wine packages for running windows software/games
          # wineWowPackages.waylandFull # same as above for wayland
          #winetricks # wine manager
          #protontricks # steam game based wine manager
          protonup-qt
          zip
          lm_sensors

          # iOS
          libimobiledevice
          ifuse
          usbmuxd

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
    };
}
