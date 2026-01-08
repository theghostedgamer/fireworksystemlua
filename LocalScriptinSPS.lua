local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local AdminCommandEvent = ReplicatedStorage:WaitForChild("AdminCommandEvent")
local ADMINS = {
	["ghostdeadman"] = true
}

player.Chatted:Connect(function(message)
	if ADMINS[player.Name] and message:lower() == "/startevent" then
		AdminCommandEvent:FireServer("startevent")
	end
end)
