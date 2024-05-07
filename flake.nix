{
  description = "NixOS configuration for ion";

  # Select package channels
  inputs = {

    # Stable 23.05
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";

    # Stable 23.11
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # home-manager.url = "github:nix-community/home-manager/release-23.11";

    # Stable 24.05
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # home-manager.url = "github:nix-community/home-manager/release-24.05";

    # Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository (NUR)
    nur.url = github:nix-community/NUR;

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    
    # catppuccin
    catppuccin.url = "github:catppuccin/nix";
    # catppuccin.url = "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
  };

  outputs = inputs@{ nixpkgs, home-manager, nur, spicetify-nix, nix-flatpak, nix-vscode-extensions, catppuccin, ... } : {
    nixosConfigurations = {
      ion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit spicetify-nix nix-vscode-extensions;};
        modules = [
          ./configuration.nix
          ./nvidia-config.nix
          ./spicetify.nix # file where you configure spicetify
          ./hardware-configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          catppuccin.nixosModules.catppuccin

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Special Args
            home-manager.extraSpecialArgs = { inherit inputs nix-vscode-extensions; };

            # import the home.nix config file
            home-manager.users.max.imports = [
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}