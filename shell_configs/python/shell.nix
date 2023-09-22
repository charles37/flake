{ pkgs ? import <nixpkgs> {} }:
let
  my-python-packages = ps: with ps; [
    pandas
    requests
    # other python packages
  ];
  my-python = pkgs.python3.withPackages my-python-packages;
in my-python.env
