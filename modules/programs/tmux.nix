
{ pkgs, ... }:

let

in
{

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set status-bg default 
    '';
  };

}



