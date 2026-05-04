-- Quick access to attached files
-- https://github.com/theprimeagen/harpoon
return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd" })

		vim.keymap.set("n", "<leader>hd", function()
			harpoon:list():remove()
		end, { desc = "[H]arpoon [R]emove" })

		vim.keymap.set("n", "<leader>hl", function()
			toggle_telescope(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })
	end,
}
