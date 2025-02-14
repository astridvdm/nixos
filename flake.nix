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
    #  nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    #  home-manager.url = "github:nix-community/home-manager/release-24.05";

    # Stable 24.11
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # home-manager.url = "github:nix-community/home-manager/release-24.11";

    # Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Master
    #nixpkgs.url = "github:nixos/nixpkgs/master";
    #home-manager = {
    #  url = "github:nix-community/home-manager/master";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # catppuccin
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{ nixpkgs, home-manager, spicetify-nix, nix-vscode-extensions, nix-flatpak, catppuccin, nixos-hardware, ... } : {
    nixosConfigurations = {
      # TODO please change the hostname to your own
      hera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit nix-vscode-extensions;};
        modules = [
          ./machines/hera/configuration.nix
          ./machines/hera/hardware-configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          catppuccin.nixosModules.catppuccin
          #inputs.spicetify-nix.nixosModules.default
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
            home-manager.backupFileExtension = "backup";

            # import the home.nix config file
            home-manager.users.astrid.imports = [
              ./machines/hera/home.nix
              catppuccin.homeManagerModules.catppuccin
              #inputs.spicetify-nix.homeManagerModules.default
            ];
          }
        ];
      };
      ion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs nix-vscode-extensions;};
        modules = [
          ./machines/ion/configuration.nix
          ./machines/ion/hardware-configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          catppuccin.nixosModules.catppuccin
          #inputs.spicetify-nix.nixosModules.default

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Special Args
            home-manager.extraSpecialArgs = { inherit inputs nix-vscode-extensions; };
            home-manager.backupFileExtension = "backup";

            # import the home.nix config file
            home-manager.users.astrid.imports = [
              ./machines/ion/home.nix
              catppuccin.homeManagerModules.catppuccin
              #inputs.spicetify-nix.homeManagerModules.default
            ];
          }
        ];
      };
      ceres = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/ceres/configuration.nix
          ./machines/ceres/hardware-configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Special Args
            home-manager.backupFileExtension = "backup";

            # import the home.nix config file
            home-manager.users.astrid.imports = [
              ./machines/ceres/home.nix
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
      juno = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/juno/configuration.nix
          ./machines/juno/hardware-configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Special Args
            home-manager.backupFileExtension = "backup";

            # import the home.nix config file
            home-manager.users.astrid.imports = [
              ./machines/juno/home.nix
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
      polaris = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./machines/polaris/configuration.nix
          ./machines/polaris/hardware-configuration.nix
          nixos-hardware.nixosModules.raspberry-pi-4
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Special Args
            home-manager.backupFileExtension = "backup";

            # import the home.nix config file
            home-manager.users.astrid.imports = [
              ./machines/polaris/home.nix
            ];
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
