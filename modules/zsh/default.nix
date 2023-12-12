{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };

    config = mkIf cfg.enable {
    	home.packages = [
	    pkgs.zsh
	];

    programs.zsh = {
      enable = true;
      history = {
        extended = true;
        size = 99999;
        share = true;
      };
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" "command-not-found" "colored-man-pages" "colorize" "docker" "git" "screen" "starship" "vscode" ];
        #theme = "robbyrussell";
      };
    };
  };
}
