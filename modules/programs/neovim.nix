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

  lsp-zero-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
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
        plugin = lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile(./neovim/after/plugin/lsp.lua);
      }
      #{
      #  plugin = nvim-treesitter;
      #  type = "lua";
      #  config = builtins.readFile(./neovim/after/plugin/treesitter.lua);
      #}
    ];
  };

}

## Define the askpass.vim plugin derivation
#  denops-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
#    pname = "denops.vim";
#    version = "d7a15615f86830e9464c30f761a3911f619b38b3";
#    src = pkgs.fetchFromGitHub {
#      owner = "vim-denops";
#      repo = "denops.vim";
#      rev = "d7a15615f86830e9464c30f761a3911f619b38b3";
#      sha256 = "1rx42099zwf2k21gdipblwjr1ggilsb7fr601p1hvyhrz3xqms6b";
#    };
#  };
#  askpass-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
#    pname = "askpass-vim";
#    version = "2022-03-04"; # Version based on the commit date
#    src = pkgs.fetchFromGitHub {
#      owner = "lambdalisue";
#      repo = "askpass.vim";
#      rev = "aa977b0093424073bd4b4064a90440dec1e4f066"; # Commit hash from nix-prefetch-git
#      sha256 = "0wckbc7pd8jpimj6gf896gvrgaf7f9nrpa5d729pl3yxagi3yw1p"; # SHA-256 hash from nix-prefetch-git
#    };
#    # Disable automatic shebang patching
#    dontPatchShebangs = true;
#    # Custom post-patch phase to handle the shebang patching
#    postPatch = ''
#      substituteInPlace denops/askpass/cli.ts \
#        --replace "#!/usr/bin/env -S deno run --no-check --allow-env=ASKPASS_ADDRESS --allow-net=127.0.0.1" \
#                  "#!${pkgs.deno}/bin/deno run --no-check --allow-env=ASKPASS_ADDRESS --allow-net=127.0.0.1"
#    '';
#  };


