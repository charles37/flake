{ pkgs, ...}: {
  programs.nixvim = {
    #enable = true;
    #colorschemes.rose-pine.enable = true;
    clipboard.providers.wl-copy.enable = true;
    options = {
      number = true;
      guicursor = "";
      nu = true;
      relativenumber = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      smartindent = true;

      wrap = false;

      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 5;
      signcolumn = "no";
      

      updatetime = 50;

      colorcolumn = "";
    };  
    extraConfigLuaPre = ''
      vim.g.mapleader = ' '
'';
    colorschemes.rose-pine.enable = true;
    plugins = {
      treesitter = {
        enable = true;
        ensureInstalled = "all";
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = {
            action = "find_files";
            desc = "Telescope Find Files";
          };
          "<C-p>" = {
            action = "git_files";
            desc = "Telescope Git Files";
          };
          "<leader>ps" = {
          action = "live_grep";
            desc = "Telescope Grep String Input";
          };
        };
        keymapsSilent = true;
      };
      copilot-vim.enable = true;
      cmp-nvim-lsp.enable = true;
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      nvim-cmp = {
        autoEnableSources = true;
        mappingPresets = ["insert"];
        preselect = "Item";

        enable = true;
        sources = [
          {name = "nvim_lsp";}
          {
            name = "luasnip";
            option = {
              show_autosnippets = true;
            };
          }
          {name = "path";}
          {name = "buffer";}
        ];
      };
      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            "<leader>vd" = "open_float";
            "[d" = "goto_next";
            "]d" = "goto_prev";
          };
          lspBuf = {
            gd = "definition";
            K = "hover";
            "<leader>vws" = "workspace_symbol";
            "<leader>vca" = "code_action";
            "<leader>vrr" = "references";
            "<leader>vrn" = "rename";
            "<leader>f"   = "format";
          };
          silent = true;
        };
        servers = {
          eslint = {
            enable = true;
          };
          html = {
            enable = true;
          };
          nixd = {
            enable = true;
          };
          rust-analyzer = {
            enable = true;
            installCargo = true;
          installRustc = true;
          };
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          hls = {
            enable = true;
          };
          elmls = {
            enable = true;
          };
          ccls = {
            enable = true;
          };
          #lisp
          #lisp = {
          #  enable = true;
          #};
        };
      };
    };
    keymaps = [
      { mode = "n"; key = "<leader>pv"; action = ":Ex<CR>"; } # Opens NetRW file browser
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; } # Moves selected text one line down and reselects it
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; } # Moves selected text one line up and reselects it
      { mode = "n"; key = "J"; action = "mzJ`z"; } # Joins lines and returns cursor to original position
      { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; } # Scrolls down half a page and centers screen
      { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; } # Scrolls up half a page and centers screen
      { mode = "n"; key = "n"; action = "nzzzv"; } # Finds next search result, centers screen, and sets 'foldopen'
      { mode = "n"; key = "N"; action = "Nzzzv"; } # Finds previous search result, centers screen, and sets 'foldopen'
      { mode = "x"; key = "<leader>p"; action = "\"_dP"; } # Pastes over selected text without yanking it
      { mode = "n"; key = "<leader>y"; action = "\"+y"; } # Yanks text to system clipboard
      { mode = "v"; key = "<leader>y"; action = "\"+y"; } # Yanks text to system clipboard in visual mode
      { mode = "n"; key = "<leader>Y"; action = "\"+Y"; } # Yanks line to system clipboard in a way that mimics 'Y' behavior
      { mode = "n"; key = "<leader>d"; action = "\"_d"; } # Deletes text without yanking it
      { mode = "v"; key = "<leader>d"; action = "\"_d"; } # Deletes text without yanking it in visual mode
      { mode = "i"; key = "<C-c>"; action = "<Esc>"; } # Maps Ctrl-c to Escape in insert mode
      { mode = "n"; key = "Q"; action = "<nop>"; } # Disables Ex mode mapping to 'Q'
      { mode = "n"; key = "<C-f>"; action = "<cmd>silent !tmux neww tmux-sessionizer<CR>"; } # Opens tmux sessionizer
      { mode = "n"; key = "<leader>f"; action = "vim.lsp.buf.format"; } # Formats buffer using LSP
      { mode = "n"; key = "<C-k>"; action = "<cmd>cnext<CR>zz"; } # Goes to next item in quickfix list and centers screen
      { mode = "n"; key = "<C-j>"; action = "<cmd>cprev<CR>zz"; } # Goes to previous item in quickfix list and centers screen
      { mode = "n"; key = "<leader>k"; action = "<cmd>lnext<CR>zz"; } # Goes to next item in location list and centers screen
      { mode = "n"; key = "<leader>j"; action = "<cmd>lprev<CR>zz"; } # Goes to previous item in location list and centers screen
      { mode = "n"; key = "<leader>s"; action = ":<C-u>%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left><CR>"; } # Searches and replaces the word under cursor
      { mode = "n"; key = "<leader>x"; action = "<cmd>!chmod +x %<CR>"; options = { silent = true; }; } # Makes current file executable
      { mode = "n"; key = "<leader>mr"; action = "<cmd>CellularAutomaton make_it_rain<CR>"; } # Triggers custom command (example)
      { mode = "n"; key = "<leader><leader>"; action = "function() vim.cmd(\"so\") end"; } # sources the file 
      { mode = "n"; key = "<leader>vpp"; action = "<cmd>e ~/flake/hosts/home.nix<CR>"; } # Opens my home manager file 
      ];    
    extraConfigLua = ''
      vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)
      vim.opt.isfname:append("@-@");
      '';
      #vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
    };
}


