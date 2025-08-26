-- PlotRuntime.lua

local PlotRuntime = {}

-- Prefer a dedicated spawn part if you have one
local function findSpawnPart(plotRoot: Instance): BasePart?
	return plotRoot:FindFirstChild("PlotSpawn", true)
		or plotRoot:FindFirstChild("PlacingFloor", true)
		or plotRoot:FindFirstChild("EmptyChunk5", true)
end

-- Works for Folder or Model by cloning parts into a temp Model to use GetBoundingBox
local function getBoundsFromAny(plotRoot: Instance): (CFrame?, Vector3?)
	if plotRoot:IsA("Model") then
		return plotRoot:GetBoundingBox()
	end

	-- Folders (or anything else): clone BaseParts into a probe model
	local probe = Instance.new("Model")
	probe.Name = "__BoundsProbe"
	local hasParts = false

	for _, inst in ipairs(plotRoot:GetDescendants()) do
		if inst:IsA("BasePart") then
			hasParts = true
			local clone = inst:Clone()
			clone.Anchored = true
			clone.Parent = probe
		end
	end

	if not hasParts then
		probe:Destroy()
		return nil, nil
	end

	local cf, size = probe:GetBoundingBox()
	probe:Destroy()
	return cf, size
end

function PlotRuntime.TeleportPlayerToPlot(player: Player, plotRoot: Instance)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	-- 1) Use an explicit spawn part if present
	local spawnPart = findSpawnPart(plotRoot)
	if spawnPart then
		character:PivotTo(spawnPart.CFrame + Vector3.new(0, 6, 0))
		return
	end

	-- 2) Fallback to computed bounds (Folder or Model)
	local cf, size = getBoundsFromAny(plotRoot)
	if cf then
		local up = math.max(6, (size and size.Y or 6) * 0.5 + 3)
		character:PivotTo(cf + Vector3.new(0, up, 0))
	else
		warn("[PlotRuntime] Could not compute plot bounds for:", plotRoot:GetFullName())
	end
end

return PlotRuntime
