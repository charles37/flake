{ pkgs, ... }:

let
  # Define the askpass.vim plugin derivation
  denops-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "denops.vim";
    version = "d7a15615f86830e9464c30f761a3911f619b38b3";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "d7a15615f86830e9464c30f761a3911f619b38b3";
      sha256 = "1rx42099zwf2k21gdipblwjr1ggilsb7fr601p1hvyhrz3xqms6b";
    };
  };
  askpass-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "askpass-vim";
    version = "2022-03-04"; # Version based on the commit date
    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo = "askpass.vim";
      rev = "aa977b0093424073bd4b4064a90440dec1e4f066"; # Commit hash from nix-prefetch-git
      sha256 = "0wckbc7pd8jpimj6gf896gvrgaf7f9nrpa5d729pl3yxagi3yw1p"; # SHA-256 hash from nix-prefetch-git
    };
    # Disable automatic shebang patching
    dontPatchShebangs = true;
    # Custom post-patch phase to handle the shebang patching
    postPatch = ''
      substituteInPlace denops/askpass/cli.ts \
        --replace "#!/usr/bin/env -S deno run --no-check --allow-env=ASKPASS_ADDRESS --allow-net=127.0.0.1" \
                  "#!${pkgs.deno}/bin/deno run --no-check --allow-env=ASKPASS_ADDRESS --allow-net=127.0.0.1"
    '';
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
      rose-pine
      denops-vim
      askpass-vim
    ];
  };

}

