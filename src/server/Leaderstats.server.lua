-- Simple Cash/Level leaderstats with saving
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local DS = DataStoreService:GetDataStore("PlayerData_v1")

local DEFAULTS = { Cash = 100, Level = 1 }

local function load(plr)
	local key = "p_" .. plr.UserId
	local data
	pcall(function() data = DS:GetAsync(key) end)
	data = typeof(data) == "table" and data or {}
	return {
		Cash = tonumber(data.Cash) or DEFAULTS.Cash,
		Level = tonumber(data.Level) or DEFAULTS.Level,
	}
end

local function setupLeaderstats(plr)
	local d = load(plr)

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = d.Cash
	cash.Parent = ls

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = d.Level
	level.Parent = ls
end

local function save(plr)
	local key = "p_" .. plr.UserId
	local ls = plr:FindFirstChild("leaderstats")
	local cash = ls and ls:FindFirstChild("Cash")
	local level = ls and ls:FindFirstChild("Level")
	local payload = {
		Cash = cash and cash.Value or DEFAULTS.Cash,
		Level = level and level.Value or DEFAULTS.Level,
	}
	for i = 1, 3 do
		local ok, err = pcall(function() DS:SetAsync(key, payload) end)
		if ok then return true end
		task.wait(2)
	end
	return false
end

Players.PlayerAdded:Connect(setupLeaderstats)
Players.PlayerRemoving:Connect(save)

game:BindToClose(function()
	for _, plr in ipairs(Players:GetPlayers()) do
		save(plr)
	end
end)

-- Optional auto-save
task.spawn(function()
	while task.wait(120) do
		for _, plr in ipairs(Players:GetPlayers()) do
			save(plr)
		end
	end
end)
