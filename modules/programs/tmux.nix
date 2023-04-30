
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
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      # modern-tmux-theme
      # tmuxPlugins.catppuccin
      # tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];

  };

}



