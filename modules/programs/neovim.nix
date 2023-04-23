

{ pkgs, ... }:

{

  xdg.configFile.nvim = {  
    source = ./neovim;  
    recursive = true;  
  };



# NeoVim Config
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
      :luafile ./neovim/init.lua
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ]; 
  };  

}


