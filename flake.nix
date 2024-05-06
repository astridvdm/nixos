{
  description = "NixOS configuration for hera";

  # Select package channels
  inputs = {

    # Stable 23.05
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";

    # Stable 23.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";

    # Unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager/master";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Repository (NUR)
    #nur.url = github:nix-community/NUR;

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
  };

  outputs = inputs@{ nixpkgs, home-manager, spicetify-nix, nix-flatpak, nixos-hardware, ... } : {
    nixosConfigurations = {
      # TODO please change the hostname to your own
      hera = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit spicetify-nix;};
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          #./nvidia-config.nix
          ./spicetify.nix # file where you configure spicetify
          nix-flatpak.nixosModules.nix-flatpak
          nixos-hardware.nixosModules.asus-fa507rm
          # nur.nixosModules.nur
          # This adds a nur configuration option.
          # Use `config.nur` for packages like this:
            # ({ config, ... }: {
            #   environment.systemPackages = [ config.nur.repos.c0deaddict.cameractrls ];
            # })


          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            # allow home-manager to follow allow unfree
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # import the home.nix config file
            home-manager.users.max.imports = [
              ./home.nix
              #inputs.nur.hmModules.nur
            ];


            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
