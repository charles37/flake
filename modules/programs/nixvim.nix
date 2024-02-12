{ pkgs, ...}: {
  programs.nixvim = {
    #enable = true;
    #colorschemes.rose-pine.enable = true;
    config = {
      options = {
        number = true;
        guicursor = "";
        nu = true;
        relativenumber = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
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
        nvim-cmp = {

          #formatting = {
          #  format = ''
          #    require("lspkind").cmp_format({
          #            mode="symbol",
          #            maxwidth = 50,
          #            ellipsis_char = "..."
          #    })
          #  '';
          #};

          autoEnableSources = true;
#local cmp_select = {behavior = cmp.SelectBehavior.Select}
#local cmp_mappings = lsp.defaults.cmp_mappings({
#  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
#  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
#  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
#  ["<C-Space>"] = cmp.mapping.complete(),
#})
          mappingPresets = ["insert"];
          preselect = "Item";

         


          #keymaps = {
          #    "<C-p>" = "select_prev_item";
          #    "<C-n>" = "select_next_item";
          #    "<C-y>" = "confirm";
          #    "<C-Space>" = "complete";
          #};

          #snippet = {
          #  expand.__raw = ''
          #    function(args)
          #      require("luasnip").lsp_expand(args.body)
          #    end
          #  '';
          #};
          enable = true;
          sources = [
            {name = "nvim_lsp";}
            #{
            #  name = "luasnip";
            #  option = {
            #    show_autosnippets = true;
            #  };
            #}
            {name = "path";}
            {name = "buffer";}
          ];
        };
        lsp = {
          enable = true;
#lsp.on_attach(function(client, bufnr)
#  local opts = {buffer = bufnr, remap = false}
#  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
#  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
#  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
#  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
#  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
#  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
#  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
#  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
#  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
#  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
#end)


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
            # TODO add purescript to nixvim lsp 
            #purescriptls = { 
            #  enable = true;
            #};
            elmls = {
              enable = true;
            };
            ccls = {
              enable = true;
            };
            # Add other servers as needed
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
  };
}


