{
  description = "NixOS configuration";

  # Select package channels
  inputs = {

    # Stable 23.05
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";

    # Stable 23.11
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # home-manager.url = "github:nix-community/home-manager/release-23.11";

    # Stable 24.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    # Unstable
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #home-manager.url = "github:nix-community/home-manager/master";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # catppuccin
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ nixpkgs, home-manager, spicetify-nix, nix-vscode-extensions, nix-flatpak, nixos-hardware, catppuccin, ... } : {
    nixosConfigurations = {
      # TODO please change the hostname to your own
      hera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit spicetify-nix nix-vscode-extensions;};
        modules = [
          ./machines/hera/configuration.nix
          ./machines/hera/hardware-configuration.nix
          ./machines/hera/spicetify.nix # file where you configure spicetify
          nix-flatpak.nixosModules.nix-flatpak
          catppuccin.nixosModules.catppuccin
          nixos-hardware.nixosModules.asus-fa507rm

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
              ./machines/hera/home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
      ion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit spicetify-nix nix-vscode-extensions;};
        modules = [
          ./machines/ion/configuration.nix
          ./machines/ion/hardware-configuration.nix
          ./machines/ion/nvidia-config.nix
          ./machines/ion/spicetify.nix # file where you configure spicetify
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
              ./machines/ion/home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
