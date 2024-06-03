 { config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "max";
  home.homeDirectory = "/home/max";
 
 # User packages
  home.packages = with pkgs; [ ];
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
        "lux" = {
        hostname = "172.16.0.212";
        proxyJump = "100.96.163.55";
        user = "brock";
        identityFile = "/home/max/.ssh/max-a17";
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
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}