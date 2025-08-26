-- ProjectNavigator.server.lua
-- Very lightweight: only names, classes, and hierarchy.
-- Place in ServerScriptService, press Play.

local HttpService = game:GetService("HttpService")

local MAX_DEPTH = 5
local MAX_CHILDREN = 100
local TARGETS = {
	{ name = "ReplicatedStorage", ref = game:GetService("ReplicatedStorage") },
	{ name = "ServerScriptService", ref = game:GetService("ServerScriptService") },
	{ name = "ServerStorage", ref = game:GetService("ServerStorage") },
	{ name = "StarterPlayer", ref = game:GetService("StarterPlayer") },
	{ name = "Workspace", ref = workspace },
}

local function path(inst)
	local segs = {}
	while inst and inst ~= game do
		table.insert(segs,1,inst.Name)
		inst = inst.Parent
	end
	return table.concat(segs,".")
end

local function snapshot(inst,depth)
	local node = {Name=inst.Name,Class=inst.ClassName,Path=path(inst)}
	if depth>=MAX_DEPTH then
		node.ChildrenTruncated=true
		node.ChildCount=#inst:GetChildren()
		return node
	end
	node.Children = {}
	for i,child in ipairs(inst:GetChildren()) do
		if i>MAX_CHILDREN then
			node.ChildrenTruncated=true
			node.ChildCount=#inst:GetChildren()
			break
		end
		table.insert(node.Children, snapshot(child, depth+1))
	end
	return node
end

local out = {Targets={}, Info={GeneratedAt=os.time()}}
for _,t in ipairs(TARGETS) do
	if t.ref then
		out.Targets[t.name]=snapshot(t.ref,0)
	end
end

local json = HttpService:JSONEncode(out)
print("===== BEGIN_NAVIGATOR =====")
print(json)
print("===== END_NAVIGATOR =====")
