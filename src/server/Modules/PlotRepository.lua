local M = {}

function M.GetPlotsFolder()
	return workspace:FindFirstChild("Plots")
end

function M.FindAvailablePlot()
	local plots = M.GetPlotsFolder()
	if not plots then return nil end
	for _, child in ipairs(plots:GetChildren()) do
		if child:IsA("Folder") and not child:GetAttribute("ClaimedBy") then
			return child
		end
	end
	return nil
end

return M
