vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)


-- Ben's custom remaps
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/flake/hosts/home.nix<CR>");

--function goto_last_non_netrw_buffer()
--  local bufnr = vim.fn.bufnr("#")
--  local bufname = vim.fn.bufname(bufnr)
--  print("Alternate buffer number: " .. bufnr)
--  print("Alternate buffer name: " .. bufname)
--  --is directory check 
--  print("Is directory: " .. vim.fn.isdirectory(bufname))
--  if vim.fn.isdirectory(bufname) == 0 then
--    vim.api.nvim_set_current_buf(bufnr)
--  else
--    for i = 1, vim.fn.bufnr("$") do
--      print("Buffer number: " .. i)
--      print("Buffer name: " .. vim.fn.bufname(i))
--      print("Buffer exists: " .. vim.fn.bufexists(i))
--      print("Buffer listed: " .. vim.fn.buflisted(i))
--      print("Is directory: " .. vim.fn.isdirectory(vim.fn.bufname(i)))
--      print("Is current buffer: " .. vim.fn.bufname(i) == bufname)
--      if vim.fn.bufexists(i) == 1 then
--        if vim.fn.buflisted(i) == 1 then 
--          if vim.fn.isdirectory(vim.fn.bufname(i)) == 0 then
--            -- check if its the same name as the current buffer 
--            if vim.fn.bufname(i) ~=  
--              print("Setting current buffer to: " .. i)
--              vim.api.nvim_set_current_buf(i)
--              break
--            end
--          end
--        end
--      end
--    end
--  end
--end
--
--vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd>lua goto_last_non_netrw_buffer()<CR>]], { noremap = true, silent = true })


