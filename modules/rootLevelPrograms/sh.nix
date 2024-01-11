{ config, pkgs, ...}:
let
  myAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
in
{

  programs.bash = {
    shellAliases = myAliases;
  };

  programs.zsh = {
    histSize = 10000;
    histFile = "~/zsh/history";
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };

    shellAliases = myAliases;
  };
}
