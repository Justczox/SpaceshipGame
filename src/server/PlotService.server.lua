local Players = game:GetService("Players")
local PlotAllocator = require(script.Parent.Modules.PlotAllocator)
local PlotRuntime   = require(script.Parent.Modules.PlotRuntime)
local PlayerData    = require(script.Parent.Modules.PlayerData)
local PlotConfig    = require(script.Parent.Modules.PlotConfig)

print("[PlotService] Initialized")

Players.PlayerAdded:Connect(function(player)
	PlayerData.SetupLeaderstats(player)

	local plot = PlotAllocator.Allocate(player)
	if plot then
		print(("[PlotService] %s plot ready. Grid=%d, Chunks=%d, StartCash=%d")
			:format(player.Name, PlotConfig.GridTileSize, PlotConfig.ChunkTileCount, PlotConfig.StartingCash))
		PlotRuntime.TeleportPlayerToPlot(player, plot)
		player:SetAttribute("PlotPath", plot:GetFullName())
	else
		warn("[PlotService] No free plots!")
	end
end)

Players.PlayerRemoving:Connect(function(player)
	PlayerData.Save(player)
end)
