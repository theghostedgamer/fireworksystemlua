local ReplicatedStorage = game:GetService("ReplicatedStorage")
local countdownEvent = ReplicatedStorage:WaitForChild("CountdownEvent")

local timerLabel = script.Parent:WaitForChild("TimerLabel")

local function formatTime(seconds)
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	return string.format("%02d:%02d", m, s)
end

countdownEvent.OnClientEvent:Connect(function(timeLeft, finished)
	if finished then
		timerLabel.Text = "🎆 EVENT STARTED 🎆"
	else
		timerLabel.Text = formatTime(timeLeft)
	end
end)
