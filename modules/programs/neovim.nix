{ pkgs, nixpkgs, ... }:

let
  #nixpkgsUnstable = import (builtins.fetchTarball {
  #  # Descriptive name to make the store path easier to identify
  #  name = "nixos-unstable-2023-04-24";
  #  # Commit hash for nixos-unstable as of 2018-09-12
  #  url = "https://github.com/nixos/nixpkgs/archive/2362848adf8def2866fabbffc50462e929d7fffb.tar.gz";
  #  # Hash obtained using `nix-prefetch-url --unpack <url>`
  #  sha256 = "0wjr874z2y3hc69slaa7d9cw7rj47r1vmc1ml7dw512jld23pn3p";
  #}) {};


  my-lsp-zero-nvim = pkgs.vimUtils.buildVimPlugin {
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

  my-yesod-nvim = pkgs.vimUtils.buildVimPlugin {
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

  my-nvim-lspconfig = pkgs.vimUtils.buildVimPlugin{
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
      " === Colemak Mod-DH Remappings for Neovim/Vim ===

      " Remap movement keys for Colemak Mod-DH layout
      " In Colemak Mod-DH:
      " 'm' is where 'h' (left) is in QWERTY
      " 'n' is where 'j' (down) is in QWERTY
      " 'e' is where 'k' (up) is in QWERTY
      " 'i' is where 'l' (right) is in QWERTY
      noremap m h
      noremap n j
      noremap e k
      noremap i l

      " Apply the same movement remappings for other modes
      " Visual mode
      vnoremap m h
      vnoremap n j
      vnoremap e k
      vnoremap i l

      " Operator-pending mode
      onoremap m h
      onoremap n j
      onoremap e k
      onoremap i l

      " Remap 't' to enter insert mode, since 'i' is now used for moving right
      noremap t i


       let $RUST_SRC_PATH = '${pkgs.stdenv.mkDerivation {
        inherit (pkgs.rustc) src;
        inherit (pkgs.rustc.src) name;
        phases = ["unpackPhase" "installPhase"];
        installPhase = ''cp -r library $out'';
      }}'
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      playground
      cmp-nvim-lsp
      luasnip
      #my-nvim-lspconfig
      clangd_extensions-nvim
      my-yesod-nvim
      plenary-nvim
      purescript-vim
      nvim-cmp
      copilot-vim
      rose-pine
      rust-tools-nvim
      codi-vim
      idris2-vim
      hardtime-nvim
      vim-ccls
      #copilot-cmp
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
      #{
      #  plugin = rose-pine;
      #  type = "lua";
      #  config = builtins.readFile(./neovim/after/plugin/rose-pine.lua);
      #}
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
        plugin = lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/lsp.lua);
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/treesitter.lua);
      }
      {
        plugin = ghcid;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/ghcid.lua);
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/lspconfig.lua);
      }
      #{
      #  plugin = copilot-lua;
      #  type = "lua";
      #  config = builtins.readFile(./neovim/after/plugin/copilot.lua);
      #}
      #{
      #  plugin = nvim-cmp;
      #  type = "lua";
      #  config = builtins.readFile(./neovim/after/plugin/cmp.lua);
      #}

    ];
  };

}

