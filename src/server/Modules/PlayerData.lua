local M = {}

function M.addCash(plr, amount)
	amount = math.floor(tonumber(amount) or 0)
	local ls = plr:FindFirstChild("leaderstats")
	if not ls then return end
	local cash = ls:FindFirstChild("Cash")
	if cash then cash.Value += amount end
end

function M.addLevel(plr, amount)
	amount = math.floor(tonumber(amount) or 0)
	local ls = plr:FindFirstChild("leaderstats")
	if not ls then return end
	local level = ls:FindFirstChild("Level")
	if level then level.Value += amount end
end

return M
