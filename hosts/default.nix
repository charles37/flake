{ lib, inputs, nixpkgs, home-manager, nixos-hardware, ...}:

let 
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  marin = lib.nixosSystem {
    inherit system;
    modules = [ 
      ./configuration.nix 
      ./hardware-configuration.nix 
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-extreme-gen2
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.ben = {
          imports = [ (import ./home.nix) ]; # ++ [(import ./marin/home.nix)]j
        };
      }
    ];
  };
}
