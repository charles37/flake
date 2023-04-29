
{ pkgs, ... }:

let

in
{

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraTmuxConf = '' # used for less common options, intelligently combines if defined in multiple places.
      ...
    '';
  };

}



