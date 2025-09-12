return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = {"lua", "cpp", "c_sharp"},
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },
            autotag = {
                enable = true
            }
        }

        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.install").compilers = {"g++", "gcc"}
    end
}
