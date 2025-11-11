return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
            theme = "hyper",
            config = {
                header = {
                    "███╗   ██╗ ██████╗ ██╗  ██╗██╗ █████╗     ██████╗ ███╗   ███╗",
                    "████╗  ██║██╔════╝ ██║  ██║██║██╔══██╗    ██╔══██╗████╗ ████║",
                    "██╔██╗ ██║██║  ███╗███████║██║███████║    ██████╔╝██╔████╔██║",
                    "██║╚██╗██║██║   ██║██╔══██║██║██╔══██║    ██╔═══╝ ██║╚██╔╝██║",
                    "██║ ╚████║╚██████╔╝██║  ██║██║██║  ██║    ██║     ██║ ╚═╝ ██║",
                    "╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝     ╚═╝",
                },
                center = {
                    {
                        icon = "  ",
                        desc = "Recently opened files",
                        action = "Telescope oldfiles",
                    },
                    {
                        icon = "  ",
                        desc = "Find file",
                        action = "Telescope find_files",
                    },
                    {
                        icon = "  ",
                        desc = "File explorer",
                        action = "Neotree toggle",
                    },
                    {
                        icon = "  ",
                        desc = "Find word",
                        action = "Telescope live_grep",
                    },
                    {
                        icon = "  ",
                        desc = "Open config",
                        action = "edit $MYVIMRC",
                    },
                },
            },
        })
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
