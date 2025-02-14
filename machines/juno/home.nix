{ config, pkgs, nix-vscode-extensions, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "astrid";
  home.homeDirectory = "/home/astrid";

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName  = "Astrid van der Merwe";
    userEmail = "git@astridvdm.com";

    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/astrid-git.pub";
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [ ];
  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "u334582.your-storagebox.de" = {
      hostname = "u334582.your-storagebox.de";
      user = "u334582";
      port = 23;
      identityFile = "/home/astrid/.ssh/hetzner-borg";
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

  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
