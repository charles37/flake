

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
      {
        plugin = packer-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/lua/ben/packer.lua);
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/telescope.lua);
      }
    ]; 
  };  

}


