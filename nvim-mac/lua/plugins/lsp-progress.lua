return {
	"linrongbin16/lsp-progress.nvim",
	config = function()
		require("lsp-progress").setup({
			decay = 1200,
			series_format = function(title, message, percentage, done)
				local builder = {}
				local has_title = false
				local has_message = false
				if type(title) == "string" and string.len(title) > 0 then
					table.insert(builder, title)
					has_title = true
				end
				if type(message) == "string" and string.len(message) > 0 then
					table.insert(builder, message)
					has_message = true
				end
				-- Always show percentage when provided. Some language servers only send percentage
				-- without a title/message (e.g. pure "indexing" progress). Show it even if
				-- title/message are empty so the user sees indexing percent.
				if percentage then
					-- if we have a title/message, keep the parentheses style; otherwise show raw
					-- percent so it's more compact.
					if has_title or has_message then
						table.insert(builder, string.format("(%.0f%%)", percentage))
					else
						table.insert(builder, string.format("%.0f%%", percentage))
					end
				end
				return { msg = table.concat(builder, " "), done = done }
			end,
			client_format = function(client_name, spinner, series_messages)
				if #series_messages == 0 then
					return nil
				end
				local builder = {}
				local done = true
				for _, series in ipairs(series_messages) do
					if not series.done then
						done = false
					end
					table.insert(builder, series.msg)
				end
				if done then
					spinner = "✓" -- replace your check mark
				end
				return "[" .. client_name .. "] " .. spinner .. " " .. table.concat(builder, ", ")
			end,
		})
	end,
}
