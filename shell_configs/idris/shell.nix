{ pkgs ? import <nixpkgs> {} }:
let
  my-idris-packages = ps: with ps; [
    # idris2 packages 
    idris2Lsp

  ];
  my-idris = pkgs.idris2.withPackages my-idris-packages;
in my-idris.env

