{ lib, inputs, nixpkgs, home-manager, nixos-hardware, ...}:

let 
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
  nvim = inputs.nixvim;
in
{
  marin = lib.nixosSystem {
    inherit system; 
    specialArgs = {
        inherit system; inherit inputs;
    };
    modules = [ 
      ./configuration.nix 
      ./hardware-configuration.nix 
      ./greetd.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-extreme-gen2
      home-manager.nixosModules.home-manager {
        home-manager.extraSpecialArgs = {
            inherit inputs;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.ben = {
          imports = [ 
              (import ./home.nix) 
            ]; # ++ [(import ./marin/home.nix)]j
        };
      }
    ];
  };
}
