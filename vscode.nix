let
  system = builtins.currentSystem;
  extensions =
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "21cb883949be1e0694133058c04ba3667fe94c95";
    })).extensions.${system};
  extensionsList = with extensions.open-vsx; [
      jeanp413.open-remote-ssh
  ];
in ...