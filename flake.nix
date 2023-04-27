{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    
  
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib; 

      
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nixos-hardware system;
        }
     );

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
