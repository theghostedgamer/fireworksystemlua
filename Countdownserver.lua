-------------------------------------------------
-- SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local CountdownEvent = ReplicatedStorage:WaitForChild("CountdownEvent")
local AdminCommandEvent = ReplicatedStorage:WaitForChild("AdminCommandEvent")
local OriginsFolder = workspace:WaitForChild("FireworkOrigins")

-------------------------------------------------
-- SETTINGS
-------------------------------------------------
local EVENT_DURATION = 30 -- seconds
local eventRunning = false
local endTime = 0

-------------------------------------------------
-- ADMIN USERNAMES
-------------------------------------------------
local ADMINS = {
	["ghostdeadman"] = true, -- replace with your Roblox username
	-- Add more admins if needed
	-- ["AnotherAdmin"] = true
}

-------------------------------------------------
-- ROCKET FIREWORK FUNCTION
-------------------------------------------------
local function launchRocket(origin)
	local rocket = Instance.new("Part")
	rocket.Size = Vector3.new(0.3,1.5,0.3)
	rocket.Material = Enum.Material.Neon
	rocket.Color = Color3.fromHSV(math.random(),1,1)
	rocket.Anchored = true
	rocket.CanCollide = false
	rocket.Position = origin.Position
	rocket.Parent = workspace

	local targetPos = rocket.Position + Vector3.new(
		math.random(-10,10),
		math.random(50,70),
		math.random(-10,10)
	)

	local tween = TweenService:Create(
		rocket,
		TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Position = targetPos }
	)
	tween:Play()
	tween.Completed:Wait()

	local boom = Instance.new("Sound")
	boom.SoundId = "rbxassetid://138186576"
	boom.Volume = 1
	boom.Parent = rocket
	boom:Play()

	for i = 1,40 do
		local spark = Instance.new("Part")
		spark.Size = Vector3.new(0.3,0.3,0.3)
		spark.Shape = Enum.PartType.Ball
		spark.Material = Enum.Material.Neon
		spark.Color = rocket.Color
		spark.Anchored = true
		spark.CanCollide = false
		spark.Position = rocket.Position
		spark.Parent = workspace

		local dir = Vector3.new(
			math.random(-100,100),
			math.random(-100,100),
			math.random(-100,100)
		).Unit * math.random(20,35)

		local t = TweenService:Create(
			spark,
			TweenInfo.new(1.2),
			{ Position = spark.Position + dir, Transparency = 1 }
		)
		t:Play()
		Debris:AddItem(spark,1.3)
	end

	Debris:AddItem(rocket,2)
end

-------------------------------------------------
-- FIREWORK SEQUENCE
-------------------------------------------------
local function fireFireworks()
	for round = 1,6 do
		for _, origin in ipairs(OriginsFolder:GetChildren()) do
			if origin:IsA("BasePart") then
				task.spawn(function()
					launchRocket(origin)
				end)
			end
		end
		task.wait(0.6)
	end
end

-------------------------------------------------
-- START EVENT
-------------------------------------------------
local function startEvent()
	if eventRunning then
		warn("Event already running")
		return
	end

	print("🔥 EVENT STARTED")
	eventRunning = true
	endTime = os.time() + EVENT_DURATION

	while true do
		local timeLeft = math.max(0, endTime - os.time())
		CountdownEvent:FireAllClients(timeLeft)

		if timeLeft <= 0 then
			CountdownEvent:FireAllClients(0,true)
			fireFireworks()
			eventRunning = false
			break
		end

		task.wait(1)
	end
end

-------------------------------------------------
-- ADMIN COMMAND HANDLER
-------------------------------------------------
AdminCommandEvent.OnServerEvent:Connect(function(player, command)
	if not ADMINS[player.Name] then return end
	if command == "startevent" then
		print(player.Name .. " triggered startEvent")
		startEvent()
	end
end)

-------------------------------------------------
-- LATE JOINER SYNC
-------------------------------------------------
Players.PlayerAdded:Connect(function(player)
	if eventRunning then
		local timeLeft = math.max(0, endTime - os.time())
		CountdownEvent:FireClient(player, timeLeft)
	end
end)
