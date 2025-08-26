local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local FlightEvent = Remotes:WaitForChild("FlightEvent")

FlightEvent.OnClientEvent:Connect(function(msg)
	print("[FlightClient] Flight event:", msg)
end)
