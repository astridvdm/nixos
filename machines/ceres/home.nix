{ config, pkgs, nix-vscode-extensions, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "astrid";
  home.homeDirectory = "/home/astrid";

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
  home.packages = with pkgs; [ ];
  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "lux" = {
      hostname = "172.16.0.212";
      proxyJump = "100.96.163.55";
      user = "brock";
      identityFile = "/home/astrid/.ssh/max-a17";
      };
      "u334582.your-storagebox.de" = {
      hostname = "u334582.your-storagebox.de";
      user = "u334582";
      port = 23;
      identityFile = "/home/astrid/.ssh/hetzner-borg";
      };
      "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "/home/astrid/.ssh/max-git";
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
#    catppuccin.enable = true;
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
