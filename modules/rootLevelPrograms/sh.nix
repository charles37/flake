{ config, pkgs, ...}:
let
  myAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
in
{

  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    histSize = 10000;
    histFile = "${config.xdg.dataHome}/zsh/history";
    enable = true;
    enableCompletion = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    shellAliases = myAliases;
  };
}
