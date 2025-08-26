local Repo = require(script.Parent.PlotRepository)

local M = {}

function M.Allocate(player)
	local plot = Repo.FindAvailablePlot()
	if not plot then return nil end
	plot:SetAttribute("ClaimedBy", player.UserId)
	return plot
end

function M.Release(plot)
	if plot then plot:SetAttribute("ClaimedBy", nil) end
end

return M
