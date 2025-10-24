return {
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
        rust = { "string", "raw_string" },
        c_sharp = { "string" },
      },
    },
  },
}