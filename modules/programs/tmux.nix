
{ pkgs, ... }:

let

in
{

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-Space
      bind C-Space send-prefix
      set status-bg default 
      set -g mouse on
      set -g @yank_selection_mouse 'clipboard'
      run-shell ${pkgs.tmuxPlugins.better-mouse-mode}/share/tmux-plugins/better-mouse-mode/better-mouse-mode.tmux
      run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/tmux-yank/yank.tmux
      run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator}/share/tmux-plugins/tmux-navigator/vim-tmux-navigator.tmux
    '';
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      #modern-tmux-theme
      tmuxPlugins.catppuccin
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];

  };

}



