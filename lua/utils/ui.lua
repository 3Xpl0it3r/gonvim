local M = {}

function M.pick_one_async(items, prompt, label_fn, cb)
	if vim.ui then
		return vim.ui.select(items, {
			prompt = prompt,
			format_item = label_fn,
		}, cb)
	end
	local result = M.pick_one(items, prompt, label_fn)
	cb(result)
end

function M.pick_one(items, prompt, label_fn)
	local choices = { prompt }
	for i, item in ipairs(items) do
		table.insert(choices, string.format("%d: %s", i, label_fn(item)))
	end
	local choice = vim.fn.inputlist(choices)
	if choice < 1 or choice > #items then
		return nil
	end
	return items[choice]
end

function M.multi_select(items, prompt)
	for i = 1, 10, 1 do
		coroutine.resume(coroutine.create(function()
			local coro = assert(coroutine.running())
			vim.schedule(function()
				vim.ui.select({ "foo", "bar" }, {
					format_item = function(item)
						return item
					end,
				}, function(choice)
					coroutine.resume(coro, choice)
				end)
			end)
		end))
		print("got : " .. tostring(i) .. "    " .. result)
	end
end

return M
