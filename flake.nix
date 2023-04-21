{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = { self, nixpkgs, home-manager }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        marin = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix 
            ./hardware-configuration.nix 
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ben = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };

      # Home Manager seperate module run nix build .#hmConfig.ben.activationPackage
      # then ./result/activate
#      hmConfig = {
#        ben = home-manager.lib.homeManagerConfiguration {
#          pkgs = nixpkgs.legacyPackages.${system};
#          modules = [
#            ./home.nix
#          ];
#        };
#      };
    };

}
