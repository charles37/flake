{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {self,flake-utils, nixpkgs}: 
  flake-utils.lib.eachDefaultSystem 
    (system:
      let
        overlays = [ (import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in 
      with pkgs;
      {
        devShells.default = mkShell {
          buiildInputs = [nodejs_20];
        };

     }
    );
}
