{ pkgs, ... }:

let
  #nixpkgsUnstable = import (builtins.fetchTarball {
  #  # Descriptive name to make the store path easier to identify
  #  name = "nixos-unstable-2023-04-24";
  #  # Commit hash for nixos-unstable as of 2018-09-12
  #  url = "https://github.com/nixos/nixpkgs/archive/2362848adf8def2866fabbffc50462e929d7fffb.tar.gz";
  #  # Hash obtained using `nix-prefetch-url --unpack <url>`
  #  sha256 = "0wjr874z2y3hc69slaa7d9cw7rj47r1vmc1ml7dw512jld23pn3p";
  #}) {};

  my-lsp-zero-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lsp-zero.nvim";
    version = "2023-04-18";
    src = pkgs.fetchFromGitHub {
      owner = "VonHeikemen";
      repo = "lsp-zero.nvim";
      rev = "8f7436b5df998515d9e15073b16f1bd142c406f9";
      sha256 = "06jdi7qg9nhqjb2isldndjkbn4z3jminhn7rp036bc2rp3r6l3iw";
    };
    meta.homepage = "https://github.com/VonHeikemen/lsp-zero.nvim/";
  };

  my-yesod-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "yesod.vim";
    version = "2022-11-16";
    src = pkgs.fetchFromGitHub {
      owner = "alx741";
      repo = "yesod.vim";
      rev = "f165031e8875585400046b3171d697374a183699";
      sha256 = "0h8yvf314kjypxslwsx6yi97pld9bw56mx2f9jngrpapcxnyj346";
    };
    meta.homepage = "https://github.com/alx741/yesod.vim";
  };

  my-nvim-lspconfig = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-lspconfig";
    version = "2023-04-16";
    src = pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "eddaef928c1e1dd79a96f5db45f2fd7f2efe7ea0";
      sha256 = "1gpkmywjlyyx8zmvyxqsrrfyrxsvs42gd442k05nhfv75z077dcf";
    };
    meta.homepage = "https://github.com/neovim/nvim-lspconfig/";
  };

in
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
      :luafile ./neovim/after/plugin/colors.lua
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      rose-pine
      playground
      cmp-nvim-lsp
      luasnip
      my-nvim-lspconfig
      my-yesod-nvim
      haskell-tools-nvim
      plenary-nvim
      purescript-vim
      copilot-cmp
     # (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.javascript p.nix p.haskell p.lua ]))
     # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
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
      {
        plugin = rose-pine;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/rose-pine.lua);
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/treesitter.lua);
      }
      {
        plugin = harpoon;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/harpoon.lua);
      }
      {
        plugin = undotree;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/undotree.lua);
      }
      {
        plugin = vim-fugitive;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/fugitive.lua);
      }
      {
        plugin = my-lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/lsp.lua);
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/treesitter.lua);
      }
      {
        plugin = copilot-lua;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/copilot.lua);
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/cmp.lua);
      }

    ];
  };

}

