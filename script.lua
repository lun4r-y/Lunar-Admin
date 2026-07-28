-- Join my Discord :3 https://discord.gg/ydNKRbFmUd
-- Created by @LunarRbxZ
-- Fixed and Enhanced Admin Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local client = Players.LocalPlayer
local Mouse = client:GetMouse()
local prefix = "!"
local waypoints = {}
local tracerLines = {}

-- Wait for character to load
local char = client.Character or client.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart", 10)
local hum = char:WaitForChild("Humanoid", 10)

if not hrp or not hum then
	StarterGui:SetCore("SendNotification", {Title = "Lunar Error", Text = "Character not loaded. Re-execute after spawn.", Duration = 10})
	return
end

client.Chatted:Connect(processCmd)
-- =============================================================
-- MOBILE UI AUTO-RESIZE - STRICT VERSION
-- =============================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local client = Players.LocalPlayer

-- CONFIG: Adjust this if mobile UI is still too big/small
local MOBILE_SCALE = 0.55

-- EXACT list of your admin UI names - add more if you create new ones
local LUNAR_UI_NAMES = {
    ["LunarGui"] = true,
    ["LunarNotifs"] = true,
    ["LunarWatermark"] = true,
    ["LunarSplash"] = true,
    ["LunarHubGUI"] = true,
    ["AimbotPanel"] = true,
    ["FlySystemPanel"] = true,
    ["SpeedPanel"] = true,
    ["JoinLogsPanel"] = true,
    ["logsPanel"] = true,
    ["stopwatchPanel"] = true,
    ["CmdBarGui"] = true,
    ["SpeedPanel"] = true,
    ["LunarTouchFling"] = true,
    ["LunarCrosshairCMD"] = true,
    ["SunGlare"] = true,
    ["SpectateGui"] = true,
}

-- Detect mobile device
local function isMobile()
    local touchEnabled = UserInputService.TouchEnabled
    local keyboardEnabled = UserInputService.KeyboardEnabled
    local mouseEnabled = UserInputService.MouseEnabled
    
    if touchEnabled and (not keyboardEnabled or not mouseEnabled) then
        return true
    end
    
    local screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if screenSize then
        if math.min(screenSize.X, screenSize.Y) < 600 then
            return true
        end
    end
    
    return false
end

-- Apply UIScale only to whitelisted Lunar UIs
local function applyMobileScale(screenGui)
    if not screenGui or not screenGui:IsA("ScreenGui") then return end
    if not LUNAR_UI_NAMES[screenGui.Name] then return end
    if screenGui:FindFirstChild("MobileUIScale") then return end
    
    local scale = Instance.new("UIScale")
    scale.Name = "MobileUIScale"
    scale.Scale = MOBILE_SCALE
    scale.Parent = screenGui
end

-- Main setup
local function setupMobileResize()
    if not isMobile() then return end -- PC stays untouched completely
    
    local playerGui = client:WaitForChild("PlayerGui")
    
    -- Scale existing Lunar UIs only
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            applyMobileScale(gui)
        end
    end
    
    -- Auto-scale new Lunar UIs as they're created
    playerGui.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") then
            task.wait()
            applyMobileScale(child)
        end
    end)
end

-- Run immediately
setupMobileResize()

-- Re-run on respawn (some executors reload)
client.CharacterAdded:Connect(function()
    task.wait(1)
    setupMobileResize()
end)

-- Export for manual use if needed
_G.ApplyMobileUIScale = applyMobileScale
--------------------------------------------------------------
---------- loading screen ------------------------------------
--------------------------------------------------------------
local function createInstantSplash(imageId)
	imageId = imageId or "rbxassetid://115041688502921"

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local ContentProvider = game:GetService("ContentProvider")
	local Lighting = game:GetService("Lighting")
	local RunService = game:GetService("RunService")

	local player = Players.LocalPlayer
	if not player then
		return
	end

	-- PRELOAD IMAGE
	local preload = Instance.new("ImageLabel")
	preload.Image = imageId
	ContentProvider:PreloadAsync({ preload })
	preload:Destroy()

	-- REMOVE OLD
	local old = player.PlayerGui:FindFirstChild("LunarSplash")
	if old then
		old:Destroy()
	end

	-- GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "LunarSplash"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.Parent = gui

	-- animated gradient
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
	})
	gradient.Rotation = 25
	gradient.Parent = bg

	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting

	local vignette = Instance.new("ImageLabel")
	vignette.Size = UDim2.fromScale(1.2, 1.2)
	vignette.Position = UDim2.fromScale(-0.1, -0.1)
	vignette.BackgroundTransparency = 1
	vignette.Image = "rbxassetid://4576475446"
	vignette.ImageTransparency = 1
	vignette.ScaleType = Enum.ScaleType.Stretch
	vignette.ZIndex = 2
	vignette.Parent = gui

	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.fromOffset(420, 420)
	frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 28)
	corner.Parent = frame

	-- glass stroke
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = frame

	-- glow
	local glow = Instance.new("ImageLabel")
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.Position = UDim2.fromScale(0.5, 0.5)
	glow.Size = UDim2.fromScale(1.8, 1.8)
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://5028857084"
	glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
	glow.ImageTransparency = 1
	glow.ZIndex = 0
	glow.Parent = frame

	local image = Instance.new("ImageLabel")
	image.AnchorPoint = Vector2.new(0.5, 0.5)
	image.Position = UDim2.fromScale(0.5, 0.5)
	image.Size = UDim2.fromScale(0.78, 0.78)
	image.BackgroundTransparency = 1
	image.Image = imageId
	image.ImageTransparency = 1
	image.ScaleType = Enum.ScaleType.Fit
	image.ZIndex = 3
	image.Parent = frame

local shineHolder = Instance.new("Frame")
shineHolder.Size = UDim2.fromScale(1, 1)
shineHolder.BackgroundTransparency = 1
shineHolder.ClipsDescendants = true
shineHolder.ZIndex = 4
shineHolder.Parent = frame

local shine = Instance.new("ImageLabel")
shine.AnchorPoint = Vector2.new(0.5, 0.5)
shine.Position = UDim2.fromScale(-0.6, 0.5)
shine.Size = UDim2.fromScale(0.45, 1.8)
shine.BackgroundTransparency = 1
shine.Image = "rbxassetid://8992230677"
shine.ImageTransparency = 0.92
shine.ImageColor3 = Color3.fromRGB(255,255,255)
shine.Rotation = 18
shine.ScaleType = Enum.ScaleType.Stretch
shine.ZIndex = 4
shine.Parent = shineHolder

	local scale = Instance.new("UIScale")
	scale.Scale = 0.45
	scale.Parent = frame

	local text = Instance.new("TextLabel")
	text.AnchorPoint = Vector2.new(0.5, 0)
	text.Position = UDim2.fromScale(0.5, 0.87)
	text.Size = UDim2.fromOffset(300, 40)
	text.BackgroundTransparency = 1
	text.Text = "LOADING"
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextTransparency = 1
	text.Font = Enum.Font.Code
	text.TextScaled = true
	text.ZIndex = 5
	text.Parent = frame

	local attachment = Instance.new("Attachment")
	attachment.Parent = frame

	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxassetid://243660364"
	particles.Rate = 0
	particles.Lifetime = NumberRange.new(1, 1.5)
	particles.Speed = NumberRange.new(18, 26)
	particles.SpreadAngle = Vector2.new(360, 360)
	particles.LightEmission = 1
	particles.Drag = 2
	particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 0)
	})
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	particles.Parent = attachment

	TweenService:Create(bg, TweenInfo.new(0.4), {
		BackgroundTransparency = 0.15
	}):Play()

	TweenService:Create(blur, TweenInfo.new(0.45), {
		Size = 36
	}):Play()

	TweenService:Create(vignette, TweenInfo.new(0.5), {
		ImageTransparency = 0.35
	}):Play()

	TweenService:Create(scale, TweenInfo.new(
		0.7,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	), {
		Scale = 1
	}):Play()

	TweenService:Create(image, TweenInfo.new(0.45), {
		ImageTransparency = 0
	}):Play()

	TweenService:Create(text, TweenInfo.new(0.45), {
		TextTransparency = 0
	}):Play()

	TweenService:Create(glow, TweenInfo.new(0.5), {
		ImageTransparency = 0.45
	}):Play()

	task.wait(0.2)

	particles:Emit(40)

task.spawn(function()
	while gui.Parent do
		shine.Position = UDim2.fromScale(-0.6, 0.5)

		local tween = TweenService:Create(
			shine,
			TweenInfo.new(
				1.8,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Position = UDim2.fromScale(1.6, 0.5)
			}
		)

		tween:Play()

		task.wait(3.5)
	end
end)

	local connection
	local start = tick()

	connection = RunService.RenderStepped:Connect(function()
		if not frame.Parent then
			connection:Disconnect()
			return
		end

		local t = tick() - start

		frame.Position = UDim2.fromScale(
			0.5,
			0.5 + math.sin(t * 1.5) * 0.008
		)

		glow.Rotation += 0.08
	end)

	task.wait(3)

	local outro = TweenInfo.new(
		0.45,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	)

	TweenService:Create(bg, outro, {
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(blur, outro, {
		Size = 0
	}):Play()

	TweenService:Create(vignette, outro, {
		ImageTransparency = 1
	}):Play()

	TweenService:Create(frame, outro, {
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(stroke, outro, {
		Transparency = 1
	}):Play()

	TweenService:Create(image, outro, {
		ImageTransparency = 1
	}):Play()

	TweenService:Create(text, outro, {
		TextTransparency = 1
	}):Play()

	TweenService:Create(glow, outro, {
		ImageTransparency = 1
	}):Play()

	TweenService:Create(scale, outro, {
		Scale = 1.25
	}):Play()

	task.wait(0.5)

	if connection then
		connection:Disconnect()
	end

	gui:Destroy()
	blur:Destroy()
end

createInstantSplash("rbxassetid://115041688502921")
-- =============================================================
-- GLOBAL CONFIGURATION
-- =============================================================
local globalConfig = {
	textColor = Color3.new(1, 1, 1),
	uiTransparency = 0.1,
	strokeTransparency = 0.5
}

-- Store main UI references for transparency control
local lunarGui = nil
local mainFrame = nil

-- =============================================================
-- GLASS EFFECT UTILITY
-- =============================================================
local function applyGlassEffect(frame, transparency, strokeTransparency)
	transparency = transparency or globalConfig.uiTransparency
	strokeTransparency = strokeTransparency or globalConfig.strokeTransparency
	frame.BackgroundTransparency = transparency

	local stroke = frame:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 2
	stroke.Transparency = strokeTransparency
	stroke.Parent = frame

	local corner = frame:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local gradient = frame:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 240))
	})
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(1, 0.9)
	})
	gradient.Rotation = 45
	gradient.Parent = frame
end

-- =============================================================
-- THEMES
-- =============================================================
local themes = {
	Default = {
		main = Color3.fromRGB(25, 25, 35),
		grad1 = Color3.fromRGB(40, 40, 55),
		grad2 = Color3.fromRGB(25, 25, 35),
		accent = Color3.fromRGB(0, 180, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(55, 55, 75),
		list = Color3.fromRGB(45, 45, 60),
		glass = Color3.fromRGB(35, 35, 50)
	},
	Pink = {
		main = Color3.fromRGB(255, 192, 203),
		grad1 = Color3.fromRGB(255, 182, 193),
		grad2 = Color3.fromRGB(255, 105, 180),
		accent = Color3.fromRGB(255, 20, 147),
		text = Color3.new(0.1,0.1,0.1),
		btn = Color3.fromRGB(255, 105, 180),
		list = Color3.fromRGB(255, 160, 180),
		glass = Color3.fromRGB(255, 200, 210)
	},
	Blue = {
		main = Color3.fromRGB(30, 40, 70),
		grad1 = Color3.fromRGB(50, 80, 140),
		grad2 = Color3.fromRGB(25, 45, 90),
		accent = Color3.fromRGB(100, 230, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(60, 100, 170),
		list = Color3.fromRGB(45, 65, 110),
		glass = Color3.fromRGB(40, 55, 100)
	},
	Red = {
		main = Color3.fromRGB(50, 20, 20),
		grad1 = Color3.fromRGB(126, 35, 35),
		grad2 = Color3.fromRGB(97, 24, 24),
		accent = Color3.fromRGB(255, 100, 100),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(190, 50, 50),
		list = Color3.fromRGB(80, 25, 25),
		glass = Color3.fromRGB(70, 25, 25)
	},
	Dark = {
		main = Color3.fromRGB(15, 15, 20),
		grad1 = Color3.fromRGB(30, 30, 40),
		grad2 = Color3.fromRGB(15, 15, 20),
		accent = Color3.fromRGB(0, 200, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(40, 40, 55),
		list = Color3.fromRGB(35, 35, 45),
		glass = Color3.fromRGB(25, 25, 35)
	},
	
	-- === PURPLE / VIOLET ===
	Purple = {
		main = Color3.fromRGB(35, 20, 50),
		grad1 = Color3.fromRGB(75, 40, 110),
		grad2 = Color3.fromRGB(40, 20, 60),
		accent = Color3.fromRGB(180, 100, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(90, 50, 130),
		list = Color3.fromRGB(60, 30, 85),
		glass = Color3.fromRGB(50, 25, 75)
	},
	
	-- === GREEN ===
	Green = {
		main = Color3.fromRGB(20, 40, 25),
		grad1 = Color3.fromRGB(40, 90, 50),
		grad2 = Color3.fromRGB(25, 55, 30),
		accent = Color3.fromRGB(80, 255, 120),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(50, 120, 65),
		list = Color3.fromRGB(35, 80, 45),
		glass = Color3.fromRGB(30, 70, 40)
	},
	
	-- === ORANGE ===
	Orange = {
		main = Color3.fromRGB(50, 30, 15),
		grad1 = Color3.fromRGB(140, 80, 30),
		grad2 = Color3.fromRGB(90, 50, 20),
		accent = Color3.fromRGB(255, 160, 50),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(170, 100, 35),
		list = Color3.fromRGB(120, 70, 25),
		glass = Color3.fromRGB(100, 60, 20)
	},
	
	-- === YELLOW / GOLD ===
	Gold = {
		main = Color3.fromRGB(40, 35, 15),
		grad1 = Color3.fromRGB(120, 100, 30),
		grad2 = Color3.fromRGB(80, 65, 20),
		accent = Color3.fromRGB(255, 220, 80),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(150, 125, 40),
		list = Color3.fromRGB(100, 85, 30),
		glass = Color3.fromRGB(90, 75, 25)
	},
	
	-- === CYAN / TEAL ===
	Cyan = {
		main = Color3.fromRGB(20, 40, 45),
		grad1 = Color3.fromRGB(40, 100, 110),
		grad2 = Color3.fromRGB(25, 65, 75),
		accent = Color3.fromRGB(0, 255, 220),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(45, 130, 145),
		list = Color3.fromRGB(35, 90, 100),
		glass = Color3.fromRGB(30, 80, 90)
	},
	
	-- === WHITE / LIGHT ===
	Light = {
		main = Color3.fromRGB(240, 240, 245),
		grad1 = Color3.fromRGB(220, 220, 230),
		grad2 = Color3.fromRGB(245, 245, 250),
		accent = Color3.fromRGB(0, 140, 255),
		text = Color3.new(0.15,0.15,0.15),
		btn = Color3.fromRGB(210, 210, 220),
		list = Color3.fromRGB(225, 225, 235),
		glass = Color3.fromRGB(230, 230, 240)
	},
	
	-- === MIDNIGHT (Deep Blue-Black) ===
	Midnight = {
		main = Color3.fromRGB(10, 12, 25),
		grad1 = Color3.fromRGB(20, 25, 50),
		grad2 = Color3.fromRGB(12, 15, 30),
		accent = Color3.fromRGB(100, 120, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(25, 30, 60),
		list = Color3.fromRGB(18, 22, 45),
		glass = Color3.fromRGB(15, 18, 40)
	},
	
	-- === LAVENDER (Soft Purple) ===
	Lavender = {
		main = Color3.fromRGB(200, 190, 220),
		grad1 = Color3.fromRGB(180, 170, 210),
		grad2 = Color3.fromRGB(220, 210, 240),
		accent = Color3.fromRGB(140, 80, 200),
		text = Color3.new(0.15,0.15,0.15),
		btn = Color3.fromRGB(170, 160, 200),
		list = Color3.fromRGB(190, 180, 215),
		glass = Color3.fromRGB(210, 200, 230)
	},
	
	-- === MINT (Soft Green) ===
	Mint = {
		main = Color3.fromRGB(200, 240, 220),
		grad1 = Color3.fromRGB(180, 230, 210),
		grad2 = Color3.fromRGB(210, 250, 230),
		accent = Color3.fromRGB(50, 200, 120),
		text = Color3.new(0.15,0.15,0.15),
		btn = Color3.fromRGB(170, 225, 200),
		list = Color3.fromRGB(190, 235, 215),
		glass = Color3.fromRGB(200, 245, 225)
	},
	
	-- === CORAL (Peachy Red) ===
	Coral = {
		main = Color3.fromRGB(60, 35, 35),
		grad1 = Color3.fromRGB(180, 100, 90),
		grad2 = Color3.fromRGB(120, 60, 55),
		accent = Color3.fromRGB(255, 140, 120),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(200, 110, 100),
		list = Color3.fromRGB(150, 80, 75),
		glass = Color3.fromRGB(130, 70, 65)
	},
	
	-- === NEON (High Contrast) ===
	Neon = {
		main = Color3.fromRGB(5, 5, 5),
		grad1 = Color3.fromRGB(20, 20, 20),
		grad2 = Color3.fromRGB(5, 5, 5),
		accent = Color3.fromRGB(0, 255, 65),
		text = Color3.fromRGB(0, 255, 65),
		btn = Color3.fromRGB(15, 15, 15),
		list = Color3.fromRGB(10, 10, 10),
		glass = Color3.fromRGB(8, 8, 8)
	},
	
	-- === SUNSET (Pink-Orange Gradient Feel) ===
	Sunset = {
		main = Color3.fromRGB(45, 25, 35),
		grad1 = Color3.fromRGB(160, 70, 90),
		grad2 = Color3.fromRGB(100, 45, 60),
		accent = Color3.fromRGB(255, 120, 140),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(180, 80, 100),
		list = Color3.fromRGB(130, 55, 75),
		glass = Color3.fromRGB(110, 45, 65)
	},
	
	-- === OCEAN (Deep Sea Blue-Green) ===
	Ocean = {
		main = Color3.fromRGB(15, 30, 40),
		grad1 = Color3.fromRGB(30, 70, 90),
		grad2 = Color3.fromRGB(20, 45, 60),
		accent = Color3.fromRGB(0, 220, 200),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(35, 85, 110),
		list = Color3.fromRGB(25, 60, 80),
		glass = Color3.fromRGB(22, 55, 75)
	},
	
	-- === CHERRY (Deep Red-Pink) ===
	Cherry = {
		main = Color3.fromRGB(40, 15, 25),
		grad1 = Color3.fromRGB(130, 30, 60),
		grad2 = Color3.fromRGB(85, 20, 40),
		accent = Color3.fromRGB(255, 60, 120),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(160, 40, 80),
		list = Color3.fromRGB(110, 28, 55),
		glass = Color3.fromRGB(95, 22, 48)
	},
	
	-- === FOREST (Earthy Green-Brown) ===
	Forest = {
		main = Color3.fromRGB(25, 35, 25),
		grad1 = Color3.fromRGB(50, 80, 50),
		grad2 = Color3.fromRGB(35, 55, 35),
		accent = Color3.fromRGB(140, 210, 100),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(60, 100, 60),
		list = Color3.fromRGB(45, 75, 45),
		glass = Color3.fromRGB(38, 65, 38)
	},
	
	-- === COTTON CANDY (Pastel Pink-Blue) ===
	CottonCandy = {
		main = Color3.fromRGB(230, 210, 230),
		grad1 = Color3.fromRGB(210, 190, 230),
		grad2 = Color3.fromRGB(200, 220, 240),
		accent = Color3.fromRGB(255, 130, 180),
		text = Color3.new(0.15,0.15,0.15),
		btn = Color3.fromRGB(220, 200, 230),
		list = Color3.fromRGB(215, 205, 235),
		glass = Color3.fromRGB(225, 215, 240)
	},
	
	-- === AMETHYST (Rich Dark Purple) ===
	Amethyst = {
		main = Color3.fromRGB(30, 15, 40),
		grad1 = Color3.fromRGB(70, 35, 90),
		grad2 = Color3.fromRGB(45, 20, 60),
		accent = Color3.fromRGB(200, 120, 255),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(85, 45, 110),
		list = Color3.fromRGB(60, 30, 80),
		glass = Color3.fromRGB(50, 25, 70)
	},
	
	-- === SLATE (Gray-Blue Professional) ===
	Slate = {
		main = Color3.fromRGB(35, 40, 50),
		grad1 = Color3.fromRGB(60, 70, 85),
		grad2 = Color3.fromRGB(40, 45, 55),
		accent = Color3.fromRGB(130, 170, 220),
		text = Color3.new(1,1,1),
		btn = Color3.fromRGB(70, 80, 100),
		list = Color3.fromRGB(55, 65, 80),
		glass = Color3.fromRGB(48, 55, 70)
	}
}

local currentTheme = themes.Default
-- =============================================================
-- SOUND EFFECTS
-- =============================================================
local currentHoverSound = nil

local function playOpen()
	if soundMuted then return end
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://1111111111111" -- opening sound!!! for the panel
	s.Volume = 0.45 * (_G.uiSoundVol or 1)
	s.Parent = SoundService
	s:Play()
	Debris:AddItem(s, 3)
end

local function playClose()
	if soundMuted then return end
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://4566" -- closing sound!! for the panel
	s.Volume = 0.4 * (_G.uiSoundVol or 1)
	s.Parent = SoundService
	s:Play()
	Debris:AddItem(s, 3)
end

local function playHover()
	if soundMuted then return end
	if currentHoverSound and currentHoverSound.IsPlaying then
		currentHoverSound:Stop()
	end

	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://107677435338382"
	s.Volume = 1 * (_G.uiSoundVol or 1)
	s.Parent = SoundService
	s:Play()
	Debris:AddItem(s, 2)

	currentHoverSound = s
end

local function playClick()
	if soundMuted then return end
	if currentHoverSound and currentHoverSound.IsPlaying then
		currentHoverSound:Stop()
	end

	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://109439703653606"
	s.Volume = 5 * (_G.uiSoundVol or 1)
	s.Parent = SoundService
	s:Play()
	Debris:AddItem(s, 2)
end
-- =============================================================
-- apply sounds to all buttons NOW
-- =============================================================
local function applySoundsToAllButtons(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("TextButton") or obj:IsA("ImageButton") then

			-- Hover sound
			obj.MouseEnter:Connect(function()
				playHover()
			end)

			-- Click sound + cancel hover
			obj.MouseButton1Click:Connect(function()
				playClick()
			end)
		end
	end
end

-- Setup sounds for main GUI and future panels
local function setupButtonSounds()
	if lunarGui then
		task.wait(0.5)
		applySoundsToAllButtons(lunarGui)
	end

	-- Auto-apply to any new panels
	client.PlayerGui.ChildAdded:Connect(function(child)
		if child:IsA("ScreenGui") then
			task.wait(0.3)
			applySoundsToAllButtons(child)
		end
	end)
end
-- =============================================================
-- better notis
-- =============================================================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "LunarNotifs"
notifGui.ResetOnSpawn = false
notifGui.DisplayOrder = 2147483647
notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
notifGui.ScreenInsets = Enum.ScreenInsets.None
notifGui.IgnoreGuiInset = true
notifGui.Parent = game:GetService("CoreGui")

local UserInputService = game:GetService("UserInputService")

local isMobile = UserInputService.TouchEnabled

local notifWidth = 340
local notifHeight = 76
local notifSpacing = 12
local startY = 20
local notifOffscreen = 120
local notifTargetX = -360

if isMobile then
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
	local smallestSide = math.min(viewport.X, viewport.Y)

	-- Phone
	if smallestSide < 700 then
		notifWidth = 220
		notifHeight = 52
		notifSpacing = 6
		startY = 8
		notifOffscreen = 80
		notifTargetX = -240

	-- Tablet / iPad
	else
		notifWidth = 280
		notifHeight = 62
		notifSpacing = 8
		startY = 12
		notifOffscreen = 100
		notifTargetX = -300
	end
end

local activeNotifications = {}
local notifHeight = 76
local notifSpacing = 12
local startY = 20 -- top padding
local notifDuration = 5

local currentNotifSound = nil

local function playNotifSound()
	if notifSoundMuted then return end  -- Only checks notif mute, not UI mute
	if currentNotifSound and currentNotifSound.IsPlaying then
		currentNotifSound:Stop()
	end

	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://97643101798871"
	s.Volume = 0.55
	s.Parent = SoundService
	s:Play()

	currentNotifSound = s
	Debris:AddItem(s, 4)
end

local function repositionAll()
	for i, notif in ipairs(activeNotifications) do
		if notif and notif.Parent then
			local targetY = startY + ((i - 1) * (notifHeight + notifSpacing))
			TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -360, 0, targetY)
			}):Play()
		end
	end
end

local function notify(text, col)
	col = col or currentTheme.accent or Color3.fromRGB(147, 112, 219)

	-- Main container
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, notifWidth, 0, notifHeight)
	f.Position = UDim2.new(1, 120, 0, -200) -- start off-screen top-right
	f.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	f.BorderSizePixel = 0
	f.BackgroundTransparency = 1
	f.Parent = notifGui
	f.ZIndex = 2147483647

	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

	-- Subtle border glow
	local stroke = Instance.new("UIStroke")
	stroke.Color = col
	stroke.Transparency = 1
	stroke.Thickness = 1.5
	stroke.ZIndex = 2147483647
	stroke.Parent = f

	-- Moon emoji
	local moonIcon = Instance.new("TextLabel")
	moonIcon.Size = isMobile and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 28, 0, 28)
	moonIcon.Position = UDim2.new(0, 12, 0, 8)
	moonIcon.BackgroundTransparency = 1
	moonIcon.Text = "🌙"
	moonIcon.TextSize = isMobile and 16 or 22
	moonIcon.Font = Enum.Font.Code
	moonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
	moonIcon.TextTransparency = 1
	moonIcon.ZIndex = 2147483647
	moonIcon.Parent = f

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -52, 0, 28)
	titleLabel.Position = UDim2.new(0, 44, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Lunar"
	titleLabel.Font = Enum.Font.Code
	titleLabel.TextSize = isMobile and 13 or 16
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextTransparency = 1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 2147483647
	titleLabel.Parent = f

	-- Message
	local msgLabel = Instance.new("TextLabel")
	msgLabel.Size = UDim2.new(1, -24, 0, 32)
	msgLabel.Position = UDim2.new(0, 12, 0, 38)
	msgLabel.BackgroundTransparency = 1
	msgLabel.Text = text
	msgLabel.Font = Enum.Font.Code
	msgLabel.TextSize = isMobile and 11 or 14
	msgLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
	msgLabel.TextTransparency = 1
	msgLabel.TextWrapped = true
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.TextYAlignment = Enum.TextYAlignment.Top
	msgLabel.ZIndex = 2147483647
	msgLabel.Parent = f

	-- Timer progress bar at bottom
	local timerBar = Instance.new("Frame")
	timerBar.Size = UDim2.new(1, 0, 0, 3)
	timerBar.Position = UDim2.new(0, 0, 1, -3)
	timerBar.BackgroundColor3 = col
	timerBar.BorderSizePixel = 0
	timerBar.BackgroundTransparency = 1
	timerBar.ZIndex = 2147483647
	timerBar.Parent = f

	Instance.new("UICorner", timerBar).CornerRadius = UDim.new(0, 2)

	-- Play sound
	playNotifSound()

	-- Add to stack (append to end = bottom of list)
	table.insert(activeNotifications, f)

	-- Calculate target Y for this notification
	local targetY = startY + ((#activeNotifications - 1) * (notifHeight + notifSpacing))

	-- Entrance Animation
	TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, notifTargetX, 0, targetY),
		BackgroundTransparency = 0.05
	}):Play()

	TweenService:Create(stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0.7
	}):Play()

	TweenService:Create(moonIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()

	TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()

	TweenService:Create(msgLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()

	TweenService:Create(timerBar, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()

	-- Timer animation — bar shrinks over duration
	TweenService:Create(timerBar, TweenInfo.new(notifDuration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 0, 3)
	}):Play()

	-- Auto remove after duration
	task.delay(notifDuration, function()
		if not f.Parent then return end

		-- Remove from stack
		for i, notif in ipairs(activeNotifications) do
			if notif == f then
				table.remove(activeNotifications, i)
				break
			end
		end

		-- Exit animation (slide right and fade)
		TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 120, 0, f.Position.Y.Offset),
			BackgroundTransparency = 1
		}):Play()

		TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			Transparency = 1
		}):Play()

		TweenService:Create(moonIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			TextTransparency = 1
		}):Play()

		TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			TextTransparency = 1
		}):Play()

		TweenService:Create(msgLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
			TextTransparency = 1
		}):Play()

		TweenService:Create(timerBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 1
		}):Play()

		-- Slide remaining notifications UP to fill gap
		task.delay(0.2, function()
			repositionAll()
		end)

		task.delay(0.6, function()
			if f.Parent then f:Destroy() end
		end)
	end)

	-- Limit to 6 notifications (remove oldest from top)
	if #activeNotifications > 6 then
		local old = table.remove(activeNotifications, 1) -- remove first (oldest)
		if old and old.Parent then
			TweenService:Create(old, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				Position = UDim2.new(1, notifOffscreen, 0, old.Position.Y.Offset),
				BackgroundTransparency = 1
			}):Play()
			task.delay(0.4, function()
				if old.Parent then old:Destroy() end
			end)
			-- Reposition rest after removing top one
			task.delay(0.2, repositionAll)
		end
	end
end
-- =============================================================
-- Project Lunar watermakr yea
-- =============================================================
task.spawn(function()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Stats = game:GetService("Stats")
	local CoreGui = game:GetService("CoreGui")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local client = Players.LocalPlayer

	local isMobile = UserInputService.TouchEnabled

	local frameWidth = 380
	local frameHeight = 34
	local frameX = -390
	local textSize = 16
	local moonSize = 22

	if isMobile then
		local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
		local smallestSide = math.min(viewport.X, viewport.Y)

		if smallestSide < 700 then
			frameWidth = 300
			frameHeight = 28
			frameX = -310
			textSize = 12
			moonSize = 16
		else
			frameWidth = 340
			frameHeight = 30
			frameX = -350
			textSize = 14
			moonSize = 18
		end
	end

	if CoreGui:FindFirstChild("LunarWatermark") then
		CoreGui.LunarWatermark:Destroy()
	end

	local serverRunTime = workspace:FindFirstChild("ServerRunTime")
	if not serverRunTime then
		serverRunTime = Instance.new("NumberValue")
		serverRunTime.Name = "ServerRunTime"
		serverRunTime.Value = 0
		serverRunTime.Parent = workspace
	end

	local pingEvent = ReplicatedStorage:FindFirstChild("PingEvent")
	if not pingEvent then
		pingEvent = Instance.new("RemoteEvent")
		pingEvent.Name = "PingEvent"
		pingEvent.Parent = ReplicatedStorage
	end

	local sg = Instance.new("ScreenGui")
	sg.Name = "LunarWatermark"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.DisplayOrder = 2147483647
	sg.ScreenInsets = Enum.ScreenInsets.None
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
	sg.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
	frame.Position = UDim2.new(1, frameX, 0, 15)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	frame.BackgroundTransparency = 0.15
	frame.ZIndex = 2147483647
	frame.Parent = sg

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

	local dragTab = Instance.new("Frame")
	dragTab.Size = UDim2.new(0, 30, 1, 0)
	dragTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dragTab.BackgroundTransparency = 0.2
	dragTab.ZIndex = 2147483647
	dragTab.Parent = frame

	Instance.new("UICorner", dragTab).CornerRadius = UDim.new(0, 16)

	local tabLabel = Instance.new("TextLabel")
	tabLabel.Size = UDim2.fromScale(1, 1)
	tabLabel.BackgroundTransparency = 1
	tabLabel.Text = "≡"
	tabLabel.TextSize = isMobile and 14 or 18
	tabLabel.Font = Enum.Font.Code
	tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabLabel.ZIndex = 2147483647
	tabLabel.Parent = dragTab

	local moon = Instance.new("TextLabel", frame)
	moon.Size = UDim2.new(0, 32, 1, 0)
	moon.Position = UDim2.new(0, 42, 0, 0)
	moon.BackgroundTransparency = 1
	moon.Text = "🌙"
	moon.TextColor3 = Color3.fromRGB(255, 215, 0)
	moon.TextSize = moonSize
	moon.Font = Enum.Font.Code
	moon.ZIndex = 2147483647

	local label = Instance.new("TextLabel", frame)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -90, 1, 0)
	label.Position = UDim2.new(0, 80, 0, 0)
	label.Font = Enum.Font.Code
	label.TextSize = textSize
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = "Project Lunar | Loading..."
	label.RichText = true
	label.ZIndex = 2147483647

	local visible = true
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.P then
			visible = not visible
			frame.Visible = visible
		end
	end)

	local dragging = false
	local dragStart
	local startPos
	local targetPos = frame.Position

	dragTab.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	dragTab.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			targetPos = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	RunService.RenderStepped:Connect(function()
		frame.Position = frame.Position:Lerp(targetPos, 0.25)
	end)

	local fps = 60
	local frameCount = 0
	local fpsTimer = 0
	local fpsUpdateInterval = 0.5

	RunService.RenderStepped:Connect(function(dt)
		frameCount += 1
		fpsTimer += dt
		if fpsTimer >= fpsUpdateInterval then
			local measuredFPS = frameCount / fpsTimer
			fps = fps + (measuredFPS - fps) * 0.3
			frameCount = 0
			fpsTimer = 0
		end
	end)

	local ping = 0
	local latestPing = 0
	local lastPingRequest = 0
	local pingRequestSent = false
	local serverTimeOffset = 0
	local serverTimeValid = false

	pingEvent.OnClientEvent:Connect(function(data)
		if type(data) == "number" then
			latestPing = data
			pingRequestSent = false
		elseif type(data) == "table" and data.serverTime then
			local clientTime = tick()
			local roundTrip = (clientTime - lastPingRequest) * 1000
			latestPing = roundTrip / 2
			serverTimeOffset = data.serverTime - clientTime
			serverTimeValid = true
			pingRequestSent = false
		end
	end)

	local function measureSelfPing()
		local startTime = tick()
		lastPingRequest = startTime
		pingRequestSent = true
		local received = false
		local connection
		connection = RunService.Heartbeat:Connect(function()
			if received then
				connection:Disconnect()
				return
			end
			if tick() - startTime > 5 then
				received = true
				connection:Disconnect()
			end
		end)
		pingEvent:FireServer({action = "ping", clientTime = startTime})
	end

	pingEvent.OnClientEvent:Connect(function(data)
		if type(data) == "table" and data.action == "pong" and data.clientTime then
			local roundTrip = (tick() - data.clientTime) * 1000
			latestPing = roundTrip
			pingRequestSent = false
		end
	end)

	task.spawn(function()
		task.wait(1)
		measureSelfPing()

		while sg.Parent do
			if not pingRequestSent then
				measureSelfPing()
			end

			local targetPing = latestPing
			if targetPing <= 0 then
				pcall(function()
					targetPing = client:GetNetworkPing() * 1000
				end)
			end
			if targetPing < 0 or targetPing ~= targetPing then
				targetPing = 0
			end

			local diff = targetPing - ping
			if diff > 0 then
				ping = ping + diff * 0.9
			else
				ping = ping + diff * 0.15
			end

			local fpsDisplay = math.floor(fps + 0.5)
			local pingDisplay = math.floor(ping + 0.5)

			local pingColor
			if pingDisplay < 50 then
				pingColor = Color3.fromRGB(0, 255, 100)
			elseif pingDisplay < 150 then
				local t = (pingDisplay - 50) / 100
				pingColor = Color3.fromRGB(0, 255, 100):Lerp(Color3.fromRGB(255, 255, 0), t)
			elseif pingDisplay < 300 then
				local t = (pingDisplay - 150) / 150
				pingColor = Color3.fromRGB(255, 255, 0):Lerp(Color3.fromRGB(255, 150, 0), t)
			else
				local t = math.clamp((pingDisplay - 300) / 700, 0, 1)
				pingColor = Color3.fromRGB(255, 150, 0):Lerp(Color3.fromRGB(255, 50, 50), t)
			end

			local pingText
			if pingDisplay >= 100000 then
				pingText = string.format("%dK", math.floor(pingDisplay / 1000))
			elseif pingDisplay >= 10000 then
				pingText = string.format("%.1fK", pingDisplay / 1000)
			elseif pingDisplay >= 1000 then
				pingText = string.format("%.1fK", pingDisplay / 1000)
			else
				pingText = tostring(pingDisplay)
			end

			local r = math.floor(pingColor.R * 255)
			local g = math.floor(pingColor.G * 255)
			local b = math.floor(pingColor.B * 255)

			if isMobile then
				label.Text = string.format([[Lunar | %d FPS | <font color="rgb(%d,%d,%d)">%s ms</font>]], fpsDisplay, r, g, b, pingText)
			else
				label.Text = string.format([[Project Lunar | %d FPS | <font color="rgb(%d,%d,%d)">%s ms</font>]], fpsDisplay, r, g, b, pingText)
			end

			task.wait(0.1)
		end
	end)
end)
-- ═══════════════════════════════════════════════════════════
-- Flashlight
-- ═══════════════════════════════════════════════════════════

LunarFlashlight = {
	enabled = false,
	lightPart = nil,
	spotLight = nil,
	openSound = nil,
	closeSound = nil,
	tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
	renderConn = nil,
	inputConn = nil
}

function LunarFlashlight:Init()
	if self.lightPart then return end

	self.lightPart = Instance.new("Part")
	self.lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
	self.lightPart.Anchored = true
	self.lightPart.CanCollide = false
	self.lightPart.Transparency = 1
	self.lightPart.Parent = workspace

	self.spotLight = Instance.new("SpotLight")
	self.spotLight.Enabled = false
	self.spotLight.Brightness = 3
	self.spotLight.Range = 70
	self.spotLight.Angle = 80
	self.spotLight.Parent = self.lightPart

	self.openSound = Instance.new("Sound")
	self.openSound.SoundId = "rbxassetid://198914875"
	self.openSound.Volume = 1
	self.openSound.Parent = self.lightPart

	self.closeSound = Instance.new("Sound")
	self.closeSound.SoundId = "rbxassetid://198915223"
	self.closeSound.Volume = 1
	self.closeSound.Parent = self.lightPart

	-- Follow camera
	self.renderConn = RunService.RenderStepped:Connect(function()
		if self.enabled and self.lightPart then
			local cam = workspace.CurrentCamera
			if cam then
				local target = cam.CFrame * CFrame.new(0, 0, -1)
				TweenService:Create(self.lightPart, self.tweenInfo, {CFrame = target}):Play()
			end
		end
	end)

	-- F key toggle
	self.inputConn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == Enum.KeyCode.F then
			self:Toggle()
		end
	end)
end

function LunarFlashlight:Toggle()
	if not self.lightPart then self:Init() end
	self.enabled = not self.enabled
	self.spotLight.Enabled = self.enabled
	if self.enabled then
		self.openSound:Play()
	else
		self.closeSound:Play()
	end
end

function LunarFlashlight:TurnOn()
	if not self.lightPart then self:Init() end
	if not self.enabled then
		self.enabled = true
		self.spotLight.Enabled = true
		self.openSound:Play()
	end
end

function LunarFlashlight:TurnOff()
	if self.lightPart and self.enabled then
		self.enabled = false
		self.spotLight.Enabled = false
		self.closeSound:Play()
	end
end

function LunarFlashlight:Cleanup()
	if self.renderConn then self.renderConn:Disconnect() end
	if self.inputConn then self.inputConn:Disconnect() end
	if self.lightPart then self.lightPart:Destroy() end
	self.lightPart = nil
	self.spotLight = nil
	self.openSound = nil
	self.closeSound = nil
	self.enabled = false
	self.renderConn = nil
	self.inputConn = nil
end

-- ═══════════════════════════════════════════════════════════
-- COMMAND ENTRY POINTS — Add these to your command processor
-- ═══════════════════════════════════════════════════════════
function openFlashlight()
	LunarFlashlight:TurnOn()
end

function closeFlashlight()
	LunarFlashlight:TurnOff()
end

-- =============================================================
-- ORBIT / UNORBIT
-- =============================================================
_G._orbitData = {
	conn = nil,
	target = nil,
	speed = 1,
	angle = 0,
	radius = 8
}

function _G.StartOrbit(args)
	_G.StopOrbit()

	local targetName = args[1]
	if not targetName then
		if notify then notify("❌ Usage: !orbit [player] [speed]", Color3.fromRGB(255,100,100)) end
		return
	end

	targetName = targetName:lower()
	local targetPlr = nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #targetName) == targetName or plr.DisplayName:lower():sub(1, #targetName) == targetName then
			targetPlr = plr
			break
		end
	end

	if not targetPlr then
		if notify then notify("❌ Player not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._orbitData.target = targetPlr
	_G._orbitData.speed = tonumber(args[2]) or 2
	_G._orbitData.angle = 0

	_G._orbitData.conn = RunService.Heartbeat:Connect(function(dt)
		pcall(function()
			local myChar = client.Character
			local theirChar = targetPlr.Character
			if not myChar or not theirChar then return end
			local myRoot = myChar:FindFirstChild("HumanoidRootPart")
			local theirRoot = theirChar:FindFirstChild("HumanoidRootPart")
			if not myRoot or not theirRoot then return end

			_G._orbitData.angle = _G._orbitData.angle + (_G._orbitData.speed * dt)
			local offset = Vector3.new(
				math.cos(_G._orbitData.angle) * _G._orbitData.radius,
				0,
				math.sin(_G._orbitData.angle) * _G._orbitData.radius
			)
			myRoot.CFrame = CFrame.new(theirRoot.Position + offset, theirRoot.Position)
		end)
	end)

	if notify then notify("Orbiting " .. targetPlr.Name, Color3.fromRGB(150, 100, 255)) end
end

function _G.StopOrbit()
	if _G._orbitData.conn then
		pcall(function() _G._orbitData.conn:Disconnect() end)
	end
	_G._orbitData = {conn = nil, target = nil, speed = 1, angle = 0, radius = 8}
	if notify then notify("Orbit stopped", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- LOOP GOTO / UNLOOP GOTO
-- =============================================================
_G._loopGotoData = {
	conn = nil,
	target = nil,
	delay = 1
}

function _G.StartLoopGoto(args)
	_G.StopLoopGoto()

	local targetName = args[1]
	if not targetName then
		if notify then notify("❌ Usage: !loopgoto [player] [delay]", Color3.fromRGB(255,100,100)) end
		return
	end

	targetName = targetName:lower()
	local targetPlr = nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #targetName) == targetName or plr.DisplayName:lower():sub(1, #targetName) == targetName then
			targetPlr = plr
			break
		end
	end

	if not targetPlr then
		if notify then notify("❌ Player not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._loopGotoData.target = targetPlr
	_G._loopGotoData.delay = tonumber(args[2]) or 1

	local function tpToTarget()
		pcall(function()
			local myChar = client.Character
			local theirChar = targetPlr.Character
			if not myChar or not theirChar then return end
			local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso")
			local theirRoot = theirChar:FindFirstChild("HumanoidRootPart") or theirChar:FindFirstChild("Torso")
			if myRoot and theirRoot then
				myRoot.CFrame = theirRoot.CFrame + Vector3.new(0, 3, 0)
			end
		end)
	end

	-- Teleport immediately, then loop
	tpToTarget()
	_G._loopGotoData.conn = task.spawn(function()
		while _G._loopGotoData.target do
			task.wait(_G._loopGotoData.delay)
			if not _G._loopGotoData.target then break end
			tpToTarget()
		end
	end)

	if notify then notify("Loop goto " .. targetPlr.Name .. " every " .. _G._loopGotoData.delay .. "s", Color3.fromRGB(100, 200, 255)) end
end

function _G.StopLoopGoto()
	_G._loopGotoData.target = nil
	_G._loopGotoData = {conn = nil, target = nil, delay = 1}
	if notify then notify("Loop goto stopped", Color3.fromRGB(100, 255, 150)) end
end
-- =============================================================
-- TPWALK / UNTPWALK STANDALONE
-- =============================================================

_G._tpwalkData = {
	conn = nil,
	speed = 1,
	stack = 0
}

function _G.EnableTPWalk(args)
	_G.DisableTPWalk()

	local char = client.Character
	if not char then
		if notify then notify("❌ Character not loaded", Color3.fromRGB(255,100,100)) end
		return
	end

	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if not hum then
		if notify then notify("❌ Humanoid not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._tpwalkData.speed = tonumber(args[1]) or 1

	_G._tpwalkData.conn = RunService.Heartbeat:Connect(function(delta)
		pcall(function()
			local char = client.Character
			if not char then return end
			local hum = char:FindFirstChildWhichIsA("Humanoid")
			if not hum or not hum.Parent then
				_G.DisableTPWalk()
				return
			end

			if hum.MoveDirection.Magnitude > 0 then
				char:TranslateBy(hum.MoveDirection * (_G._tpwalkData.speed + _G._tpwalkData.stack) * delta * 10)
			end
		end)
	end)

	if notify then notify("TPWalk enabled — Speed: " .. _G._tpwalkData.speed, Color3.fromRGB(100, 255, 200)) end
end

function _G.DisableTPWalk()
	if _G._tpwalkData.conn then
		pcall(function() _G._tpwalkData.conn:Disconnect() end)
	end
	_G._tpwalkData = {conn = nil, speed = 1, stack = 0}
	if notify then notify("TPWalk disabled", Color3.fromRGB(100, 255, 150)) end
end
-- =================== END TPWALK / UNTPWALK ===================
-- =============================================================
-- WALK ON WATER / UNWALK ON WATER
-- =============================================================
_G._walkOnWaterData = {
	conn = nil,
	originalGravity = workspace.Gravity
}

function _G.EnableWalkOnWater()
	_G.DisableWalkOnWater()

	_G._walkOnWaterData.originalGravity = workspace.Gravity

	_G._walkOnWaterData.conn = RunService.Heartbeat:Connect(function()
		pcall(function()
			local char = client.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not root or not hum then return end

			-- Check if above water
			local pos = root.Position
			local ray = Ray.new(pos, Vector3.new(0, -10, 0))
			local hit, pos = workspace:FindPartOnRay(ray, char)
			if hit then
				local isWater = hit.Name:lower():find("water") or hit.Material == Enum.Material.Water
				if isWater and hum.FloorMaterial == Enum.Material.Air then
					-- Just above water, push up
					root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
					root.CFrame = CFrame.new(root.Position.X, pos.Y + 3, root.Position.Z)
				end
			end
		end)
	end)

	if notify then notify("Walk on water enabled", Color3.fromRGB(100, 150, 255)) end
end

function _G.DisableWalkOnWater()
	if _G._walkOnWaterData.conn then
		pcall(function() _G._walkOnWaterData.conn:Disconnect() end)
	end
	workspace.Gravity = _G._walkOnWaterData.originalGravity
	_G._walkOnWaterData = {conn = nil, originalGravity = workspace.Gravity}
	if notify then notify("Walk on water disabled", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- SUPER JUMP
-- =============================================================
_G._superJumpData = {
	originalPower = 50,
	conn = nil
}

function _G.EnableSuperJump(args)
	_G.DisableSuperJump()

	local char = client.Character
	if not char then
		if notify then notify("❌ Character not loaded", Color3.fromRGB(255,100,100)) end
		return
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		if notify then notify("❌ Humanoid not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._superJumpData.originalPower = hum.JumpPower
	local power = tonumber(args[1]) or 100
	hum.JumpPower = power

	-- Keep reapplying on respawn
	_G._superJumpData.conn = client.CharacterAdded:Connect(function(newChar)
		task.wait(0.3)
		local newHum = newChar:FindFirstChildOfClass("Humanoid")
		if newHum then newHum.JumpPower = power end
	end)

	if notify then notify("Super jump enabled: " .. power, Color3.fromRGB(100, 255, 100)) end
end

function _G.DisableSuperJump()
	if _G._superJumpData.conn then
		pcall(function() _G._superJumpData.conn:Disconnect() end)
	end
	local char = client.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = _G._superJumpData.originalPower end
	end
	_G._superJumpData = {originalPower = 50, conn = nil}
	if notify then notify("Super jump disabled", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- GRAVITY / RESET GRAVITY
-- =============================================================
_G._gravityOriginal = workspace.Gravity

function _G.SetGravity(args)
	local grav = tonumber(args[1])
	if not grav then
		if notify then notify("❌ Usage: !gravity [number]", Color3.fromRGB(255,100,100)) end
		return
	end
	workspace.Gravity = grav
	if notify then notify("Gravity set to " .. grav, Color3.fromRGB(150, 200, 255)) end
end

function _G.ResetGravity()
	workspace.Gravity = _G._gravityOriginal
	if notify then notify("Gravity reset to " .. _G._gravityOriginal, Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- CAMLOCK / UNCAMLOCK
-- =============================================================
_G._camlockData = {
	conn = nil,
	target = nil,
	originalCameraType = nil
}

function _G.StartCamlock(args)
	_G.StopCamlock()

	local targetName = args[1]
	if not targetName then
		if notify then notify("❌ Usage: !camlock [player]", Color3.fromRGB(255,100,100)) end
		return
	end

	targetName = targetName:lower()
	local targetPlr = nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #targetName) == targetName or plr.DisplayName:lower():sub(1, #targetName) == targetName then
			targetPlr = plr
			break
		end
	end

	if not targetPlr then
		if notify then notify("❌ Player not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._camlockData.target = targetPlr
	_G._camlockData.originalCameraType = workspace.CurrentCamera.CameraType
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

	_G._camlockData.conn = RunService.RenderStepped:Connect(function()
		pcall(function()
			local theirChar = targetPlr.Character
			if not theirChar then return end
			local theirRoot = theirChar:FindFirstChild("HumanoidRootPart") or theirChar:FindFirstChild("Head")
			if not theirRoot then return end

			local cam = workspace.CurrentCamera
			local myChar = client.Character
			local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
			if myRoot then
				cam.CFrame = CFrame.new(myRoot.Position + Vector3.new(0, 5, 10), theirRoot.Position)
			else
				cam.CFrame = CFrame.new(theirRoot.Position + Vector3.new(0, 10, 20), theirRoot.Position)
			end
		end)
	end)

	if notify then notify("Camlock on " .. targetPlr.Name, Color3.fromRGB(255, 100, 100)) end
end

function _G.StopCamlock()
	if _G._camlockData.conn then
		pcall(function() _G._camlockData.conn:Disconnect() end)
	end
	if _G._camlockData.originalCameraType then
		workspace.CurrentCamera.CameraType = _G._camlockData.originalCameraType
	end
	_G._camlockData = {conn = nil, target = nil, originalCameraType = nil}
	if notify then notify("Camlock stopped", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- ZOOM (PC ONLY)
-- =============================================================
_G._zoomData = {
	conn = nil,
	zoomKey = nil,
	zoomDistance = 50
}

function _G.SetZoom(args)
	-- PC ONLY check
	local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
	if isMobile then
		if notify then notify("❌ Zoom is PC only", Color3.fromRGB(255,100,100)) end
		return
	end

	_G.ClearZoom()

	local distance = tonumber(args[1])
	if not distance then
		if notify then notify("❌ Usage: !zoom [distance] [key]", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._zoomData.zoomDistance = distance
	_G._zoomData.zoomKey = args[2] and Enum.KeyCode[args[2]:upper()] or Enum.KeyCode.Z

	local zoomed = false
	local originalMaxZoom = nil

	_G._zoomData.conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == _G._zoomData.zoomKey then
			zoomed = not zoomed
			local cam = workspace.CurrentCamera
			if zoomed then
				originalMaxZoom = cam.MaxZoomDistance
				cam.MaxZoomDistance = _G._zoomData.zoomDistance
				cam.MinZoomDistance = _G._zoomData.zoomDistance
				if notify then notify("Zoomed to " .. distance, Color3.fromRGB(100, 200, 255)) end
			else
				cam.MaxZoomDistance = originalMaxZoom or 400
				cam.MinZoomDistance = 0.5
				if notify then notify("Zoom reset", Color3.fromRGB(100, 255, 150)) end
			end
		end
	end)

	if notify then notify("Zoom set: " .. distance .. " | Key: " .. tostring(_G._zoomData.zoomKey.Name), Color3.fromRGB(100, 200, 255)) end
end

function _G.ClearZoom()
	if _G._zoomData.conn then
		pcall(function() _G._zoomData.conn:Disconnect() end)
	end
	local cam = workspace.CurrentCamera
	cam.MaxZoomDistance = 400
	cam.MinZoomDistance = 0.5
	_G._zoomData = {conn = nil, zoomKey = nil, zoomDistance = 50}
	if notify then notify("Zoom cleared", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- XRAY / UNXRAY
-- =============================================================
_G._xrayData = {
	originalTransparencies = {}
}

function _G.EnableXray()
	_G.DisableXray()

	_G._xrayData.originalTransparencies = {}

	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 0.7 then
			_G._xrayData.originalTransparencies[part] = part.Transparency
			part.Transparency = 0.7
		end
	end

	if notify then notify("X-Ray enabled", Color3.fromRGB(100, 255, 100)) end
end

function _G.DisableXray()
	for part, trans in pairs(_G._xrayData.originalTransparencies) do
		pcall(function()
			if part and part.Parent then
				part.Transparency = trans
			end
		end)
	end
	_G._xrayData = {originalTransparencies = {}}
	if notify then notify("X-Ray disabled", Color3.fromRGB(100, 255, 150)) end
end

-- =============================================================
-- TIMESET
-- =============================================================
_G._timeOriginal = nil

function _G.SetTime(args)
	local hour = tonumber(args[1])
	if not hour or hour < 0 or hour > 24 then
		if notify then notify("❌ Usage: !timeset [0-24]", Color3.fromRGB(255,100,100)) end
		return
	end

	if _G._timeOriginal == nil then
		_G._timeOriginal = game.Lighting.ClockTime
	end

	game.Lighting.ClockTime = hour
	if notify then notify("Time set to " .. hour .. ":00", Color3.fromRGB(255, 200, 100)) end
end

function _G.ResetTime()
	if _G._timeOriginal ~= nil then
		game.Lighting.ClockTime = _G._timeOriginal
		if notify then notify("Time reset", Color3.fromRGB(100, 255, 150)) end
	end
end

-- =============================================================
-- COPY CHAT / UNCOPY CHAT
-- =============================================================
_G._copyChatData = {
	conn = nil,
	target = nil
}

function _G.StartCopyChat(args)
	_G.StopCopyChat()

	local targetName = args[1]
	if not targetName then
		if notify then notify("❌ Usage: !copychat [player]", Color3.fromRGB(255,100,100)) end
		return
	end

	targetName = targetName:lower()
	local targetPlr = nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #targetName) == targetName or plr.DisplayName:lower():sub(1, #targetName) == targetName then
			targetPlr = plr
			break
		end
	end

	if not targetPlr then
		if notify then notify("❌ Player not found", Color3.fromRGB(255,100,100)) end
		return
	end

	_G._copyChatData.target = targetPlr

	_G._copyChatData.conn = targetPlr.Chatted:Connect(function(msg)
		pcall(function()
			if TextChatService then
				local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
				if channel then
					channel:SendAsync("[" .. targetPlr.Name .. "]: " .. msg)
				end
			elseif game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") then
				-- Legacy chat
				local chatRemote = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
				chatRemote:FireServer("[" .. targetPlr.Name .. "]: " .. msg, "All")
			end
		end)
	end)

	if notify then notify("Copying chat from " .. targetPlr.Name, Color3.fromRGB(100, 255, 200)) end
end

function _G.StopCopyChat()
	if _G._copyChatData.conn then
		pcall(function() _G._copyChatData.conn:Disconnect() end)
	end
	_G._copyChatData = {conn = nil, target = nil}
	if notify then notify("Copy chat stopped", Color3.fromRGB(100, 255, 150)) end
end

-- =================== JERK TOOL STANDALONE ===================

_G._jerkData = {
	tool = nil,
	track = nil,
	jorkin = false,
	loopConn = nil,
	equippedConn = nil,
	unequippedConn = nil,
	diedConn = nil
}

function _G.GiveJerkTool()
	-- Cleanup existing
	_G.RemoveJerkTool()

	local char = client.Character
	if not char then
		if notify then notify("❌ Character not loaded", Color3.fromRGB(255,100,100)) end
		return
	end

	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	local backpack = client:FindFirstChildWhichIsA("Backpack")
	if not humanoid or not backpack then
		if notify then notify("❌ Humanoid or Backpack not found", Color3.fromRGB(255,100,100)) end
		return
	end

	local tool = Instance.new("Tool")
	tool.Name = "Jerk Off"
	tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
	tool.RequiresHandle = false
	tool.Parent = backpack
	_G._jerkData.tool = tool

	local function stopTomfoolery()
		_G._jerkData.jorkin = false
		if _G._jerkData.track then
			pcall(function() _G._jerkData.track:Stop() end)
			_G._jerkData.track = nil
		end
	end

	_G._jerkData.equippedConn = tool.Equipped:Connect(function()
		_G._jerkData.jorkin = true
	end)

	_G._jerkData.unequippedConn = tool.Unequipped:Connect(stopTomfoolery)
	_G._jerkData.diedConn = humanoid.Died:Connect(stopTomfoolery)

	-- Main loop
	_G._jerkData.loopConn = task.spawn(function()
		while task.wait() do
			if not _G._jerkData.tool or not _G._jerkData.tool.Parent then break end
			if not _G._jerkData.jorkin then continue end

			local isR15 = char:FindFirstChild("UpperTorso") ~= nil
			if not _G._jerkData.track then
				local anim = Instance.new("Animation")
				anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
				_G._jerkData.track = humanoid:LoadAnimation(anim)
			end

			_G._jerkData.track:Play()
			_G._jerkData.track:AdjustSpeed(isR15 and 0.7 or 0.65)
			_G._jerkData.track.TimePosition = 0.6
			task.wait(0.1)
			while _G._jerkData.track and _G._jerkData.track.TimePosition < (not isR15 and 0.65 or 0.7) do
				task.wait(0.1)
			end
			if _G._jerkData.track then
				_G._jerkData.track:Stop()
				_G._jerkData.track = nil
			end
		end
	end)

	if notify then
		notify("Jerk tool given!", Color3.fromRGB(255, 150, 200))
	end
end

function _G.RemoveJerkTool()
	pcall(function()
		if _G._jerkData.loopConn then
			-- task.spawn can't be disconnected, but the loop checks tool.Parent
		end
		if _G._jerkData.equippedConn then _G._jerkData.equippedConn:Disconnect() end
		if _G._jerkData.unequippedConn then _G._jerkData.unequippedConn:Disconnect() end
		if _G._jerkData.diedConn then _G._jerkData.diedConn:Disconnect() end
		if _G._jerkData.track then _G._jerkData.track:Stop() end
		if _G._jerkData.tool then _G._jerkData.tool:Destroy() end
	end)
	_G._jerkData = {
		tool = nil,
		track = nil,
		jorkin = false,
		loopConn = nil,
		equippedConn = nil,
		unequippedConn = nil,
		diedConn = nil
	}
	if notify then
		notify("Jerk tool removed", Color3.fromRGB(255, 100, 100))
	end
end

-- =================== BANG / UNBANG STANDALONE ===================

_G._bangData = {
	anim = nil,
	track = nil,
	diedConn = nil,
	steppedConn = nil,
	target = nil
}

function _G.StartBang(args)
	-- Args: args[1] = target name/displayname, args[2] = speed number
	
	-- Cleanup existing
	_G.StopBang()

	local char = client.Character
	if not char then
		if notify then notify("❌ Character not loaded", Color3.fromRGB(255,100,100)) end
		return
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		if notify then notify("❌ Humanoid not found", Color3.fromRGB(255,100,100)) end
		return
	end

	-- Detect R15
	local isR15 = char:FindFirstChild("UpperTorso") ~= nil
	local animId = isR15 and "rbxassetid://5918726674" or "rbxassetid://148840371"

	local speed = tonumber(args[2]) or 3

	_G._bangData.anim = Instance.new("Animation")
	_G._bangData.anim.AnimationId = animId
	_G._bangData.track = hum:LoadAnimation(_G._bangData.anim)
	_G._bangData.track:Play(0.1, 1, 1)
	_G._bangData.track:AdjustSpeed(speed)

	-- Stop on death
	_G._bangData.diedConn = hum.Died:Connect(function()
		_G.StopBang()
	end)

	-- Target lock
	local targetPlr = nil
	if args[1] then
		local targetName = args[1]:lower()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:lower():sub(1, #targetName) == targetName or plr.DisplayName:lower():sub(1, #targetName) == targetName then
				targetPlr = plr
				break
			end
		end
	end

	_G._bangData.target = targetPlr

	if targetPlr and targetPlr.Character then
		local offset = CFrame.new(0, 0, 1.1)
		_G._bangData.steppedConn = RunService.Stepped:Connect(function()
			pcall(function()
				local myChar = client.Character
				local theirChar = targetPlr.Character
				if not myChar or not theirChar then return end
				local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso")
				local theirRoot = theirChar:FindFirstChild("HumanoidRootPart") or theirChar:FindFirstChild("Torso")
				if myRoot and theirRoot then
					myRoot.CFrame = theirRoot.CFrame * offset
				end
			end)
		end)
		if notify then
			notify("Banging " .. targetPlr.Name .. " at speed " .. speed, Color3.fromRGB(255, 100, 200))
		end
	else
		if notify then
			notify("Bang started (no target) at speed " .. speed, Color3.fromRGB(255, 100, 200))
		end
	end
end

function _G.StopBang()
	pcall(function()
		if _G._bangData.steppedConn then _G._bangData.steppedConn:Disconnect() end
		if _G._bangData.track then _G._bangData.track:Stop() end
		if _G._bangData.anim then _G._bangData.anim:Destroy() end
		if _G._bangData.diedConn then _G._bangData.diedConn:Disconnect() end
	end)
	_G._bangData = {anim = nil, track = nil, diedConn = nil, steppedConn = nil, target = nil}
	if notify then
		notify("Bang stopped", Color3.fromRGB(100, 255, 150))
	end
end
-- =================== END BANG / UNBANG ===================
-- ═══════════════════════════════════════════════════════════
-- mm2 esp
-- ═══════════════════════════════════════════════════════════
MM2ESP = {
	ESP_Enabled = true,
	IsMinimized = false,
	IsClosed = false,
	Dragging = false,
	DragOffset = Vector2.new(0, 0),
	ESPs = {},
	panel = nil,
	mainFrame = nil,
	shadow = nil,
	content = nil,
	contentLayout = nil,
	heartbeatConn = nil,
	speedConn = nil,
	isMobile = false,
	-- NEW: Gun drop features
	GunDrop_AutoTP = false,
	GunDrop_Connection = nil,
	-- NEW: Speed boost
	SpeedBoost_Enabled = false,
	-- UI refs stored on table
	minBtn = nil,
	closeBtn = nil,
	topBar = nil,
	-- Dimensions
	W = 260,
	TOP_H = 36,
	TOG_H = 44,
	PAD = 12,
	SPACING = 6
}

-- Detect mobile
MM2ESP.isMobile = UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or workspace.CurrentCamera.ViewportSize.X < 700)
if MM2ESP.isMobile then
	MM2ESP.W = 220
	MM2ESP.TOP_H = 32
	MM2ESP.TOG_H = 38
	MM2ESP.PAD = 8
	MM2ESP.SPACING = 4
end

-- Colors (stored on module)
MM2ESP.COL_MURDERER = Color3.fromRGB(255, 0, 0)
MM2ESP.COL_SHERIFF = Color3.fromRGB(0, 120, 255)
MM2ESP.COL_INNOCENT = Color3.fromRGB(0, 255, 80)
MM2ESP.COL_BG = Color3.fromRGB(25, 25, 30)
MM2ESP.COL_TOP = Color3.fromRGB(35, 35, 42)
MM2ESP.COL_TEXT = Color3.fromRGB(230, 230, 230)
MM2ESP.COL_SUB = Color3.fromRGB(150, 150, 160)
MM2ESP.COL_ACCENT = Color3.fromRGB(100, 80, 220)
MM2ESP.COL_OFF = Color3.fromRGB(60, 60, 70)
MM2ESP.COL_BTN = Color3.fromRGB(40, 40, 48)

function MM2ESP:GetRole(player)
	local char = player.Character
	if not char then return "Innocent" end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health <= 0 then return "Innocent" end
	local bp = player:FindFirstChild("Backpack")
	if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
	if char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
	return "Innocent"
end

function MM2ESP:GetRoleColor(role)
	if role == "Murderer" then return self.COL_MURDERER end
	if role == "Sheriff" then return self.COL_SHERIFF end
	return self.COL_INNOCENT
end

function MM2ESP:CreateESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if self.ESPs[player] then
		self.ESPs[player]:Destroy()
		self.ESPs[player] = nil
	end
	if not self.ESP_Enabled then return end
	local hl = Instance.new("Highlight")
	hl.Name = "MM2ESP"
	hl.FillColor = self:GetRoleColor(self:GetRole(player))
	hl.OutlineColor = hl.FillColor
	hl.FillTransparency = 0.6
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = player.Character
	self.ESPs[player] = hl
end

function MM2ESP:RemoveESP(player)
	if self.ESPs[player] then
		self.ESPs[player]:Destroy()
		self.ESPs[player] = nil
	end
end

function MM2ESP:UpdateAllESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local cur = player.Character:FindFirstChild("MM2ESP")
			local expected = self:GetRoleColor(self:GetRole(player))
			if not cur or cur.FillColor ~= expected then
				self:CreateESP(player)
			end
		end
	end
end

-- ═══════════════════════════════════════════════════════════
-- FIXED: Speed Boost with persistent connection
-- ═══════════════════════════════════════════════════════════
function MM2ESP:SetupSpeedBoostLoop()
	-- Disconnect old connection if exists
	if self.speedConn then
		self.speedConn:Disconnect()
		self.speedConn = nil
	end

	if not self.SpeedBoost_Enabled then return end

	self.speedConn = RunService.Heartbeat:Connect(function()
		if not self.SpeedBoost_Enabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and hum.WalkSpeed < 30 then
			hum.WalkSpeed = 30
		end
	end)
end

function MM2ESP:ToggleSpeedBoost(state)
	self.SpeedBoost_Enabled = state

	-- Apply immediately
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = state and 30 or 16
		end
	end

	-- Setup persistent loop
	self:SetupSpeedBoostLoop()

	-- Also listen for character respawn to reapply
	if state then
		if self.charAddedConn then self.charAddedConn:Disconnect() end
		self.charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.3)
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and self.SpeedBoost_Enabled then
				hum.WalkSpeed = 30
			end
		end)
	else
		if self.charAddedConn then
			self.charAddedConn:Disconnect()
			self.charAddedConn = nil
		end
	end

	if notify then
		notify(state and "Speed boost ON (30)" or "Speed boost OFF", state and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 100, 100))
	end
end

-- ═══════════════════════════════════════════════════════════
-- FIXED: Gun Drop Features
-- ═══════════════════════════════════════════════════════════
function MM2ESP:FindGunDrop()
	-- GunDrop can be in workspace directly or in a folder
	local gunDrop = workspace:FindFirstChild("GunDrop")
	if gunDrop then return gunDrop end

	-- Check common locations
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "GunDrop" then
			return child
		end
		-- Sometimes it's nested
		if child:IsA("Folder") or child:IsA("Model") then
			local nested = child:FindFirstChild("GunDrop")
			if nested then return nested end
		end
	end

	return nil
end

function MM2ESP:TeleportToGunDrop()
	local gunDrop = self:FindGunDrop()
	if not gunDrop then
		if notify then notify("No gun drop found!", Color3.fromRGB(255, 100, 100)) end
		return
	end

	local myChar = LocalPlayer.Character
	if not myChar then 
		if notify then notify("Character not loaded!", Color3.fromRGB(255, 100, 100)) end
		return 
	end

	local myHrp = myChar:FindFirstChild("HumanoidRootPart")
	if not myHrp then
		if notify then notify("HumanoidRootPart not found!", Color3.fromRGB(255, 100, 100)) end
		return
	end

	-- Use CFrame for reliable teleport
	myHrp.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, 3, 0))
	if notify then notify("Teleported to gun drop!", Color3.fromRGB(100, 255, 100)) end
end

function MM2ESP:SetupGunDropAutoTP()
	-- Disconnect old connection
	if self.GunDrop_Connection then
		self.GunDrop_Connection:Disconnect()
		self.GunDrop_Connection = nil
	end

	if not self.GunDrop_AutoTP then return end

	-- Check if gun drop already exists
	local existingGun = self:FindGunDrop()
	if existingGun then
		task.spawn(function()
			task.wait(0.5)
			if self.GunDrop_AutoTP and self:FindGunDrop() then
				self:TeleportToGunDrop()
			end
		end)
	end

	-- Listen for new gun drops
	self.GunDrop_Connection = workspace.ChildAdded:Connect(function(child)
		if child.Name == "GunDrop" then
			task.wait(0.3)
			if self.GunDrop_AutoTP then
				self:TeleportToGunDrop()
			end
		end
	end)
end

function MM2ESP:ToggleGunDropAutoTP(state)
	self.GunDrop_AutoTP = state
	self:SetupGunDropAutoTP()
	if notify then
		notify(state and "Auto TP to Gun: ON" or "Auto TP to Gun: OFF", state and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 100, 100))
	end
end

function MM2ESP:UpdateHeight()
	if self.IsMinimized then
		TweenService:Create(self.mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, self.W, 0, self.TOP_H)
		}):Play()
		TweenService:Create(self.shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, self.W + 8, 0, self.TOP_H + 8)
		}):Play()
	else
		local contentHeight = self.contentLayout.AbsoluteContentSize.Y + self.PAD * 2
		local totalHeight = self.TOP_H + contentHeight
		TweenService:Create(self.mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, self.W, 0, totalHeight)
		}):Play()
		TweenService:Create(self.shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, self.W + 8, 0, totalHeight + 8)
		}):Play()
	end
end

function MM2ESP:OnPlayerAdded(player)
	if player == LocalPlayer then return end
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		self:CreateESP(player)
	end)
	player.CharacterRemoving:Connect(function()
		self:RemoveESP(player)
	end)
	if player.Character then
		task.wait(0.5)
		self:CreateESP(player)
	end
end

function MM2ESP:Cleanup()
	if self.panel then self.panel:Destroy() end
	if self.heartbeatConn then self.heartbeatConn:Disconnect() end
	if self.speedConn then self.speedConn:Disconnect() end
	if self.charAddedConn then self.charAddedConn:Disconnect() end
	if self.GunDrop_Connection then self.GunDrop_Connection:Disconnect() end
	for player, _ in pairs(self.ESPs) do
		self:RemoveESP(player)
	end
	self.ESPs = {}
	self.ESP_Enabled = true
	self.IsMinimized = false
	self.IsClosed = false
	self.Dragging = false
	self.GunDrop_AutoTP = false
	self.SpeedBoost_Enabled = false
end

-- ═══════════════════════════════════════════════════════════
-- GUI SUB-FUNCTIONS
-- ═══════════════════════════════════════════════════════════

function MM2ESP:CreateMainFrame()
	local mGui = Instance.new("ScreenGui")
	mGui.Name = "MM2ESP_GUI"
	mGui.ResetOnSpawn = false
	mGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local ok = pcall(function()
		mGui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		mGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	self.panel = mGui

	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(0, self.W + 8, 0, 200)
	shadow.Position = UDim2.new(0, 50, 0, 50)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.7
	shadow.BorderSizePixel = 0
	shadow.Parent = mGui
	self.shadow = shadow
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

	local main = Instance.new("Frame")
	main.Name = "MainPanel"
	main.Size = UDim2.new(0, self.W, 0, 200)
	main.Position = UDim2.new(0, 4, 0, 4)
	main.BackgroundColor3 = self.COL_BG
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = shadow
	self.mainFrame = main
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
end

function MM2ESP:CreateTopBar()
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, self.TOP_H)
	topBar.BackgroundColor3 = self.COL_TOP
	topBar.BorderSizePixel = 0
	topBar.Parent = self.mainFrame
	Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)
	self.topBar = topBar

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.new(0, 14, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "MM2 ESP"
	title.TextColor3 = self.COL_TEXT
	title.TextSize = self.isMobile and 14 or 16
	title.Font = Enum.Font.Code
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = topBar

	local minBtn = Instance.new("TextButton")
	minBtn.Name = "Minimize"
	minBtn.Size = UDim2.new(0, 28, 0, 28)
	minBtn.Position = UDim2.new(1, -66, 0.5, -14)
	minBtn.BackgroundColor3 = self.COL_OFF
	minBtn.Text = "−"
	minBtn.TextColor3 = self.COL_TEXT
	minBtn.TextSize = 18
	minBtn.Font = Enum.Font.Code
	minBtn.BorderSizePixel = 0
	minBtn.Parent = topBar
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
	self.minBtn = minBtn

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeBtn.Text = "×"
	closeBtn.TextColor3 = self.COL_TEXT
	closeBtn.TextSize = 18
	closeBtn.Font = Enum.Font.Code
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = topBar
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
	self.closeBtn = closeBtn
end

function MM2ESP:CreateContentArea()
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -self.TOP_H)
	content.Position = UDim2.new(0, 0, 0, self.TOP_H)
	content.BackgroundTransparency = 1
	content.Parent = self.mainFrame
	self.content = content

	local cPad = Instance.new("UIPadding")
	cPad.PaddingLeft = UDim.new(0, self.PAD)
	cPad.PaddingRight = UDim.new(0, self.PAD)
	cPad.PaddingTop = UDim.new(0, self.PAD)
	cPad.PaddingBottom = UDim.new(0, self.PAD)
	cPad.Parent = content

	local cLayout = Instance.new("UIListLayout")
	cLayout.SortOrder = Enum.SortOrder.LayoutOrder
	cLayout.Padding = UDim.new(0, self.SPACING)
	cLayout.Parent = content
	self.contentLayout = cLayout
end

function MM2ESP:MakeToggle(name, label, defaultState, onToggle)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Toggle"
	frame.Size = UDim2.new(1, 0, 0, self.TOG_H)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	frame.BorderSizePixel = 0
	frame.Parent = self.content
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	local lbl = Instance.new("TextLabel")
	lbl.Name = "Label"
	lbl.Size = UDim2.new(1, -70, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.TextColor3 = self.COL_TEXT
	lbl.TextSize = self.isMobile and 12 or 14
	lbl.Font = Enum.Font.Code
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = frame

	local status = Instance.new("TextLabel")
	status.Name = "Status"
	status.Size = UDim2.new(0, 40, 0, 20)
	status.Position = UDim2.new(1, -54, 0.5, -10)
	status.BackgroundTransparency = 1
	status.Text = defaultState and "ON" or "OFF"
	status.TextColor3 = defaultState and self.COL_ACCENT or self.COL_SUB
	status.TextSize = 11
	status.Font = Enum.Font.Code
	status.Parent = frame

	local switch = Instance.new("Frame")
	switch.Name = "Switch"
	switch.Size = UDim2.new(0, 44, 0, 24)
	switch.Position = UDim2.new(1, -56, 0.5, -12)
	switch.BackgroundColor3 = defaultState and self.COL_ACCENT or self.COL_OFF
	switch.BorderSizePixel = 0
	switch.Parent = frame
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = defaultState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local clickArea = Instance.new("TextButton")
	clickArea.Name = "ClickArea"
	clickArea.Size = UDim2.new(1, 0, 1, 0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.Parent = frame

	local isOn = defaultState

	local function animate(newState)
		isOn = newState
		TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = newState and self.COL_ACCENT or self.COL_OFF
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = newState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
		status.Text = newState and "ON" or "OFF"
		status.TextColor3 = newState and self.COL_ACCENT or self.COL_SUB
		onToggle(newState)
	end

	clickArea.MouseButton1Click:Connect(function()
		animate(not isOn)
	end)

	clickArea.MouseEnter:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
	end)
	clickArea.MouseLeave:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
	end)

	return {SetState = animate, GetState = function() return isOn end}
end

-- ═══════════════════════════════════════════════════════════
-- FIXED: Gun Drop Section
-- ═══════════════════════════════════════════════════════════
function MM2ESP:CreateGunDropSection()
	local frame = Instance.new("Frame")
	frame.Name = "GunDropSection"
	frame.Size = UDim2.new(1, 0, 0, self.TOG_H + 6)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	frame.BorderSizePixel = 0
	frame.Parent = self.content
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	-- TP Button
	local tpBtn = Instance.new("TextButton")
	tpBtn.Name = "TPBtn"
	tpBtn.Size = UDim2.new(0.48, 0, 0, self.TOG_H - 8)
	tpBtn.Position = UDim2.new(0, 6, 0.5, -(self.TOG_H - 8) / 2)
	tpBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 180)
	tpBtn.Text = "TP to Gun"
	tpBtn.TextColor3 = self.COL_TEXT
	tpBtn.TextSize = self.isMobile and 11 or 13
	tpBtn.Font = Enum.Font.Code
	tpBtn.BorderSizePixel = 0
	tpBtn.Parent = frame
	Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

	tpBtn.MouseButton1Click:Connect(function()
		self:TeleportToGunDrop()
	end)
	tpBtn.MouseEnter:Connect(function()
		TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 80, 220)}):Play()
	end)
	tpBtn.MouseLeave:Connect(function()
		TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 60, 180)}):Play()
	end)

	-- Auto TP Label
	local autoLbl = Instance.new("TextLabel")
	autoLbl.Name = "AutoLabel"
	autoLbl.Size = UDim2.new(0.22, 0, 0, 20)
	autoLbl.Position = UDim2.new(0.52, 4, 0.5, -10)
	autoLbl.BackgroundTransparency = 1
	autoLbl.Text = "Auto:"
	autoLbl.TextColor3 = self.COL_SUB
	autoLbl.TextSize = self.isMobile and 10 or 12
	autoLbl.Font = Enum.Font.Code
	autoLbl.TextXAlignment = Enum.TextXAlignment.Left
	autoLbl.Parent = frame

	-- Auto TP Switch
	local switch = Instance.new("Frame")
	switch.Name = "AutoSwitch"
	switch.Size = UDim2.new(0, 36, 0, 20)
	switch.Position = UDim2.new(1, -42, 0.5, -10)
	switch.BackgroundColor3 = self.COL_OFF
	switch.BorderSizePixel = 0
	switch.Parent = frame
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local clickArea = Instance.new("TextButton")
	clickArea.Name = "ClickArea"
	clickArea.Size = UDim2.new(1, 0, 1, 0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.Parent = frame

	local isOn = false
	clickArea.MouseButton1Click:Connect(function()
		isOn = not isOn
		TweenService:Create(switch, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = isOn and self.COL_ACCENT or self.COL_OFF
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = isOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		}):Play()
		self:ToggleGunDropAutoTP(isOn)
	end)
end

function MM2ESP:CreateLegend()
	local div = Instance.new("Frame")
	div.Name = "Divider"
	div.Size = UDim2.new(1, 0, 0, 1)
	div.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	div.BorderSizePixel = 0
	div.Parent = self.content

	local legend = Instance.new("Frame")
	legend.Name = "Legend"
	legend.Size = UDim2.new(1, 0, 0, 80)
	legend.BackgroundTransparency = 1
	legend.Parent = self.content

	local legLayout = Instance.new("UIListLayout")
	legLayout.SortOrder = Enum.SortOrder.LayoutOrder
	legLayout.Padding = UDim.new(0, 6)
	legLayout.Parent = legend

	local function makeLegend(text, color)
		local item = Instance.new("Frame")
		item.Size = UDim2.new(1, 0, 0, 20)
		item.BackgroundTransparency = 1
		item.Parent = legend

		local dot = Instance.new("Frame")
		dot.Size = UDim2.new(0, 10, 0, 10)
		dot.Position = UDim2.new(0, 4, 0.5, -5)
		dot.BackgroundColor3 = color
		dot.BorderSizePixel = 0
		dot.Parent = item
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -24, 1, 0)
		lbl.Position = UDim2.new(0, 22, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = text
		lbl.TextColor3 = self.COL_SUB
		lbl.TextSize = 12
		lbl.Font = Enum.Font.Code
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = item
	end

	makeLegend("Murderer — Red", self.COL_MURDERER)
	makeLegend("Sheriff — Blue", self.COL_SHERIFF)
	makeLegend("Innocent — Green", self.COL_INNOCENT)
end

function MM2ESP:SetupDragging()
	local dragStart = nil
	local startPos = nil
	self.topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = true
			dragStart = input.Position
			startPos = self.shadow.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					self.Dragging = false
					dragStart = nil
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			self.shadow.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
		end
	end)
end

function MM2ESP:SetupButtons()
	self.minBtn.MouseButton1Click:Connect(function()
		self.IsMinimized = not self.IsMinimized
		self.minBtn.Text = self.IsMinimized and "+" or "−"
		self:UpdateHeight()
	end)
	self.minBtn.MouseEnter:Connect(function()
		TweenService:Create(self.minBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
	end)
	self.minBtn.MouseLeave:Connect(function()
		TweenService:Create(self.minBtn, TweenInfo.new(0.15), {BackgroundColor3 = self.COL_OFF}):Play()
	end)

	self.closeBtn.MouseButton1Click:Connect(function()
		self.IsClosed = true
		TweenService:Create(self.shadow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(self.mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		for _, child in ipairs(self.mainFrame:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			elseif child:IsA("Frame") and child ~= self.mainFrame and child ~= self.topBar then
				TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			end
		end
		task.delay(0.35, function()
			self.panel.Enabled = false
		end)
	end)
	self.closeBtn.MouseEnter:Connect(function()
		TweenService:Create(self.closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play()
	end)
	self.closeBtn.MouseLeave:Connect(function()
		TweenService:Create(self.closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
	end)
end

function MM2ESP:SetupPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayerAdded(player)
	end
	Players.PlayerAdded:Connect(function(player) self:OnPlayerAdded(player) end)
	Players.PlayerRemoving:Connect(function(player)
		self:RemoveESP(player)
	end)
end

function MM2ESP:SetupLoop()
	self.heartbeatConn = RunService.Heartbeat:Connect(function()
		if self.IsClosed then return end
		if self.ESP_Enabled then self:UpdateAllESP() end
	end)
end
-- ═══════════════════════════════════════════════════════════
-- Anti-lag
-- ═══════════════════════════════════════════════════════════

_G.AntiLagActive = false
_G.AntiLagOriginals = {
	Lighting = {},
	Parts = {},
	Textures = {},
	Graphics = {},
}

-- Helper: recursively collect all descendants
local function getAllDescendants(parent)
	local list = {}
	for _, v in ipairs(parent:GetDescendants()) do
		table.insert(list, v)
	end
	return list
end

_G.StartAntiLag = function()
	if _G.AntiLagActive then return end
	_G.AntiLagActive = true

	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	local Settings = UserSettings():GetService("UserGameSettings")

	-- 1) Save & strip Lighting
	local lightSave = {}
	for _, prop in ipairs({"FogStart","FogEnd","FogColor","Brightness","GlobalShadows","ShadowSoftness","EnvironmentDiffuseScale","EnvironmentSpecularScale","OutdoorAmbient","Ambient","ClockTime","GeographicLatitude"}) do
		local ok, val = pcall(function() return Lighting[prop] end)
		if ok then
			lightSave[prop] = val
			pcall(function() Lighting[prop] = (prop == "FogStart" and 0 or prop == "FogEnd" and 9e9 or prop == "FogColor" and Color3.new(0,0,0) or prop == "Brightness" and 1 or prop == "GlobalShadows" and false or prop == "ShadowSoftness" and 0 or prop == "EnvironmentDiffuseScale" and 0 or prop == "EnvironmentSpecularScale" and 0 or prop == "OutdoorAmbient" and Color3.new(1,1,1) or prop == "Ambient" and Color3.new(1,1,1) or prop == "ClockTime" and 12 or prop == "GeographicLatitude" and 0) end)
		end
	end
	_G.AntiLagOriginals.Lighting = lightSave

	-- Remove atmosphere / blur / color correction / bloom effects
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("Atmosphere") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
			effect.Enabled = false
		end
	end

	-- 2) Save & lower graphics
	local okGfx, savedGfx = pcall(function()
		return {
			SavedQualityLevel = Settings.SavedQualityLevel,
			MasterVolume = Settings.MasterVolume,
		}
	end)
	if okGfx then
		_G.AntiLagOriginals.Graphics = savedGfx
		pcall(function() Settings.SavedQualityLevel = 1 end) -- lowest quality
	end

	-- 3) Save & strip Workspace parts
	local partSave = {}
	local texSave = {}
	for _, obj in ipairs(getAllDescendants(Workspace)) do
		-- Materials
		if obj:IsA("BasePart") and not obj:IsA("Terrain") then
			partSave[obj] = obj.Material
			pcall(function() obj.Material = Enum.Material.SmoothPlastic end)
			pcall(function() obj.Reflectance = 0 end)
			-- Optional: make everything same color so no texture cost
			-- pcall(function() obj.Color = Color3.fromRGB(163,162,165) end)
		end

		-- Textures / Decals / SurfaceGuis / ParticleEmitters
		if obj:IsA("Texture") or obj:IsA("Decal") then
			texSave[obj] = obj.Transparency
			pcall(function() obj.Transparency = 1 end)
		elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
			texSave[obj] = obj.Enabled
			pcall(function() obj.Enabled = false end)
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
			texSave[obj] = obj.Enabled
			pcall(function() obj.Enabled = false end)
		elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			texSave[obj] = obj.Enabled
			pcall(function() obj.Enabled = false end)
		elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
			texSave[obj] = obj.Enabled
			pcall(function() obj.Enabled = false end)
		elseif obj:IsA("MeshPart") then
			-- Some MeshParts have TextureID
			if obj.TextureID and obj.TextureID ~= "" then
				texSave[obj] = obj.TextureID
				pcall(function() obj.TextureID = "" end)
			end
		end
	end
	_G.AntiLagOriginals.Parts = partSave
	_G.AntiLagOriginals.Textures = texSave

	-- 4) Terrain
	pcall(function()
		_G.AntiLagOriginals.TerrainMaterial = Workspace.Terrain.Material
		Workspace.Terrain.Material = Enum.Material.Air -- visually clears terrain (restores on unantilag)
	end)
	pcall(function()
		Workspace.Terrain.WaterReflectance = 0
		Workspace.Terrain.WaterTransparency = 1
		Workspace.Terrain.WaterWaveSize = 0
		Workspace.Terrain.WaterWaveSpeed = 0
	end)

	-- 5) Sky (disable custom sky)
	for _, sky in ipairs(Lighting:GetChildren()) do
		if sky:IsA("Sky") then
			sky.Parent = nil -- hide, don't destroy
			_G.AntiLagOriginals.Sky = sky
			break
		end
	end

	-- Notify
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "AntiLag",
		Text = "FPS mode enabled. Textures & effects removed.",
		Duration = 3
	})
end

_G.StopAntiLag = function()
	if not _G.AntiLagActive then return end
	_G.AntiLagActive = false

	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	local Settings = UserSettings():GetService("UserGameSettings")

	-- 1) Restore Lighting
	for prop, val in pairs(_G.AntiLagOriginals.Lighting) do
		pcall(function() Lighting[prop] = val end)
	end
	-- Re-enable effects
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("Atmosphere") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
			effect.Enabled = true
		end
	end

	-- 2) Restore graphics
	if _G.AntiLagOriginals.Graphics.SavedQualityLevel then
		pcall(function() Settings.SavedQualityLevel = _G.AntiLagOriginals.Graphics.SavedQualityLevel end)
	end

	-- 3) Restore parts
	for part, mat in pairs(_G.AntiLagOriginals.Parts) do
		if part and part.Parent then
			pcall(function() part.Material = mat end)
		end
	end

	-- 4) Restore textures / decals / guis / particles / lights
	for obj, original in pairs(_G.AntiLagOriginals.Textures) do
		if obj and obj.Parent then
			if obj:IsA("Texture") or obj:IsA("Decal") then
				pcall(function() obj.Transparency = original end)
			elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
				pcall(function() obj.Enabled = original end)
			elseif obj:IsA("MeshPart") then
				pcall(function() obj.TextureID = original end)
			end
		end
	end

	-- 5) Restore Terrain
	pcall(function()
		if _G.AntiLagOriginals.TerrainMaterial then
			Workspace.Terrain.Material = _G.AntiLagOriginals.TerrainMaterial
		end
	end)

	-- 6) Restore Sky
	if _G.AntiLagOriginals.Sky then
		_G.AntiLagOriginals.Sky.Parent = Lighting
	end

	-- Clear saved state
	_G.AntiLagOriginals = { Lighting = {}, Parts = {}, Textures = {}, Graphics = {} }

	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "AntiLag",
		Text = "Settings restored.",
		Duration = 3
	})
end
-- ═══════════════════════════════════════════════════════════
-- MAIN OPEN FUNCTION
-- ═══════════════════════════════════════════════════════════

function MM2ESP:Open()
	self:Cleanup()
	self:CreateMainFrame()
	self:CreateTopBar()
	self:CreateContentArea()

	self.espToggle = self:MakeToggle("ESP", "ESP", true, function(state)
		self:ToggleESP(state)
	end)

	-- NEW: Speed Boost Toggle
	self.speedToggle = self:MakeToggle("Speed", "Speed Boost (30)", false, function(state)
		self:ToggleSpeedBoost(state)
	end)

	-- NEW: Gun Drop Section
	self:CreateGunDropSection()

	self:CreateLegend()

	self.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:UpdateHeight()
	end)
	self:UpdateHeight()

	self:SetupDragging()
	self:SetupButtons()
	self:SetupPlayers()
	self:SetupLoop()
end

-- ═══════════════════════════════════════════════════════════
-- COMMAND ENTRY POINT
-- ═══════════════════════════════════════════════════════════
function openmm2esp()
	MM2ESP:Open()
end
-- ============================================
-- AUTOEXEC COMMANDS
-- ============================================
-- work in process or smt :3
-- ============================================
-- Volume changer 
-- ============================================
local function Volume(plr, args)
	local vol = tonumber(args[1])
	if not vol then
		notify("Usage: !volume <0-10>", Color3.fromRGB(255, 100, 100))
		return
	end
	
	vol = math.clamp(vol, 0, 10)
	local scale = vol / 10
	
	-- Set all currently playing sounds in workspace
	for _, sound in ipairs(workspace:GetDescendants()) do
		if sound:IsA("Sound") then
			sound.Volume = scale
		end
	end
	
	-- Set all sounds in SoundService
	for _, sound in ipairs(game:GetService("SoundService"):GetDescendants()) do
		if sound:IsA("Sound") then
			sound.Volume = scale
		end
	end
	
	-- Set all sounds in ReplicatedStorage
	for _, sound in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		if sound:IsA("Sound") then
			sound.Volume = scale
		end
	end
	
	-- Hook new sounds so they also get scaled
	if not _G.volumeScale then
		_G.volumeScale = scale
		
		workspace.DescendantAdded:Connect(function(desc)
			if desc:IsA("Sound") then
				task.wait()
				desc.Volume = _G.volumeScale
			end
		end)
		
		game:GetService("SoundService").DescendantAdded:Connect(function(desc)
			if desc:IsA("Sound") then
				task.wait()
				desc.Volume = _G.volumeScale
			end
		end)
	else
		_G.volumeScale = scale
	end
	
	notify("Volume: " .. vol .. "/10", currentTheme.accent)
end

-- ============================================
-- rejoin
-- ============================================
local function rejoin(plr, args)
	if plr ~= client then
		notify("❌ Rejoin only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	notify("🔄 Rejoining...", Color3.fromRGB(100, 200, 255))

	local placeId = game.PlaceId

	-- Use the SAME bypass method as serverhop: reserved server
	-- This creates a fresh server slot that bypasses private restrictions
	local ok, err = pcall(function()
		local accessCode = TeleportService:ReserveServer(placeId)
		TeleportService:TeleportToPrivateServer(placeId, accessCode, {plr})
	end)

	if not ok then
		-- Fallback: normal teleport (may land in public server)
		local ok2, err2 = pcall(function()
			TeleportService:Teleport(placeId, plr)
		end)

		if not ok2 then
			notify("❌ Rejoin failed: " .. tostring(err2), Color3.fromRGB(255, 100, 100))
		end
	end
end
-- ============================================
-- serverhop
-- ============================================
local function serverhop(plr, args)
	if plr ~= client then
		notify("❌ Serverhop only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	notify("🚀 Finding different public server...", Color3.fromRGB(100, 255, 150))

	local placeId = game.PlaceId
	local currentJobId = game.JobId

	-- Try 1: Use TeleportOptions to force public server (ignores friends/reserved)
	local ok, err = pcall(function()
		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ShouldReserveServer = false
		teleportOptions.ServerInstanceId = nil
		TeleportService:Teleport(placeId, plr, teleportOptions)
	end)

	if not ok then
		-- Try 2: Fallback using ReserveServer with delay to ensure different instance
		local ok2, err2 = pcall(function()
			local accessCode = TeleportService:ReserveServer(placeId)
			task.wait(0.1)
			TeleportService:TeleportToPrivateServer(placeId, accessCode, {plr})
		end)

		if not ok2 then
			-- Try 3: Force teleport with random seed
			local ok3, err3 = pcall(function()
				TeleportService:SetTeleportSetting("serverhop_seed", tostring(tick()))
				TeleportService:Teleport(placeId, plr)
			end)

			if not ok3 then
				notify("❌ Serverhop failed: " .. tostring(err3), Color3.fromRGB(255, 100, 100))
			end
		end
	end
end
-- ============================================
-- BOOMBOX SYSTEM - Ultra low local count
-- ============================================

do
	
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

	local player = Players.LocalPlayer
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local scale = isMobile and 0.65 or 1

	_G.Boombox = _G.Boombox or {gui = {}, sound = nil, playing = false, looping = false, duration = 0, dragging = false, conn = nil, history = {}}
	local BB = _G.Boombox

	-- Reuse single element reference for ALL Instance creation
	local e

	local function fmtTime(sec)
		sec = math.floor(sec or 0)
		return string.format("%d:%02d", math.floor(sec / 60), sec % 60)
	end

	local function getInfo(id)
		local ok, data = pcall(function()
			return MarketplaceService:GetProductInfo(tonumber(id), Enum.InfoType.Asset)
		end)
		if ok and data then
			return data.Name or "Unknown", data.Creator and data.Creator.Name or "Unknown"
		end
		return "Unknown", "Unknown"
	end

	local function updatePlayBtn()
		if not BB.gui.playBtn then return end
		if BB.playing then
			BB.gui.playBtn.Text = "PAUSE"
			BB.gui.playBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		else
			BB.gui.playBtn.Text = "PLAY"
			BB.gui.playBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		end
	end

	local function updateLoopBtn()
		if not BB.gui.loopBtn then return end
		if BB.looping then
			BB.gui.loopBtn.Text = "LOOP ON"
			BB.gui.loopBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
			BB.gui.loopBtn.TextColor3 = Color3.fromRGB(30, 30, 35)
		else
			BB.gui.loopBtn.Text = "LOOP OFF"
			BB.gui.loopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			BB.gui.loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end

	local function playSong(id)
		id = tostring(id):gsub("%D", "")
		if id == "" then return end

		if BB.sound then
			BB.sound:Stop()
			BB.sound:Destroy()
			BB.sound = nil
		end
		if BB.conn then
			BB.conn:Disconnect()
			BB.conn = nil
		end

		BB.playing = false
		updatePlayBtn()
		if BB.gui.progFill then BB.gui.progFill.Size = UDim2.new(0, 0, 1, 0) end
		if BB.gui.curTime then BB.gui.curTime.Text = "0:00" end
		if BB.gui.totTime then BB.gui.totTime.Text = "0:00" end

		local name, artist = getInfo(id)
		if BB.gui.songName then BB.gui.songName.Text = name end
		if BB.gui.artistName then BB.gui.artistName.Text = artist end
		if BB.gui.idBox then BB.gui.idBox.Text = id end

		local exists = false
		for _, h in ipairs(BB.history) do
			if h.id == id then exists = true break end
		end
		if not exists then
			table.insert(BB.history, 1, {id = id, name = name})
			if #BB.history > 20 then table.remove(BB.history, 21) end

			if BB.gui.histFrame then
				e = Instance.new("TextButton")
				e.Size = UDim2.new(1, -10, 0, 32)
				e.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
				e.BorderSizePixel = 0
				e.Text = ""
				e.AutoButtonColor = false
				e.Parent = BB.gui.histFrame

				local nl = Instance.new("TextLabel")
				nl.Size = UDim2.new(1, -60, 1, 0)
				nl.Position = UDim2.new(0, 10, 0, 0)
				nl.BackgroundTransparency = 1
				nl.Text = name
				nl.TextColor3 = Color3.fromRGB(255, 255, 255)
				nl.TextSize = 13
				nl.Font = Enum.Font.Code
				nl.TextXAlignment = Enum.TextXAlignment.Left
				nl.TextTruncate = Enum.TextTruncate.AtEnd
				nl.Parent = e

				local il = Instance.new("TextLabel")
				il.Size = UDim2.new(0, 50, 1, 0)
				il.Position = UDim2.new(1, -55, 0, 0)
				il.BackgroundTransparency = 1
				il.Text = id
				il.TextColor3 = Color3.fromRGB(180, 180, 180)
				il.TextSize = 11
				il.Font = Enum.Font.Code
				il.TextXAlignment = Enum.TextXAlignment.Right
				il.Parent = e

				e.MouseEnter:Connect(function() e.BackgroundColor3 = Color3.fromRGB(55, 55, 60) end)
				e.MouseLeave:Connect(function() e.BackgroundColor3 = Color3.fromRGB(40, 40, 45) end)
				e.MouseButton1Click:Connect(function() playSong(id) end)

				BB.gui.histFrame.CanvasSize = UDim2.new(0, 0, 0, BB.gui.histList.AbsoluteContentSize.Y)
			end

			local v = player:FindFirstChild("BoomboxHistory")
			if not v then
				v = Instance.new("StringValue")
				v.Name = "BoomboxHistory"
				v.Parent = player
			end
			v.Value = HttpService:JSONEncode(BB.history)
		end

		local snd = Instance.new("Sound")
		snd.SoundId = "rbxassetid://" .. id
		snd.Parent = CoreGui
		snd.Looped = BB.looping
		BB.sound = snd
		BB.duration = 0

		task.spawn(function()
			if not snd.IsLoaded then
				local ok = pcall(function() snd.Loaded:Wait() end)
				if not ok then
					if BB.gui.songName then BB.gui.songName.Text = "Failed to load" end
					return
				end
			end
			BB.duration = snd.TimeLength
			if BB.gui.totTime then BB.gui.totTime.Text = fmtTime(BB.duration) end
			snd:Play()
			BB.playing = true
			updatePlayBtn()

			BB.conn = RunService.Heartbeat:Connect(function()
				if not BB.sound or not BB.playing or BB.dragging then return end
				local p = BB.duration > 0 and BB.sound.TimePosition / BB.duration or 0
				if BB.gui.progFill then BB.gui.progFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
				if BB.gui.curTime then BB.gui.curTime.Text = fmtTime(BB.sound.TimePosition) end
			end)
		end)

		snd.Ended:Connect(function()
			if not BB.looping then
				BB.playing = false
				updatePlayBtn()
				if BB.gui.progFill then BB.gui.progFill.Size = UDim2.new(0, 0, 1, 0) end
				if BB.gui.curTime then BB.gui.curTime.Text = "0:00" end
			end
		end)
	end

	local function buildGUI()
		if BB.gui.screen then
			BB.gui.main.Visible = true
			return
		end

		local C_BG = Color3.fromRGB(30, 30, 35)
		local C_DARK = Color3.fromRGB(25, 25, 30)
		local C_ACCENT = Color3.fromRGB(173, 216, 230)
		local C_WHITE = Color3.fromRGB(255, 255, 255)
		local C_GRAY = Color3.fromRGB(180, 180, 180)
		local C_SLIDER = Color3.fromRGB(60, 60, 65)
		local C_GREEN = Color3.fromRGB(100, 255, 100)
		local C_RED = Color3.fromRGB(255, 100, 100)
		local C_DGRAY = Color3.fromRGB(50, 50, 55)

		BB.gui.screen = Instance.new("ScreenGui")
		BB.gui.screen.Name = "BoomboxGUI"
		BB.gui.screen.ResetOnSpawn = false
		BB.gui.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		BB.gui.screen.Parent = CoreGui

		e = Instance.new("Frame")
		e.Size = UDim2.new(1, 0, 1, 0)
		e.BackgroundTransparency = 1
		e.Parent = BB.gui.screen

		BB.gui.main = Instance.new("Frame")
		BB.gui.main.Size = UDim2.new(0, 380 * scale, 0, 460 * scale)
		BB.gui.main.Position = UDim2.new(0.5, -190 * scale, 0.5, -230 * scale)
		BB.gui.main.BackgroundColor3 = C_BG
		BB.gui.main.BorderSizePixel = 0
		BB.gui.main.Active = true
		BB.gui.main.Visible = true
		BB.gui.main.Parent = e

		-- Title Bar
		e = Instance.new("Frame")
		e.Name = "TitleBar"
		e.Size = UDim2.new(1, 0, 0, 45 * scale)
		e.BackgroundColor3 = C_DARK
		e.BorderSizePixel = 0
		e.Active = true
		e.Parent = BB.gui.main

		local drag, dragStart, startPos = false, nil, nil
		e.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				drag = true
				dragStart = input.Position
				startPos = BB.gui.main.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local d = input.Position - dragStart
				BB.gui.main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				drag = false
			end
		end)

		e = Instance.new("TextLabel")
		e.Size = UDim2.new(0.6, 0, 1, 0)
		e.Position = UDim2.new(0, 15 * scale, 0, 0)
		e.BackgroundTransparency = 1
		e.Text = "lun4rs boomboxys"
		e.TextColor3 = C_WHITE
		e.TextSize = 18 * scale
		e.Font = Enum.Font.Code
		e.TextXAlignment = Enum.TextXAlignment.Left
		e.Parent = BB.gui.main:FindFirstChild("TitleBar")

		e = Instance.new("TextButton")
		e.Size = UDim2.new(0, 35 * scale, 0, 35 * scale)
		e.Position = UDim2.new(1, -40 * scale, 0, 5 * scale)
		e.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		e.BorderSizePixel = 0
		e.Text = "×"
		e.TextColor3 = C_WHITE
		e.TextSize = 22 * scale
		e.Font = Enum.Font.Code
		e.Parent = BB.gui.main:FindFirstChild("TitleBar")
		e.MouseEnter:Connect(function() e.BackgroundColor3 = C_RED end)
		e.MouseLeave:Connect(function() e.BackgroundColor3 = Color3.fromRGB(40, 40, 45) end)
		e.MouseButton1Click:Connect(function()
			BB.gui.main.Visible = false
			if BB.sound then
				BB.sound:Pause()
				BB.playing = false
				updatePlayBtn()
			end
		end)

		-- Song info
		BB.gui.songName = Instance.new("TextLabel")
		BB.gui.songName.Size = UDim2.new(1, -30 * scale, 0, 28 * scale)
		BB.gui.songName.Position = UDim2.new(0, 15 * scale, 0, 55 * scale)
		BB.gui.songName.BackgroundTransparency = 1
		BB.gui.songName.Text = "No song playing"
		BB.gui.songName.TextColor3 = C_WHITE
		BB.gui.songName.TextSize = 20 * scale
		BB.gui.songName.Font = Enum.Font.Code
		BB.gui.songName.TextXAlignment = Enum.TextXAlignment.Left
		BB.gui.songName.TextTruncate = Enum.TextTruncate.AtEnd
		BB.gui.songName.Parent = BB.gui.main

		BB.gui.artistName = Instance.new("TextLabel")
		BB.gui.artistName.Size = UDim2.new(1, -30 * scale, 0, 18 * scale)
		BB.gui.artistName.Position = UDim2.new(0, 15 * scale, 0, 83 * scale)
		BB.gui.artistName.BackgroundTransparency = 1
		BB.gui.artistName.Text = "Enter a Roblox audio ID"
		BB.gui.artistName.TextColor3 = C_GRAY
		BB.gui.artistName.TextSize = 13 * scale
		BB.gui.artistName.Font = Enum.Font.Code
		BB.gui.artistName.TextXAlignment = Enum.TextXAlignment.Left
		BB.gui.artistName.Parent = BB.gui.main

		BB.gui.curTime = Instance.new("TextLabel")
		BB.gui.curTime.Size = UDim2.new(0, 50 * scale, 0, 18 * scale)
		BB.gui.curTime.Position = UDim2.new(0, 15 * scale, 0, 110 * scale)
		BB.gui.curTime.BackgroundTransparency = 1
		BB.gui.curTime.Text = "0:00"
		BB.gui.curTime.TextColor3 = C_WHITE
		BB.gui.curTime.TextSize = 13 * scale
		BB.gui.curTime.Font = Enum.Font.Code
		BB.gui.curTime.TextXAlignment = Enum.TextXAlignment.Left
		BB.gui.curTime.Parent = BB.gui.main

		BB.gui.totTime = Instance.new("TextLabel")
		BB.gui.totTime.Size = UDim2.new(0, 50 * scale, 0, 18 * scale)
		BB.gui.totTime.Position = UDim2.new(1, -65 * scale, 0, 110 * scale)
		BB.gui.totTime.BackgroundTransparency = 1
		BB.gui.totTime.Text = "0:00"
		BB.gui.totTime.TextColor3 = C_WHITE
		BB.gui.totTime.TextSize = 13 * scale
		BB.gui.totTime.Font = Enum.Font.Code
		BB.gui.totTime.TextXAlignment = Enum.TextXAlignment.Right
		BB.gui.totTime.Parent = BB.gui.main

		-- Progress bar
		local progBg = Instance.new("Frame")
		progBg.Size = UDim2.new(1, -30 * scale, 0, 4 * scale)
		progBg.Position = UDim2.new(0, 15 * scale, 0, 132 * scale)
		progBg.BackgroundColor3 = C_SLIDER
		progBg.BorderSizePixel = 0
		progBg.Parent = BB.gui.main

		BB.gui.progFill = Instance.new("Frame")
		BB.gui.progFill.Size = UDim2.new(0, 0, 1, 0)
		BB.gui.progFill.BackgroundColor3 = C_ACCENT
		BB.gui.progFill.BorderSizePixel = 0
		BB.gui.progFill.Parent = progBg

		local function setSlider(input)
			local rel = math.clamp((input.Position.X - progBg.AbsolutePosition.X) / progBg.AbsoluteSize.X, 0, 1)
			BB.gui.progFill.Size = UDim2.new(rel, 0, 1, 0)
			if BB.sound and BB.sound.IsLoaded then
				BB.sound.TimePosition = rel * BB.duration
				BB.gui.curTime.Text = fmtTime(BB.sound.TimePosition)
			end
		end

		progBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				BB.dragging = true
				setSlider(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if BB.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setSlider(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				BB.dragging = false
			end
		end)

		-- Controls
		local ctrl = Instance.new("Frame")
		ctrl.Size = UDim2.new(1, -30 * scale, 0, 40 * scale)
		ctrl.Position = UDim2.new(0, 15 * scale, 0, 148 * scale)
		ctrl.BackgroundTransparency = 1
		ctrl.Parent = BB.gui.main

		-- Prev
		e = Instance.new("TextButton")
		e.Size = UDim2.new(0, 50 * scale, 0, 30 * scale)
		e.Position = UDim2.new(0, 0, 0, 5 * scale)
		e.BackgroundColor3 = C_DGRAY
		e.BorderSizePixel = 0
		e.Text = "PREV"
		e.TextColor3 = C_WHITE
		e.TextSize = 12 * scale
		e.Font = Enum.Font.Code
		e.Parent = ctrl
		e.MouseEnter:Connect(function() e.BackgroundColor3 = Color3.fromRGB(70, 70, 75) end)
		e.MouseLeave:Connect(function() e.BackgroundColor3 = C_DGRAY end)

		-- Play
		BB.gui.playBtn = Instance.new("TextButton")
		BB.gui.playBtn.Size = UDim2.new(0, 80 * scale, 0, 30 * scale)
		BB.gui.playBtn.Position = UDim2.new(0.5, -40 * scale, 0, 5 * scale)
		BB.gui.playBtn.BackgroundColor3 = C_GREEN
		BB.gui.playBtn.BorderSizePixel = 0
		BB.gui.playBtn.Text = "PLAY"
		BB.gui.playBtn.TextColor3 = C_BG
		BB.gui.playBtn.TextSize = 14 * scale
		BB.gui.playBtn.Font = Enum.Font.Code
		BB.gui.playBtn.Parent = ctrl
		BB.gui.playBtn.MouseEnter:Connect(function()
			if BB.playing then
				BB.gui.playBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
			else
				BB.gui.playBtn.BackgroundColor3 = Color3.fromRGB(120, 255, 120)
			end
		end)
		BB.gui.playBtn.MouseLeave:Connect(function() updatePlayBtn() end)
		BB.gui.playBtn.MouseButton1Click:Connect(function()
			if not BB.sound then return end
			if BB.playing then
				BB.sound:Pause()
				BB.playing = false
			else
				BB.sound:Play()
				BB.playing = true
			end
			updatePlayBtn()
		end)

		-- Next
		e = Instance.new("TextButton")
		e.Size = UDim2.new(0, 50 * scale, 0, 30 * scale)
		e.Position = UDim2.new(1, -50 * scale, 0, 5 * scale)
		e.BackgroundColor3 = C_DGRAY
		e.BorderSizePixel = 0
		e.Text = "NEXT"
		e.TextColor3 = C_WHITE
		e.TextSize = 12 * scale
		e.Font = Enum.Font.Code
		e.Parent = ctrl
		e.MouseEnter:Connect(function() e.BackgroundColor3 = Color3.fromRGB(70, 70, 75) end)
		e.MouseLeave:Connect(function() e.BackgroundColor3 = C_DGRAY end)

		-- Loop
		BB.gui.loopBtn = Instance.new("TextButton")
		BB.gui.loopBtn.Size = UDim2.new(0, 70 * scale, 0, 25 * scale)
		BB.gui.loopBtn.Position = UDim2.new(1, -75 * scale, 0, 42 * scale)
		BB.gui.loopBtn.BackgroundColor3 = C_DGRAY
		BB.gui.loopBtn.BorderSizePixel = 0
		BB.gui.loopBtn.Text = "LOOP OFF"
		BB.gui.loopBtn.TextColor3 = C_WHITE
		BB.gui.loopBtn.TextSize = 11 * scale
		BB.gui.loopBtn.Font = Enum.Font.Code
		BB.gui.loopBtn.Parent = ctrl
		BB.gui.loopBtn.MouseEnter:Connect(function()
			if BB.looping then
				BB.gui.loopBtn.BackgroundColor3 = Color3.fromRGB(120, 255, 120)
			else
				BB.gui.loopBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
			end
		end)
		BB.gui.loopBtn.MouseLeave:Connect(function() updateLoopBtn() end)
		BB.gui.loopBtn.MouseButton1Click:Connect(function()
			BB.looping = not BB.looping
			if BB.sound then BB.sound.Looped = BB.looping end
			updateLoopBtn()
		end)

		-- Volume
		local volFrame = Instance.new("Frame")
		volFrame.Size = UDim2.new(1, -30 * scale, 0, 30 * scale)
		volFrame.Position = UDim2.new(0, 15 * scale, 0, 195 * scale)
		volFrame.BackgroundTransparency = 1
		volFrame.Parent = BB.gui.main

		e = Instance.new("TextLabel")
		e.Size = UDim2.new(0, 50 * scale, 1, 0)
		e.BackgroundTransparency = 1
		e.Text = "VOL"
		e.TextColor3 = C_GRAY
		e.TextSize = 12 * scale
		e.Font = Enum.Font.Code
		e.Parent = volFrame

		local volHit = Instance.new("Frame")
		volHit.Size = UDim2.new(1, -55 * scale, 0, 20 * scale)
		volHit.Position = UDim2.new(0, 45 * scale, 0.5, -10 * scale)
		volHit.BackgroundTransparency = 1
		volHit.Active = true
		volHit.Parent = volFrame

		local volSlider = Instance.new("Frame")
		volSlider.Size = UDim2.new(1, 0, 0, 4 * scale)
		volSlider.Position = UDim2.new(0, 0, 0.5, -2 * scale)
		volSlider.BackgroundColor3 = C_SLIDER
		volSlider.BorderSizePixel = 0
		volSlider.Parent = volHit

		local volFill = Instance.new("Frame")
		volFill.Size = UDim2.new(0.5, 0, 1, 0)
		volFill.BackgroundColor3 = C_ACCENT
		volFill.BorderSizePixel = 0
		volFill.Parent = volSlider

		local volDrag = false
		local function setVol(input)
			local rel = math.clamp((input.Position.X - volHit.AbsolutePosition.X) / volHit.AbsoluteSize.X, 0, 1)
			volFill.Size = UDim2.new(rel, 0, 1, 0)
			if BB.sound then BB.sound.Volume = rel end
		end
		volHit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				volDrag = true
				setVol(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if volDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setVol(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				volDrag = false
			end
		end)

		-- Input
		local inFrame = Instance.new("Frame")
		inFrame.Size = UDim2.new(1, -30 * scale, 0, 35 * scale)
		inFrame.Position = UDim2.new(0, 15 * scale, 0, 235 * scale)
		inFrame.BackgroundColor3 = C_DARK
		inFrame.BorderSizePixel = 0
		inFrame.Parent = BB.gui.main

		BB.gui.idBox = Instance.new("TextBox")
		BB.gui.idBox.Size = UDim2.new(1, -80 * scale, 1, 0)
		BB.gui.idBox.Position = UDim2.new(0, 10 * scale, 0, 0)
		BB.gui.idBox.BackgroundTransparency = 1
		BB.gui.idBox.Text = ""
		BB.gui.idBox.PlaceholderText = "Enter Audio ID..."
		BB.gui.idBox.TextColor3 = C_WHITE
		BB.gui.idBox.PlaceholderColor3 = C_GRAY
		BB.gui.idBox.TextSize = 14 * scale
		BB.gui.idBox.Font = Enum.Font.Code
		BB.gui.idBox.ClearTextOnFocus = false
		BB.gui.idBox.Parent = inFrame

		e = Instance.new("TextButton")
		e.Size = UDim2.new(0, 70 * scale, 1, -4 * scale)
		e.Position = UDim2.new(1, -75 * scale, 0, 2 * scale)
		e.BackgroundColor3 = C_ACCENT
		e.BorderSizePixel = 0
		e.Text = "LOAD"
		e.TextColor3 = C_BG
		e.TextSize = 14 * scale
		e.Font = Enum.Font.Code
		e.Parent = inFrame
		e.MouseButton1Click:Connect(function()
			local cleanId = BB.gui.idBox.Text:gsub("%D", "")
			if cleanId ~= "" then playSong(cleanId) end
		end)
		BB.gui.idBox.FocusLost:Connect(function(entered)
			if entered then
				local cleanId = BB.gui.idBox.Text:gsub("%D", "")
				if cleanId ~= "" then playSong(cleanId) end
			end
		end)

		-- History
		e = Instance.new("TextLabel")
		e.Size = UDim2.new(1, -30 * scale, 0, 20 * scale)
		e.Position = UDim2.new(0, 15 * scale, 0, 280 * scale)
		e.BackgroundTransparency = 1
		e.Text = "RECENTLY PLAYED"
		e.TextColor3 = C_GRAY
		e.TextSize = 12 * scale
		e.Font = Enum.Font.Code
		e.TextXAlignment = Enum.TextXAlignment.Left
		e.Parent = BB.gui.main

		BB.gui.histFrame = Instance.new("ScrollingFrame")
		BB.gui.histFrame.Size = UDim2.new(1, -30 * scale, 0, 140 * scale)
		BB.gui.histFrame.Position = UDim2.new(0, 15 * scale, 0, 305 * scale)
		BB.gui.histFrame.BackgroundColor3 = C_DARK
		BB.gui.histFrame.BorderSizePixel = 0
		BB.gui.histFrame.ScrollBarThickness = 4 * scale
		BB.gui.histFrame.ScrollBarImageColor3 = C_ACCENT
		BB.gui.histFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		BB.gui.histFrame.Parent = BB.gui.main

		BB.gui.histList = Instance.new("UIListLayout")
		BB.gui.histList.SortOrder = Enum.SortOrder.LayoutOrder
		BB.gui.histList.Padding = UDim.new(0, 2 * scale)
		BB.gui.histList.Parent = BB.gui.histFrame

		local ok, saved = pcall(function()
			local v = player:FindFirstChild("BoomboxHistory")
			return v and HttpService:JSONDecode(v.Value) or {}
		end)
		if ok then
			for _, h in ipairs(saved) do
				table.insert(BB.history, h)
			end
		end
	end

	-- Public functions
	function _G.OpenBoombox()
		buildGUI()
	end

	function _G.BoomboxRun(msg)
		local args = {}
		for word in msg:sub(2):gmatch("%S+") do
			table.insert(args, word)
		end
		local cmd = table.remove(args, 1)
		if cmd == "boombox" then
			_G.OpenBoombox()
			if args[1] then
				local id = tostring(args[1]):gsub("%D", "")
				if id ~= "" then
					task.wait(0.1)
					playSong(id)
				end
			end
			return true
		end
		return false
	end

	print("[Boombox] Loaded! Type !boombox or !boombox [id]")
end
-- ============================================
-- Crosshair tingy
-- ============================================
_G.LunarCrosshairData = {
	enabled = false,
	gui = nil,
	connection = nil,
	settings = nil
}

function LoadLunarCrosshair()
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local StarterGui = game:GetService("StarterGui")
	local CoreGui = game:GetService("CoreGui")

	local client = Players.LocalPlayer
	local mouse = client:GetMouse()

	local data = _G.LunarCrosshairData

	if data.enabled and data.gui then
		notify("Crosshair already enabled! Use !uncrosshair to disable", Color3.fromRGB(255, 200, 100))
		return
	end

	if data.gui then
		data.gui:Destroy()
	end
	if data.connection then
		data.connection:Disconnect()
	end

	data.enabled = true

	-- ================= GUI =================
	local gui = Instance.new("ScreenGui")
	gui.Name = "LunarCrosshairCMD"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.DisplayOrder = 2147483647
	gui.ScreenInsets = Enum.ScreenInsets.None
	gui.Parent = CoreGui
	data.gui = gui

	-- Settings
	local settings = {
		VertLength = 16,
		HorzLength = 16,
		Width = 3,
		RotationSpeed = 120,
		RainbowSpeed = 1.5,
		YOffset = 0,
		TextGap = 8,
		Text = "Lunar",
		Symbol = "",
		SpinEnabled = true,
		VFXEnabled = false,
		PulseEnabled = true,
		PulseSpeed = 2,
		PulseDistance = 3,
		ActivePreset = "Classic",
		UseRainbow = true,
		CustomColor = Color3.fromRGB(255, 255, 255),
		ColorR = 255,
		ColorG = 255,
		ColorB = 255,
		VFXType = "Particles",
		VFXIntensity = 5,
		VFXSize = 3,
		VFXTrail = false,
		VFXGlow = false,
		VFXBloom = false,
		VFXSparkle = false,
		VFXRipple = false,
		VFXOrbit = false,
		VFXShootingStar = false,
		VFXHeart = false,
		VFXLightning = false,
		VFXGhost = false,
		VFXConfetti = false,
	}
	data.settings = settings

	-- ================= CROSSHAIR CONTAINER =================
	local center = Instance.new("Frame")
	center.BackgroundTransparency = 1
	center.Size = UDim2.fromOffset(1,1)
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.ZIndex = 2147483647
	center.Parent = gui

	local crosshairSymbol = Instance.new("TextLabel")
	crosshairSymbol.BackgroundTransparency = 1
	crosshairSymbol.Size = UDim2.fromScale(1,1)
	crosshairSymbol.AnchorPoint = Vector2.new(0.5, 0.5)
	crosshairSymbol.Position = UDim2.fromScale(0.5, 0.5)
	crosshairSymbol.TextScaled = false
	crosshairSymbol.Font = Enum.Font.Code
	crosshairSymbol.TextStrokeTransparency = 0.5
	crosshairSymbol.TextStrokeColor3 = Color3.new(0,0,0)
	crosshairSymbol.ZIndex = 2147483647
	crosshairSymbol.Parent = center
	crosshairSymbol.Visible = false

	local crosshairParts = {}

	local function clearCrosshairParts()
		for _, part in pairs(crosshairParts) do
			if part and part.Parent then
				part:Destroy()
			end
		end
		crosshairParts = {}
	end

	local function makeLine(name)
		local f = Instance.new("Frame")
		f.Name = name or "Line"
		f.BorderSizePixel = 0
		f.ZIndex = 2147483647
		f.Parent = center
		table.insert(crosshairParts, f)
		return f
	end

	local text = Instance.new("TextLabel")
	text.Text = settings.Text
	text.Font = Enum.Font.Code
	text.TextSize = 18
	text.BackgroundTransparency = 1
	text.AnchorPoint = Vector2.new(0.5, 0)
	text.ZIndex = 2147483647
	text.TextStrokeTransparency = 0.5
	text.TextStrokeColor3 = Color3.new(0,0,0)
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.Parent = gui

	local function lerp(a, b, t)
		return a + (b - a) * t
	end

	local function smoothColor(c1, c2, t)
		return Color3.new(lerp(c1.R,c2.R,t), lerp(c1.G,c2.G,t), lerp(c1.B,c2.B,t))
	end

	-- ================= PRESETS =================
	local presets = {}

	presets["Classic"] = function()
		clearCrosshairParts()
		local w, len = settings.Width, settings.VertLength
		local halfLen, gap = len / 2, 3
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(w, halfLen - gap)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local bottom = makeLine("Bottom")
		bottom.Size = UDim2.fromOffset(w, halfLen - gap)
		bottom.AnchorPoint = Vector2.new(0.5, 0)
		bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
		bottom:SetAttribute("OriginalPos", bottom.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(halfLen - gap, w)
		left.AnchorPoint = Vector2.new(1, 0.5)
		left.Position = UDim2.new(0.5, -gap, 0.5, 0)
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(halfLen - gap, w)
		right.AnchorPoint = Vector2.new(0, 0.5)
		right.Position = UDim2.new(0.5, gap, 0.5, 0)
		right:SetAttribute("OriginalPos", right.Position)
		return {top, bottom, left, right}
	end

	presets["Dot"] = function()
		clearCrosshairParts()
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(settings.Width + 2, settings.Width + 2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {dot}
	end

	presets["X"] = function()
		clearCrosshairParts()
		local size = math.max(settings.VertLength, settings.HorzLength)
		local w, gap = settings.Width, 4
		local tl = makeLine("TL")
		tl.Size = UDim2.fromOffset(w, size/2 - gap)
		tl.AnchorPoint = Vector2.new(0.5, 1)
		tl.Position = UDim2.new(0.5, -gap, 0.5, -gap)
		tl.Rotation = 45
		tl:SetAttribute("OriginalPos", tl.Position)
		local tr = makeLine("TR")
		tr.Size = UDim2.fromOffset(w, size/2 - gap)
		tr.AnchorPoint = Vector2.new(0.5, 1)
		tr.Position = UDim2.new(0.5, gap, 0.5, -gap)
		tr.Rotation = -45
		tr:SetAttribute("OriginalPos", tr.Position)
		local bl = makeLine("BL")
		bl.Size = UDim2.fromOffset(w, size/2 - gap)
		bl.AnchorPoint = Vector2.new(0.5, 0)
		bl.Position = UDim2.new(0.5, -gap, 0.5, gap)
		bl.Rotation = -45
		bl:SetAttribute("OriginalPos", bl.Position)
		local br = makeLine("BR")
		br.Size = UDim2.fromOffset(w, size/2 - gap)
		br.AnchorPoint = Vector2.new(0.5, 0)
		br.Position = UDim2.new(0.5, gap, 0.5, gap)
		br.Rotation = 45
		br:SetAttribute("OriginalPos", br.Position)
		return {tl, tr, bl, br}
	end

	presets["Plus Dot"] = function()
		clearCrosshairParts()
		local w, len = settings.Width, settings.VertLength
		local halfLen, gap = len / 2, 3
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(w, halfLen - gap)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local bottom = makeLine("Bottom")
		bottom.Size = UDim2.fromOffset(w, halfLen - gap)
		bottom.AnchorPoint = Vector2.new(0.5, 0)
		bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
		bottom:SetAttribute("OriginalPos", bottom.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(halfLen - gap, w)
		left.AnchorPoint = Vector2.new(1, 0.5)
		left.Position = UDim2.new(0.5, -gap, 0.5, 0)
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(halfLen - gap, w)
		right.AnchorPoint = Vector2.new(0, 0.5)
		right.Position = UDim2.new(0.5, gap, 0.5, 0)
		right:SetAttribute("OriginalPos", right.Position)
		local dot = makeLine("CenterDot")
		dot.Size = UDim2.fromOffset(w + 2, w + 2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {top, bottom, left, right, dot}
	end

	presets["Brackets"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 5
		local tl = makeLine("TL")
		tl.Size = UDim2.fromOffset(len * 0.5, w)
		tl.AnchorPoint = Vector2.new(1, 0.5)
		tl.Position = UDim2.new(0.5, -gap, 0.5, -len * 0.4)
		tl:SetAttribute("OriginalPos", tl.Position)
		local bl = makeLine("BL")
		bl.Size = UDim2.fromOffset(len * 0.5, w)
		bl.AnchorPoint = Vector2.new(1, 0.5)
		bl.Position = UDim2.new(0.5, -gap, 0.5, len * 0.4)
		bl:SetAttribute("OriginalPos", bl.Position)
		local tr = makeLine("TR")
		tr.Size = UDim2.fromOffset(len * 0.5, w)
		tr.AnchorPoint = Vector2.new(0, 0.5)
		tr.Position = UDim2.new(0.5, gap, 0.5, -len * 0.4)
		tr:SetAttribute("OriginalPos", tr.Position)
		local br = makeLine("BR")
		br.Size = UDim2.fromOffset(len * 0.5, w)
		br.AnchorPoint = Vector2.new(0, 0.5)
		br.Position = UDim2.new(0.5, gap, 0.5, len * 0.4)
		br:SetAttribute("OriginalPos", br.Position)
		return {tl, bl, tr, br}
	end

	presets["Circle"] = function()
		clearCrosshairParts()
		local ringSize, w = settings.VertLength + 6, settings.Width
		local ring = makeLine("Ring")
		ring.Size = UDim2.fromOffset(ringSize, ringSize)
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.fromScale(0.5, 0.5)
		ring.BackgroundTransparency = 1
		ring:SetAttribute("OriginalPos", ring.Position)
		local stroke = Instance.new("UIStroke", ring)
		stroke.Color = Color3.new(1,1,1)
		stroke.Thickness = w
		Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
		local dot = makeLine("CenterDot")
		dot.Size = UDim2.fromOffset(w, w)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {ring, dot}
	end

	presets["Chevron"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 4
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(w, len * 0.5)
		left.AnchorPoint = Vector2.new(0.5, 1)
		left.Position = UDim2.new(0.5, -len * 0.25 - gap, 0.5, -gap)
		left.Rotation = -25
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(w, len * 0.5)
		right.AnchorPoint = Vector2.new(0.5, 1)
		right.Position = UDim2.new(0.5, len * 0.25 + gap, 0.5, -gap)
		right.Rotation = 25
		right:SetAttribute("OriginalPos", right.Position)
		return {left, right}
	end

	presets["Wings"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 3
		local l1 = makeLine("L1")
		l1.Size = UDim2.fromOffset(w, len * 0.4)
		l1.AnchorPoint = Vector2.new(0.5, 1)
		l1.Position = UDim2.new(0.5, -len * 0.35 - gap, 0.5, -gap)
		l1.Rotation = 15
		l1:SetAttribute("OriginalPos", l1.Position)
		local l2 = makeLine("L2")
		l2.Size = UDim2.fromOffset(w, len * 0.4)
		l2.AnchorPoint = Vector2.new(0.5, 0)
		l2.Position = UDim2.new(0.5, -len * 0.35 - gap, 0.5, gap)
		l2.Rotation = -15
		l2:SetAttribute("OriginalPos", l2.Position)
		local r1 = makeLine("R1")
		r1.Size = UDim2.fromOffset(w, len * 0.4)
		r1.AnchorPoint = Vector2.new(0.5, 1)
		r1.Position = UDim2.new(0.5, len * 0.35 + gap, 0.5, -gap)
		r1.Rotation = -15
		r1:SetAttribute("OriginalPos", r1.Position)
		local r2 = makeLine("R2")
		r2.Size = UDim2.fromOffset(w, len * 0.4)
		r2.AnchorPoint = Vector2.new(0.5, 0)
		r2.Position = UDim2.new(0.5, len * 0.35 + gap, 0.5, gap)
		r2.Rotation = 15
		r2:SetAttribute("OriginalPos", r2.Position)
		return {l1, l2, r1, r2}
	end

	presets["T-Shape"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 3
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(len * 1.2, w)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local drop = makeLine("Drop")
		drop.Size = UDim2.fromOffset(w, len * 0.6)
		drop.AnchorPoint = Vector2.new(0.5, 0)
		drop.Position = UDim2.new(0.5, 0, 0.5, gap)
		drop:SetAttribute("OriginalPos", drop.Position)
		return {top, drop}
	end

	presets["Diamond"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 4
		local t = makeLine("Top")
		t.Size = UDim2.fromOffset(w, len * 0.35)
		t.AnchorPoint = Vector2.new(0.5, 1)
		t.Position = UDim2.new(0.5, 0, 0.5, -gap)
		t:SetAttribute("OriginalPos", t.Position)
		local b = makeLine("Bottom")
		b.Size = UDim2.fromOffset(w, len * 0.35)
		b.AnchorPoint = Vector2.new(0.5, 0)
		b.Position = UDim2.new(0.5, 0, 0.5, gap)
		b:SetAttribute("OriginalPos", b.Position)
		local l = makeLine("Left")
		l.Size = UDim2.fromOffset(len * 0.35, w)
		l.AnchorPoint = Vector2.new(1, 0.5)
		l.Position = UDim2.new(0.5, -gap, 0.5, 0)
		l:SetAttribute("OriginalPos", l.Position)
		local r = makeLine("Right")
		r.Size = UDim2.fromOffset(len * 0.35, w)
		r.AnchorPoint = Vector2.new(0, 0.5)
		r.Position = UDim2.new(0.5, gap, 0.5, 0)
		r:SetAttribute("OriginalPos", r.Position)
		return {t, b, l, r}
	end

	presets["Crosshair 2.0"] = function()
		clearCrosshairParts()
		local w, len = settings.Width, settings.VertLength
		local halfLen, gap = len / 2, 2
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(w, halfLen - gap)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local bottom = makeLine("Bottom")
		bottom.Size = UDim2.fromOffset(w, halfLen - gap)
		bottom.AnchorPoint = Vector2.new(0.5, 0)
		bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
		bottom:SetAttribute("OriginalPos", bottom.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(halfLen - gap, w)
		left.AnchorPoint = Vector2.new(1, 0.5)
		left.Position = UDim2.new(0.5, -gap, 0.5, 0)
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(halfLen - gap, w)
		right.AnchorPoint = Vector2.new(0, 0.5)
		right.Position = UDim2.new(0.5, gap, 0.5, 0)
		right:SetAttribute("OriginalPos", right.Position)
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(w, w)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {top, bottom, left, right, dot}
	end

	presets["Reticle"] = function()
		clearCrosshairParts()
		local ringSize, w, gap = settings.VertLength + 8, settings.Width, 3
		local ring = makeLine("Ring")
		ring.Size = UDim2.fromOffset(ringSize, ringSize)
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.fromScale(0.5, 0.5)
		ring.BackgroundTransparency = 1
		ring:SetAttribute("OriginalPos", ring.Position)
		local stroke = Instance.new("UIStroke", ring)
		stroke.Color = Color3.new(1,1,1)
		stroke.Thickness = w
		Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(w, ringSize * 0.15)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local bottom = makeLine("Bottom")
		bottom.Size = UDim2.fromOffset(w, ringSize * 0.15)
		bottom.AnchorPoint = Vector2.new(0.5, 0)
		bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
		bottom:SetAttribute("OriginalPos", bottom.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(ringSize * 0.15, w)
		left.AnchorPoint = Vector2.new(1, 0.5)
		left.Position = UDim2.new(0.5, -gap, 0.5, 0)
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(ringSize * 0.15, w)
		right.AnchorPoint = Vector2.new(0, 0.5)
		right.Position = UDim2.new(0.5, gap, 0.5, 0)
		right:SetAttribute("OriginalPos", right.Position)
		return {ring, top, bottom, left, right}
	end

	presets["Arrow"] = function()
		clearCrosshairParts()
		local len, w, gap = settings.VertLength, settings.Width, 3
		local shaft = makeLine("Shaft")
		shaft.Size = UDim2.fromOffset(w, len * 0.6)
		shaft.AnchorPoint = Vector2.new(0.5, 1)
		shaft.Position = UDim2.new(0.5, 0, 0.5, -gap)
		shaft:SetAttribute("OriginalPos", shaft.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(w, len * 0.35)
		left.AnchorPoint = Vector2.new(0.5, 1)
		left.Position = UDim2.new(0.5, -len * 0.12, 0.5, -gap)
		left.Rotation = -35
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(w, len * 0.35)
		right.AnchorPoint = Vector2.new(0.5, 1)
		right.Position = UDim2.new(0.5, len * 0.12, 0.5, -gap)
		right.Rotation = 35
		right:SetAttribute("OriginalPos", right.Position)
		return {shaft, left, right}
	end

	presets["Target"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		local outer = makeLine("Outer")
		outer.Size = UDim2.fromOffset(len + 8, len + 8)
		outer.AnchorPoint = Vector2.new(0.5, 0.5)
		outer.Position = UDim2.fromScale(0.5, 0.5)
		outer.BackgroundTransparency = 1
		outer:SetAttribute("OriginalPos", outer.Position)
		local s1 = Instance.new("UIStroke", outer)
		s1.Color = Color3.new(1,1,1)
		s1.Thickness = w
		Instance.new("UICorner", outer).CornerRadius = UDim.new(1, 0)
		local inner = makeLine("Inner")
		inner.Size = UDim2.fromOffset(len * 0.5, len * 0.5)
		inner.AnchorPoint = Vector2.new(0.5, 0.5)
		inner.Position = UDim2.fromScale(0.5, 0.5)
		inner.BackgroundTransparency = 1
		inner:SetAttribute("OriginalPos", inner.Position)
		local s2 = Instance.new("UIStroke", inner)
		s2.Color = Color3.new(1,1,1)
		s2.Thickness = w
		Instance.new("UICorner", inner).CornerRadius = UDim.new(1, 0)
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(w, w)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {outer, inner, dot}
	end

	presets["Star"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		local gap = 2
		for i = 0, 4 do
			local arm = makeLine("Arm" .. i)
			arm.Size = UDim2.fromOffset(w, len * 0.5)
			arm.AnchorPoint = Vector2.new(0.5, 1)
			arm.Position = UDim2.fromScale(0.5, 0.5)
			arm.Rotation = i * 72
			arm:SetAttribute("OriginalPos", arm.Position)
		end
		return crosshairParts
	end

	presets["Hexagon"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		for i = 0, 5 do
			local side = makeLine("Side" .. i)
			side.Size = UDim2.fromOffset(len * 0.4, w)
			side.AnchorPoint = Vector2.new(0.5, 0.5)
			local angle = math.rad(i * 60)
			side.Position = UDim2.new(0.5, math.cos(angle) * len * 0.3, 0.5, math.sin(angle) * len * 0.3)
			side.Rotation = i * 60
			side:SetAttribute("OriginalPos", side.Position)
		end
		return crosshairParts
	end

	presets["Crosshair 3.0"] = function()
		clearCrosshairParts()
		local w, len = settings.Width, settings.VertLength
		local halfLen, gap = len / 2, 4
		local top = makeLine("Top")
		top.Size = UDim2.fromOffset(w, halfLen - gap)
		top.AnchorPoint = Vector2.new(0.5, 1)
		top.Position = UDim2.new(0.5, 0, 0.5, -gap)
		top:SetAttribute("OriginalPos", top.Position)
		local bottom = makeLine("Bottom")
		bottom.Size = UDim2.fromOffset(w, halfLen - gap)
		bottom.AnchorPoint = Vector2.new(0.5, 0)
		bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
		bottom:SetAttribute("OriginalPos", bottom.Position)
		local left = makeLine("Left")
		left.Size = UDim2.fromOffset(halfLen - gap, w)
		left.AnchorPoint = Vector2.new(1, 0.5)
		left.Position = UDim2.new(0.5, -gap, 0.5, 0)
		left:SetAttribute("OriginalPos", left.Position)
		local right = makeLine("Right")
		right.Size = UDim2.fromOffset(halfLen - gap, w)
		right.AnchorPoint = Vector2.new(0, 0.5)
		right.Position = UDim2.new(0.5, gap, 0.5, 0)
		right:SetAttribute("OriginalPos", right.Position)
		local tl = makeLine("TL")
		tl.Size = UDim2.fromOffset(len * 0.2, w)
		tl.AnchorPoint = Vector2.new(1, 0.5)
		tl.Position = UDim2.new(0.5, -gap, 0.5, -len * 0.3)
		tl:SetAttribute("OriginalPos", tl.Position)
		local tr = makeLine("TR")
		tr.Size = UDim2.fromOffset(len * 0.2, w)
		tr.AnchorPoint = Vector2.new(0, 0.5)
		tr.Position = UDim2.new(0.5, gap, 0.5, -len * 0.3)
		tr:SetAttribute("OriginalPos", tr.Position)
		local bl = makeLine("BL")
		bl.Size = UDim2.fromOffset(len * 0.2, w)
		bl.AnchorPoint = Vector2.new(1, 0.5)
		bl.Position = UDim2.new(0.5, -gap, 0.5, len * 0.3)
		bl:SetAttribute("OriginalPos", bl.Position)
		local br = makeLine("BR")
		br.Size = UDim2.fromOffset(len * 0.2, w)
		br.AnchorPoint = Vector2.new(0, 0.5)
		br.Position = UDim2.new(0.5, gap, 0.5, len * 0.3)
		br:SetAttribute("OriginalPos", br.Position)
		return {top, bottom, left, right, tl, tr, bl, br}
	end

	presets["Scope"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		local h = makeLine("H")
		h.Size = UDim2.fromOffset(len * 2, w)
		h.AnchorPoint = Vector2.new(0.5, 0.5)
		h.Position = UDim2.fromScale(0.5, 0.5)
		h:SetAttribute("OriginalPos", h.Position)
		local v = makeLine("V")
		v.Size = UDim2.fromOffset(w, len * 2)
		v.AnchorPoint = Vector2.new(0.5, 0.5)
		v.Position = UDim2.fromScale(0.5, 0.5)
		v:SetAttribute("OriginalPos", v.Position)
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(w + 2, w + 2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		local tl = makeLine("TL")
		tl.Size = UDim2.fromOffset(len * 0.3, w)
		tl.AnchorPoint = Vector2.new(1, 0.5)
		tl.Position = UDim2.new(0.5, -len * 0.6, 0.5, -len * 0.6)
		tl:SetAttribute("OriginalPos", tl.Position)
		local tr = makeLine("TR")
		tr.Size = UDim2.fromOffset(len * 0.3, w)
		tr.AnchorPoint = Vector2.new(0, 0.5)
		tr.Position = UDim2.new(0.5, len * 0.6, 0.5, -len * 0.6)
		tr:SetAttribute("OriginalPos", tr.Position)
		local bl = makeLine("BL")
		bl.Size = UDim2.fromOffset(len * 0.3, w)
		bl.AnchorPoint = Vector2.new(1, 0.5)
		bl.Position = UDim2.new(0.5, -len * 0.6, 0.5, len * 0.6)
		bl:SetAttribute("OriginalPos", bl.Position)
		local br = makeLine("BR")
		br.Size = UDim2.fromOffset(len * 0.3, w)
		br.AnchorPoint = Vector2.new(0, 0.5)
		br.Position = UDim2.new(0.5, len * 0.6, 0.5, len * 0.6)
		br:SetAttribute("OriginalPos", br.Position)
		return {h, v, dot, tl, tr, bl, br}
	end

	presets["Pixel"] = function()
		clearCrosshairParts()
		local w = settings.Width
		local size = w + 1
		local positions = {
			{-1,-1}, {0,-1}, {1,-1},
			{-1,0},         {1,0},
			{-1,1}, {0,1}, {1,1}
		}
		for i, pos in ipairs(positions) do
			local p = makeLine("P" .. i)
			p.Size = UDim2.fromOffset(size, size)
			p.AnchorPoint = Vector2.new(0.5, 0.5)
			p.Position = UDim2.new(0.5, pos[1] * size * 2, 0.5, pos[2] * size * 2)
			p:SetAttribute("OriginalPos", p.Position)
		end
		return crosshairParts
	end

	presets["Box"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		local gap = 4
		local t = makeLine("T")
		t.Size = UDim2.fromOffset(len, w)
		t.AnchorPoint = Vector2.new(0.5, 1)
		t.Position = UDim2.new(0.5, 0, 0.5, -len/2 - gap)
		t:SetAttribute("OriginalPos", t.Position)
		local b = makeLine("B")
		b.Size = UDim2.fromOffset(len, w)
		b.AnchorPoint = Vector2.new(0.5, 0)
		b.Position = UDim2.new(0.5, 0, 0.5, len/2 + gap)
		b:SetAttribute("OriginalPos", b.Position)
		local l = makeLine("L")
		l.Size = UDim2.fromOffset(w, len)
		l.AnchorPoint = Vector2.new(1, 0.5)
		l.Position = UDim2.new(0.5, -len/2 - gap, 0.5, 0)
		l:SetAttribute("OriginalPos", l.Position)
		local r = makeLine("R")
		r.Size = UDim2.fromOffset(w, len)
		r.AnchorPoint = Vector2.new(0, 0.5)
		r.Position = UDim2.new(0.5, len/2 + gap, 0.5, 0)
		r:SetAttribute("OriginalPos", r.Position)
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(w+1, w+1)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return {t, b, l, r, dot}
	end

	presets["Galaxy"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		for i = 0, 3 do
			local arm = makeLine("Arm" .. i)
			arm.Size = UDim2.fromOffset(w, len * 0.6)
			arm.AnchorPoint = Vector2.new(0.5, 1)
			arm.Position = UDim2.fromScale(0.5, 0.5)
			arm.Rotation = i * 90 + 45
			arm:SetAttribute("OriginalPos", arm.Position)
		end
		local ring = makeLine("Ring")
		ring.Size = UDim2.fromOffset(len * 0.4, len * 0.4)
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.fromScale(0.5, 0.5)
		ring.BackgroundTransparency = 1
		ring:SetAttribute("OriginalPos", ring.Position)
		local stroke = Instance.new("UIStroke", ring)
		stroke.Color = Color3.new(1,1,1)
		stroke.Thickness = w
		Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
		local dot = makeLine("Dot")
		dot.Size = UDim2.fromOffset(w+2, w+2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.Position = UDim2.fromScale(0.5, 0.5)
		dot:SetAttribute("OriginalPos", dot.Position)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return crosshairParts
	end

	presets["Ninja"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		for i = 0, 3 do
			local blade = makeLine("Blade" .. i)
			blade.Size = UDim2.fromOffset(w, len * 0.5)
			blade.AnchorPoint = Vector2.new(0.5, 1)
			blade.Position = UDim2.fromScale(0.5, 0.5)
			blade.Rotation = i * 90
			blade:SetAttribute("OriginalPos", blade.Position)
			local tip = makeLine("Tip" .. i)
			tip.Size = UDim2.fromOffset(w, len * 0.2)
			tip.AnchorPoint = Vector2.new(0.5, 0)
			tip.Position = UDim2.new(0.5, 0, 0.5, -len * 0.1)
			tip.Rotation = i * 90 + 30
			tip:SetAttribute("OriginalPos", tip.Position)
		end
		local centerDot = makeLine("Center")
		centerDot.Size = UDim2.fromOffset(w+2, w+2)
		centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
		centerDot.Position = UDim2.fromScale(0.5, 0.5)
		centerDot:SetAttribute("OriginalPos", centerDot.Position)
		Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1, 0)
		return crosshairParts
	end

	presets["Laser"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		local h1 = makeLine("H1")
		h1.Size = UDim2.fromOffset(len, w)
		h1.AnchorPoint = Vector2.new(0.5, 0.5)
		h1.Position = UDim2.new(0.5, 0, 0.5, -len * 0.15)
		h1:SetAttribute("OriginalPos", h1.Position)
		local h2 = makeLine("H2")
		h2.Size = UDim2.fromOffset(len, w)
		h2.AnchorPoint = Vector2.new(0.5, 0.5)
		h2.Position = UDim2.new(0.5, 0, 0.5, len * 0.15)
		h2:SetAttribute("OriginalPos", h2.Position)
		local v1 = makeLine("V1")
		v1.Size = UDim2.fromOffset(w, len)
		v1.AnchorPoint = Vector2.new(0.5, 0.5)
		v1.Position = UDim2.new(0.5, -len * 0.15, 0.5, 0)
		v1:SetAttribute("OriginalPos", v1.Position)
		local v2 = makeLine("V2")
		v2.Size = UDim2.fromOffset(w, len)
		v2.AnchorPoint = Vector2.new(0.5, 0.5)
		v2.Position = UDim2.new(0.5, len * 0.15, 0.5, 0)
		v2:SetAttribute("OriginalPos", v2.Position)
		local glow = makeLine("Glow")
		glow.Size = UDim2.fromOffset(len * 0.3, len * 0.3)
		glow.AnchorPoint = Vector2.new(0.5, 0.5)
		glow.Position = UDim2.fromScale(0.5, 0.5)
		glow.BackgroundTransparency = 0.7
		glow:SetAttribute("OriginalPos", glow.Position)
		Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)
		return {h1, h2, v1, v2, glow}
	end

	presets["Cyber"] = function()
		clearCrosshairParts()
		local len, w = settings.VertLength, settings.Width
		for i = 0, 5 do
			local side = makeLine("Side" .. i)
			side.Size = UDim2.fromOffset(len * 0.25, w)
			side.AnchorPoint = Vector2.new(0.5, 0.5)
			local angle = math.rad(i * 60)
			side.Position = UDim2.new(0.5, math.cos(angle) * len * 0.4, 0.5, math.sin(angle) * len * 0.4)
			side.Rotation = i * 60
			side:SetAttribute("OriginalPos", side.Position)
		end
		local h = makeLine("H")
		h.Size = UDim2.fromOffset(len * 0.4, w)
		h.AnchorPoint = Vector2.new(0.5, 0.5)
		h.Position = UDim2.fromScale(0.5, 0.5)
		h:SetAttribute("OriginalPos", h.Position)
		local v = makeLine("V")
		v.Size = UDim2.fromOffset(w, len * 0.4)
		v.AnchorPoint = Vector2.new(0.5, 0.5)
		v.Position = UDim2.fromScale(0.5, 0.5)
		v:SetAttribute("OriginalPos", v.Position)
		local core = makeLine("Core")
		core.Size = UDim2.fromOffset(w+2, w+2)
		core.AnchorPoint = Vector2.new(0.5, 0.5)
		core.Position = UDim2.fromScale(0.5, 0.5)
		core:SetAttribute("OriginalPos", core.Position)
		Instance.new("UICorner", core).CornerRadius = UDim.new(1, 0)
		return crosshairParts
	end

	local currentPresetParts = presets["Classic"]()

	-- ================= SETTINGS PANEL =================
	local panel = Instance.new("Frame")
	panel.Name = "SettingsPanel"
	panel.Size = UDim2.fromOffset(280, 0)
	panel.Position = UDim2.fromOffset(30, 100)
	panel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	panel.BackgroundTransparency = 0.15
	panel.BorderSizePixel = 0
	panel.Visible = true
	panel.ZIndex = 2147483646
	panel.Parent = gui
	panel.ClipsDescendants = true

	local mainCorner = Instance.new("UICorner", panel)
	mainCorner.CornerRadius = UDim.new(0, 16)

	local glowStroke = Instance.new("UIStroke", panel)
	glowStroke.Color = Color3.fromRGB(100, 80, 255)
	glowStroke.Thickness = 1.5

	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 12, 1, 12)
	shadow.Position = UDim2.new(0, -6, 0, -6)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.6
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 2147483645
	shadow.Parent = panel
	local shadowCorner = Instance.new("UICorner", shadow)
	shadowCorner.CornerRadius = UDim.new(0, 20)

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 48)
	header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 2147483646
	header.Parent = panel

	local headerCorner = Instance.new("UICorner", header)
	headerCorner.CornerRadius = UDim.new(0, 16)

	local headerLine = Instance.new("Frame")
	headerLine.Name = "AccentLine"
	headerLine.Size = UDim2.new(1, 0, 0, 2)
	headerLine.Position = UDim2.new(0, 0, 1, -1)
	headerLine.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
	headerLine.BackgroundTransparency = 0.3
	headerLine.BorderSizePixel = 0
	headerLine.ZIndex = 2147483646
	headerLine.Parent = header

	local moonIcon = Instance.new("TextLabel")
	moonIcon.Name = "MoonIcon"
	moonIcon.Text = ""
	moonIcon.Size = UDim2.fromOffset(32, 32)
	moonIcon.Position = UDim2.fromOffset(14, 8)
	moonIcon.BackgroundTransparency = 1
	moonIcon.Font = Enum.Font.Code
	moonIcon.TextSize = 20
	moonIcon.ZIndex = 2147483646
	moonIcon.Parent = header

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "Lunar Crosshair"
	title.Size = UDim2.new(1, -60, 0, 24)
	title.Position = UDim2.fromOffset(48, 6)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.Code
	title.TextSize = 16
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 2147483646
	title.Parent = header

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Text = "Right Shift to toggle"
	subtitle.Size = UDim2.new(1, -60, 0, 16)
	subtitle.Position = UDim2.fromOffset(48, 26)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Enum.Font.Code
	subtitle.TextSize = 11
	subtitle.TextColor3 = Color3.fromRGB(160, 160, 180)
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.ZIndex = 2147483646
	subtitle.Parent = header

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleBtn"
	toggleBtn.Text = "−"
	toggleBtn.Size = UDim2.fromOffset(28, 28)
	toggleBtn.Position = UDim2.new(1, -36, 0, 10)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
	toggleBtn.Font = Enum.Font.Code
	toggleBtn.TextSize = 18
	toggleBtn.BorderSizePixel = 0
	toggleBtn.ZIndex = 2147483646
	toggleBtn.Parent = header
	local toggleBtnCorner = Instance.new("UICorner", toggleBtn)
	toggleBtnCorner.CornerRadius = UDim.new(0, 8)

	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -58)
	content.Position = UDim2.fromOffset(10, 54)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 3
	content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.ZIndex = 2147483646
	content.Parent = panel

	local contentLayout = Instance.new("UIListLayout", content)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 10)

	local topPad = Instance.new("UIPadding", content)
	topPad.PaddingTop = UDim.new(0, 4)
	topPad.PaddingBottom = UDim.new(0, 8)

	-- Dragging
	local dragging, dragStart, startPos
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = panel.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Section helper
	local function createSection(name, parent)
		local section = Instance.new("Frame")
		section.Name = name .. "Section"
		section.Size = UDim2.new(1, 0, 0, 0)
		section.BackgroundTransparency = 1
		section.ZIndex = 2147483646
		section.Parent = parent
		section.AutomaticSize = Enum.AutomaticSize.Y

		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Name = "SectionLabel"
		sectionLabel.Text = name:upper()
		sectionLabel.Size = UDim2.new(1, 0, 0, 18)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.Font = Enum.Font.Code
		sectionLabel.TextSize = 10
		sectionLabel.TextColor3 = Color3.fromRGB(120, 100, 255)
		sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
		sectionLabel.ZIndex = 2147483646
		sectionLabel.Parent = section

		local sectionLine = Instance.new("Frame")
		sectionLine.Name = "SectionLine"
		sectionLine.Size = UDim2.new(1, 0, 0, 1)
		sectionLine.Position = UDim2.fromOffset(0, 20)
		sectionLine.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
		sectionLine.BackgroundTransparency = 0.5
		sectionLine.BorderSizePixel = 0
		sectionLine.ZIndex = 2147483646
		sectionLine.Parent = section

		local sectionContent = Instance.new("Frame")
		sectionContent.Name = "SectionContent"
		sectionContent.Size = UDim2.new(1, 0, 0, 0)
		sectionContent.Position = UDim2.fromOffset(0, 28)
		sectionContent.BackgroundTransparency = 1
		sectionContent.ZIndex = 2147483646
		sectionContent.Parent = section
		sectionContent.AutomaticSize = Enum.AutomaticSize.Y

		local sectionContentLayout = Instance.new("UIListLayout", sectionContent)
		sectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		sectionContentLayout.Padding = UDim.new(0, 6)

		return section, sectionContent
	end

	-- Input row helper
	local function createInputRow(name, key, minVal, maxVal, isText, parent)
		local row = Instance.new("Frame")
		row.Name = name .. "Row"
		row.Size = UDim2.new(1, 0, 0, 32)
		row.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		row.BackgroundTransparency = 0.4
		row.BorderSizePixel = 0
		row.ZIndex = 2147483646
		row.Parent = parent
		row.AutomaticSize = Enum.AutomaticSize.Y

		local rowCorner = Instance.new("UICorner", row)
		rowCorner.CornerRadius = UDim.new(0, 8)

		local rowStroke = Instance.new("UIStroke", row)
		rowStroke.Color = Color3.fromRGB(50, 50, 65)
		rowStroke.Thickness = 1

		local label = Instance.new("TextLabel")
		label.Text = name
		label.Position = UDim2.fromOffset(10, 0)
		label.Size = UDim2.new(0.5, -10, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(200, 200, 220)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.ZIndex = 2147483646
		label.Parent = row

		local box = Instance.new("TextBox")
		box.Text = isText and settings[key] or tostring(settings[key])
		box.Position = UDim2.new(0.5, 4, 0, 4)
		box.Size = UDim2.new(0.5, -14, 1, -8)
		box.ClearTextOnFocus = false
		box.Font = Enum.Font.Code
		box.TextSize = 12
		box.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
		box.TextColor3 = Color3.new(1, 1, 1)
		box.BorderSizePixel = 0
		box.ZIndex = 2147483646
		box.Parent = row
		box.TextXAlignment = Enum.TextXAlignment.Center
		box.TextYAlignment = Enum.TextYAlignment.Center

		local boxCorner = Instance.new("UICorner", box)
		boxCorner.CornerRadius = UDim.new(0, 6)

		local boxStroke = Instance.new("UIStroke", box)
		boxStroke.Color = Color3.fromRGB(60, 60, 80)
		boxStroke.Thickness = 1

		if isText then
			box:GetPropertyChangedSignal("Text"):Connect(function()
				settings[key] = box.Text
			end)
		else
			box:GetPropertyChangedSignal("Text"):Connect(function()
				local num = tonumber(box.Text)
				if num and num >= minVal and num <= maxVal then
					settings[key] = num
				end
			end)

			box.FocusLost:Connect(function()
				local num = tonumber(box.Text)
				if num then
					settings[key] = math.clamp(num, minVal, maxVal)
					box.Text = tostring(settings[key])
				else
					box.Text = tostring(settings[key])
				end
			end)
		end

		row.MouseEnter:Connect(function()
			TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 100)}):Play()
		end)
		row.MouseLeave:Connect(function()
			TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
		end)

		return box
	end

	-- Toggle row helper
	local function createToggleRow(name, key, parent)
		local row = Instance.new("Frame")
		row.Name = name .. "ToggleRow"
		row.Size = UDim2.new(1, 0, 0, 32)
		row.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		row.BackgroundTransparency = 0.4
		row.BorderSizePixel = 0
		row.ZIndex = 2147483646
		row.Parent = parent

		local rowCorner = Instance.new("UICorner", row)
		rowCorner.CornerRadius = UDim.new(0, 8)

		local rowStroke = Instance.new("UIStroke", row)
		rowStroke.Color = Color3.fromRGB(50, 50, 65)
		rowStroke.Thickness = 1

		local label = Instance.new("TextLabel")
		label.Text = name
		label.Position = UDim2.fromOffset(10, 0)
		label.Size = UDim2.new(0.5, -10, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(200, 200, 220)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.ZIndex = 2147483646
		label.Parent = row

		local toggleBg = Instance.new("Frame")
		toggleBg.Name = "ToggleBg"
		toggleBg.Size = UDim2.fromOffset(44, 22)
		toggleBg.Position = UDim2.new(1, -54, 0.5, -11)
		toggleBg.BackgroundColor3 = settings[key] and Color3.fromRGB(120, 100, 255) or Color3.fromRGB(50, 50, 60)
		toggleBg.BorderSizePixel = 0
		toggleBg.ZIndex = 2147483646
		toggleBg.Parent = row
		local toggleBgCorner = Instance.new("UICorner", toggleBg)
		toggleBgCorner.CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Position = settings[key] and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.ZIndex = 2147483647
		knob.Parent = toggleBg
		local knobCorner = Instance.new("UICorner", knob)
		knobCorner.CornerRadius = UDim.new(1, 0)

		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Name = "ToggleBtn"
		toggleBtn.Text = ""
		toggleBtn.Size = UDim2.new(1, 0, 1, 0)
		toggleBtn.BackgroundTransparency = 1
		toggleBtn.ZIndex = 2147483647
		toggleBtn.Parent = row

		toggleBtn.MouseButton1Click:Connect(function()
			settings[key] = not settings[key]
			local isOn = settings[key]

			TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = isOn and Color3.fromRGB(120, 100, 255) or Color3.fromRGB(50, 50, 60)
			}):Play()

			TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = isOn and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
			}):Play()
		end)

		row.MouseEnter:Connect(function()
			TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 100)}):Play()
		end)
		row.MouseLeave:Connect(function()
			TweenService:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
		end)

		return toggleBtn
	end

	-- Color picker
	local colorPickerOpen = false
	local colorPreview = nil

	local function createColorPicker(parent)
		local container = Instance.new("Frame")
		container.Name = "ColorPickerContainer"
		container.Size = UDim2.new(1, 0, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 214748364
		container.Parent = parent
		container.AutomaticSize = Enum.AutomaticSize.Y

		local rainbowRow = Instance.new("Frame")
		rainbowRow.Size = UDim2.new(1, 0, 0, 32)
		rainbowRow.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		rainbowRow.BackgroundTransparency = 0.4
		rainbowRow.BorderSizePixel = 0
		rainbowRow.ZIndex = 2147483646
		rainbowRow.Parent = container
		local rrCorner = Instance.new("UICorner", rainbowRow)
		rrCorner.CornerRadius = UDim.new(0, 8)
		local rrStroke = Instance.new("UIStroke", rainbowRow)
		rrStroke.Color = Color3.fromRGB(50, 50, 65)
		rrStroke.Thickness = 1

		local rrLabel = Instance.new("TextLabel")
		rrLabel.Text = "Rainbow Mode"
		rrLabel.Position = UDim2.fromOffset(10, 50)
		rrLabel.Size = UDim2.new(0.5, -10, 1, 0)
		rrLabel.BackgroundTransparency = 1
		rrLabel.Font = Enum.Font.Code
		rrLabel.TextSize = 12
		rrLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
		rrLabel.TextXAlignment = Enum.TextXAlignment.Left
		rrLabel.TextYAlignment = Enum.TextYAlignment.Center
		rrLabel.ZIndex = 2147483646
		rrLabel.Parent = rainbowRow

		local rrToggleBg = Instance.new("Frame")
		rrToggleBg.Size = UDim2.fromOffset(44, 22)
		rrToggleBg.Position = UDim2.new(1, -54, 0.5, -11)
		rrToggleBg.BackgroundColor3 = settings.UseRainbow and Color3.fromRGB(120, 100, 255) or Color3.fromRGB(50, 50, 60)
		rrToggleBg.BorderSizePixel = 0
		rrToggleBg.ZIndex = 2147483646
		rrToggleBg.Parent = rainbowRow
		Instance.new("UICorner", rrToggleBg).CornerRadius = UDim.new(1, 0)

		local rrKnob = Instance.new("Frame")
		rrKnob.Size = UDim2.fromOffset(16, 16)
		rrKnob.Position = settings.UseRainbow and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
		rrKnob.BackgroundColor3 = Color3.new(1, 1, 1)
		rrKnob.BorderSizePixel = 0
		rrKnob.ZIndex = 2147483647
		rrKnob.Parent = rrToggleBg
		Instance.new("UICorner", rrKnob).CornerRadius = UDim.new(1, 0)

		local rrBtn = Instance.new("TextButton")
		rrBtn.Text = ""
		rrBtn.Size = UDim2.new(1, 0, 1, 0)
		rrBtn.BackgroundTransparency = 1
		rrBtn.ZIndex = 2147483647
		rrBtn.Parent = rainbowRow

		rrBtn.MouseButton1Click:Connect(function()
			settings.UseRainbow = not settings.UseRainbow
			local isOn = settings.UseRainbow
			TweenService:Create(rrToggleBg, TweenInfo.new(0.25), {BackgroundColor3 = isOn and Color3.fromRGB(120, 100, 255) or Color3.fromRGB(50, 50, 60)}):Play()
			TweenService:Create(rrKnob, TweenInfo.new(0.25), {Position = isOn and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
		end)

		rainbowRow.MouseEnter:Connect(function()
			TweenService:Create(rainbowRow, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(rrStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 100)}):Play()
		end)
		rainbowRow.MouseLeave:Connect(function()
			TweenService:Create(rainbowRow, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
			TweenService:Create(rrStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
		end)

		local colorRow = Instance.new("Frame")
		colorRow.Name = "ColorRow"
		colorRow.Size = UDim2.new(1, 0, 0, 40)
		colorRow.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		colorRow.BackgroundTransparency = 0.4
		colorRow.BorderSizePixel = 0
		colorRow.ZIndex = 2147483646
		colorRow.Parent = container
		local crCorner = Instance.new("UICorner", colorRow)
		crCorner.CornerRadius = UDim.new(0, 8)
		local crStroke = Instance.new("UIStroke", colorRow)
		crStroke.Color = Color3.fromRGB(50, 50, 65)
		crStroke.Thickness = 1

		local crLabel = Instance.new("TextLabel")
		crLabel.Text = "Custom Color"
		crLabel.Position = UDim2.fromOffset(10, 0)
		crLabel.Size = UDim2.new(0.4, -10, 1, 0)
		crLabel.BackgroundTransparency = 1
		crLabel.Font = Enum.Font.Code
		crLabel.TextSize = 12
		crLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
		crLabel.TextXAlignment = Enum.TextXAlignment.Left
		crLabel.TextYAlignment = Enum.TextYAlignment.Center
		crLabel.ZIndex = 2147483646
		crLabel.Parent = colorRow

		colorPreview = Instance.new("Frame")
		colorPreview.Name = "ColorPreview"
		colorPreview.Size = UDim2.fromOffset(28, 28)
		colorPreview.Position = UDim2.new(0.5, -14, 0.5, -14)
		colorPreview.BackgroundColor3 = settings.CustomColor
		colorPreview.BorderSizePixel = 0
		colorPreview.ZIndex = 2147483646
		colorPreview.Parent = colorRow
		Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(0, 6)
		local cpStroke = Instance.new("UIStroke", colorPreview)
		cpStroke.Color = Color3.fromRGB(200, 200, 220)
		cpStroke.Thickness = 1

		local openColorBtn = Instance.new("TextButton")
		openColorBtn.Text = " Open"
		openColorBtn.Size = UDim2.new(0, 70, 0, 26)
		openColorBtn.Position = UDim2.new(1, -100, 0.5, -55)
		openColorBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
		openColorBtn.TextColor3 = Color3.new(1, 1, 1)
		openColorBtn.Font = Enum.Font.Code
		openColorBtn.TextSize = 11
		openColorBtn.BorderSizePixel = 0
		openColorBtn.ZIndex = 2147483646
		openColorBtn.Parent = colorRow
		Instance.new("UICorner", openColorBtn).CornerRadius = UDim.new(0, 6)

		local pickerPopup = Instance.new("Frame")
		pickerPopup.Name = "ColorPickerPopup"
		pickerPopup.Size = UDim2.new(1, 0, 0, 150)
		pickerPopup.Position = UDim2.fromOffset(0, 44)
		pickerPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
		pickerPopup.BackgroundTransparency = 0.05
		pickerPopup.BorderSizePixel = 0
		pickerPopup.ZIndex = 2147483647
		pickerPopup.Parent = colorRow
		pickerPopup.Visible = false
		pickerPopup.ClipsDescendants = true
		Instance.new("UICorner", pickerPopup).CornerRadius = UDim.new(0, 10)
		local ppStroke = Instance.new("UIStroke", pickerPopup)
		ppStroke.Color = Color3.fromRGB(80, 80, 100)
		ppStroke.Thickness = 1

		local sliderRefs = {}

		local function makeSlider(name, colorKey, yPos, colorValue)
			local sLabel = Instance.new("TextLabel")
			sLabel.Text = name
			sLabel.Position = UDim2.fromOffset(10, yPos)
			sLabel.Size = UDim2.fromOffset(18, 20)
						sLabel.BackgroundTransparency = 1
			sLabel.Font = Enum.Font.Code
			sLabel.TextSize = 12
			sLabel.TextColor3 = colorValue
			sLabel.ZIndex = 2147483647
			sLabel.Parent = pickerPopup

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -80, 0, 8)
			track.Position = UDim2.fromOffset(32, yPos + 6)
			track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
			track.BorderSizePixel = 0
			track.ZIndex = 2147483647
			track.Parent = pickerPopup
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			local fill = Instance.new("Frame")
			fill.Name = "Fill"
			fill.Size = UDim2.new(settings[colorKey] / 255, 0, 1, 0)
			fill.BackgroundColor3 = colorValue
			fill.BorderSizePixel = 0
			fill.ZIndex = 2147483647
			fill.Parent = track
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			local knob = Instance.new("Frame")
			knob.Size = UDim2.fromOffset(14, 14)
			knob.Position = UDim2.new(settings[colorKey] / 255, -7, 0.5, -7)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			knob.ZIndex = 2147483648
			knob.Parent = track
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
			local kStroke = Instance.new("UIStroke", knob)
			kStroke.Color = Color3.fromRGB(100, 100, 120)
			kStroke.Thickness = 1

			local valueBox = Instance.new("TextBox")
			valueBox.Text = tostring(settings[colorKey])
			valueBox.Size = UDim2.fromOffset(36, 22)
			valueBox.Position = UDim2.new(1, -42, 0, yPos - 1)
			valueBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
			valueBox.TextColor3 = Color3.new(1, 1, 1)
			valueBox.Font = Enum.Font.Code
			valueBox.TextSize = 12
			valueBox.BorderSizePixel = 0
			valueBox.ZIndex = 2147483647
			valueBox.Parent = pickerPopup
			valueBox.TextXAlignment = Enum.TextXAlignment.Center
			Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 4)

			local draggingSlider = false

			local function updateSlider(inputX)
				local trackAbs = track.AbsolutePosition.X
				local trackSize = track.AbsoluteSize.X
				if trackSize <= 0 then return end
				local relX = math.clamp(inputX - trackAbs, 0, trackSize)
				local val = math.clamp(math.round(relX / trackSize * 255), 0, 255)
				settings[colorKey] = val
				fill.Size = UDim2.new(val / 255, 0, 1, 0)
				knob.Position = UDim2.new(val / 255, -7, 0.5, -7)
				valueBox.Text = tostring(val)
				settings.CustomColor = Color3.fromRGB(settings.ColorR, settings.ColorG, settings.ColorB)
				colorPreview.BackgroundColor3 = settings.CustomColor
			end

			track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
					updateSlider(input.Position.X)
				end
			end)
			track.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input.Position.X)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)

			valueBox.FocusLost:Connect(function()
				local num = tonumber(valueBox.Text)
				if num then
					num = math.clamp(math.round(num), 0, 255)
					settings[colorKey] = num
					fill.Size = UDim2.new(num / 255, 0, 1, 0)
					knob.Position = UDim2.new(num / 255, -7, 0.5, -7)
					valueBox.Text = tostring(num)
					settings.CustomColor = Color3.fromRGB(settings.ColorR, settings.ColorG, settings.ColorB)
					colorPreview.BackgroundColor3 = settings.CustomColor
				else
					valueBox.Text = tostring(settings[colorKey])
				end
			end)

			sliderRefs[colorKey] = {fill = fill, knob = knob, valueBox = valueBox}
		end

		makeSlider("R", "ColorR", 8, Color3.fromRGB(255, 80, 80))
		makeSlider("G", "ColorG", 40, Color3.fromRGB(80, 255, 80))
		makeSlider("B", "ColorB", 72, Color3.fromRGB(80, 140, 255))

		-- Done button
		local closePicker = Instance.new("TextButton")
		closePicker.Text = "✓ Done"
		closePicker.Size = UDim2.new(1, -20, 0, 26)
		closePicker.Position = UDim2.fromOffset(10, 108)
		closePicker.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
		closePicker.TextColor3 = Color3.new(1, 1, 1)
		closePicker.Font = Enum.Font.Code
		closePicker.TextSize = 12
		closePicker.BorderSizePixel = 0
		closePicker.ZIndex = 2147483647
		closePicker.Parent = pickerPopup
		Instance.new("UICorner", closePicker).CornerRadius = UDim.new(0, 6)

		closePicker.MouseButton1Click:Connect(function()
			colorPickerOpen = false
			pickerPopup.Visible = false
			colorRow.Size = UDim2.new(1, 0, 0, 40)
		end)

		openColorBtn.MouseButton1Click:Connect(function()
			colorPickerOpen = not colorPickerOpen
			pickerPopup.Visible = colorPickerOpen
			if colorPickerOpen then
				colorRow.Size = UDim2.new(1, 0, 0, 196)
				for key, refs in pairs(sliderRefs) do
					local val = settings[key]
					refs.fill.Size = UDim2.new(val / 255, 0, 1, 0)
					refs.knob.Position = UDim2.new(val / 255, -7, 0.5, -7)
					refs.valueBox.Text = tostring(val)
				end
			else
				colorRow.Size = UDim2.new(1, 0, 0, 40)
			end
		end)

		colorRow.MouseEnter:Connect(function()
			TweenService:Create(colorRow, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			TweenService:Create(crStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 100)}):Play()
		end)
		colorRow.MouseLeave:Connect(function()
			TweenService:Create(colorRow, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
			TweenService:Create(crStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
		end)

		return container
	end

	-- ================= PRESET SELECTOR =================
	local presetNames = {"Classic", "Dot", "X", "Plus Dot", "Brackets", "Circle", "Chevron", "Wings", "T-Shape", "Diamond", "Crosshair 2.0", "Reticle", "Arrow", "Target", "Star", "Hexagon", "Crosshair 3.0", "Scope", "Pixel", "Box", "Galaxy", "Ninja", "Laser", "Cyber"}
	local selectedPresetBtn = nil

	local function createPresetSelector(parent)
		local container = Instance.new("Frame")
		container.Name = "PresetSelector"
		container.Size = UDim2.new(1, 0, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 2147483646
		container.Parent = parent
		container.AutomaticSize = Enum.AutomaticSize.Y

		local label = Instance.new("TextLabel")
		label.Text = "Choose Preset"
		label.Size = UDim2.new(1, 0, 0, 18)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(200, 200, 220)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 2147483646
		label.Parent = container

		local gridFrame = Instance.new("Frame")
		gridFrame.Size = UDim2.new(1, 0, 0, 0)
		gridFrame.Position = UDim2.fromOffset(0, 22)
		gridFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		gridFrame.BackgroundTransparency = 0.4
		gridFrame.BorderSizePixel = 0
		gridFrame.ZIndex = 2147483646
		gridFrame.Parent = container
		gridFrame.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new("UICorner", gridFrame).CornerRadius = UDim.new(0, 10)
		local gridStroke = Instance.new("UIStroke", gridFrame)
		gridStroke.Color = Color3.fromRGB(50, 50, 65)
		gridStroke.Thickness = 1

		local gridLayout = Instance.new("UIGridLayout", gridFrame)
		gridLayout.CellSize = UDim2.fromOffset(72, 28)
		gridLayout.CellPadding = UDim2.fromOffset(4, 4)
		gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local gridPadding = Instance.new("UIPadding", gridFrame)
		gridPadding.PaddingTop = UDim.new(0, 8)
		gridPadding.PaddingBottom = UDim.new(0, 8)
		gridPadding.PaddingLeft = UDim.new(0, 8)
		gridPadding.PaddingRight = UDim.new(0, 8)

		for _, presetName in ipairs(presetNames) do
			local btn = Instance.new("TextButton")
			btn.Text = presetName
			btn.Font = Enum.Font.Code
			btn.TextSize = 10
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			btn.TextColor3 = Color3.fromRGB(220, 220, 240)
			btn.BorderSizePixel = 0
			btn.ZIndex = 2147483646
			btn.Parent = gridFrame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			local btnStroke = Instance.new("UIStroke", btn)
			btnStroke.Color = Color3.fromRGB(60, 60, 80)
			btnStroke.Thickness = 1

			if presetName == settings.ActivePreset then
				btn.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
				selectedPresetBtn = btn
			end

			btn.MouseEnter:Connect(function()
				if btn ~= selectedPresetBtn then
					TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
				end
			end)
			btn.MouseLeave:Connect(function()
				if btn ~= selectedPresetBtn then
					TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
				end
			end)

			btn.MouseButton1Click:Connect(function()
				if selectedPresetBtn then
					TweenService:Create(selectedPresetBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
				end
				selectedPresetBtn = btn
				settings.ActivePreset = presetName
				settings.Symbol = ""
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 100, 255)}):Play()
				currentPresetParts = presets[presetName]()
			end)
		end

		return container
	end

	-- ================= SYMBOL SELECTOR =================
	local function createSymbolSelector(parent)
		local container = Instance.new("Frame")
		container.Name = "SymbolSelector"
		container.Size = UDim2.new(1, 0, 0, 0)
		container.BackgroundTransparency = 1
		container.ZIndex = 2147483646
		container.Parent = parent
		container.AutomaticSize = Enum.AutomaticSize.Y

		local label = Instance.new("TextLabel")
		label.Text = "Select Symbol (overrides preset)"
		label.Size = UDim2.new(1, 0, 0, 18)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(200, 200, 220)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 2147483646
		label.Parent = container

		local gridFrame = Instance.new("Frame")
		gridFrame.Size = UDim2.new(1, 0, 0, 0)
		gridFrame.Position = UDim2.fromOffset(0, 22)
		gridFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		gridFrame.BackgroundTransparency = 0.4
		gridFrame.BorderSizePixel = 0
		gridFrame.ZIndex = 2147483646
		gridFrame.Parent = container
		gridFrame.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new("UICorner", gridFrame).CornerRadius = UDim.new(0, 10)
		local gridStroke = Instance.new("UIStroke", gridFrame)
		gridStroke.Color = Color3.fromRGB(50, 50, 65)
		gridStroke.Thickness = 1

		local gridLayout = Instance.new("UIGridLayout", gridFrame)
		gridLayout.CellSize = UDim2.fromOffset(32, 32)
		gridLayout.CellPadding = UDim2.fromOffset(4, 4)
		gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local gridPadding = Instance.new("UIPadding", gridFrame)
		gridPadding.PaddingTop = UDim.new(0, 8)
		gridPadding.PaddingBottom = UDim.new(0, 8)
		gridPadding.PaddingLeft = UDim.new(0, 8)
		gridPadding.PaddingRight = UDim.new(0, 8)

		local symbols = {"卐","+","-","×","÷","*","•","○","□","△","▽","♡","♥","★","☆","!","@","#","$","%","^","&","(",")","[","]","{","}",">","/","\\","|","~"}
		local selectedSymbolBtn = nil

		for _, sym in ipairs(symbols) do
			local btn = Instance.new("TextButton")
			btn.Text = sym
			btn.Font = Enum.Font.Code
			btn.TextSize = 16
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			btn.TextColor3 = Color3.fromRGB(220, 220, 240)
			btn.BorderSizePixel = 0
			btn.ZIndex = 2147483646
			btn.Parent = gridFrame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			local btnStroke = Instance.new("UIStroke", btn)
			btnStroke.Color = Color3.fromRGB(60, 60, 80)
			btnStroke.Thickness = 1

			if sym == settings.Symbol then
				btn.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
				selectedSymbolBtn = btn
			end

			btn.MouseEnter:Connect(function()
				if btn ~= selectedSymbolBtn then
					TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
				end
			end)
			btn.MouseLeave:Connect(function()
				if btn ~= selectedSymbolBtn then
					TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
				end
			end)

			btn.MouseButton1Click:Connect(function()
				if selectedSymbolBtn then
					TweenService:Create(selectedSymbolBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
				end
				selectedSymbolBtn = btn
				settings.Symbol = sym
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(120, 100, 255)}):Play()
			end)
		end

		return container
	end

	-- ================= DISCORD BUTTON =================
	local function createDiscordButton(parent)
		local btn = Instance.new("TextButton")
		btn.Name = "DiscordBtn"
		btn.Text = "💬  Join Discord"
		btn.Size = UDim2.new(1, 0, 0, 38)
		btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.Code
		btn.TextSize = 13
		btn.BorderSizePixel = 0
		btn.ZIndex = 2147483646
		btn.Parent = parent
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

		local btnStroke = Instance.new("UIStroke", btn)
		btnStroke.Color = Color3.fromRGB(120, 130, 255)
		btnStroke.Thickness = 1

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 120, 255)}):Play()
			TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 160, 255)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
			TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(120, 130, 255)}):Play()
		end)

		local discordLink = "https://discord.gg/ydNKRbFmUd"
		btn.MouseButton1Click:Connect(function()
			if setclipboard then
				setclipboard(discordLink)
			elseif toClipboard then
				toClipboard(discordLink)
			else
				pcall(function()
					StarterGui:SetCore("SendNotification", {
						Title = "Discord Link",
						Text = discordLink .. "\n(Copied manually or use setclipboard)",
						Duration = 8
					})
				end)
				return
			end

			local originalText = btn.Text
			btn.Text = "✓  Copied!"
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 180, 80)}):Play()

			task.delay(2, function()
				btn.Text = originalText
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
			end)
		end)

		return btn
	end

	-- ================= VFX SYSTEM =================
	local function spawnVFX(color, dt)
		if not settings.VFXEnabled then return end

		local intensity = settings.VFXIntensity
		local vfxSize = settings.VFXSize

		-- Particles
		if math.random() < 0.3 * intensity / 5 then
			local p = Instance.new("Frame")
			p.Size = UDim2.fromOffset(vfxSize * 2, vfxSize * 2)
			p.BackgroundColor3 = color
			p.BackgroundTransparency = 0
			p.AnchorPoint = Vector2.new(0.5, 0.5)
			p.Position = UDim2.fromOffset(0, 0)
			p.BorderSizePixel = 0
			p.ZIndex = 2147483645
			p.Parent = center
			Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

			local dir = math.random() * math.pi * 2
			local dist = 30 + math.random() * 80
			local life = 0.2 + math.random() * 0.4

			TweenService:Create(p, TweenInfo.new(life, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(math.cos(dir) * dist, math.sin(dir) * dist),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(vfxSize * 3, vfxSize * 3)
			}):Play()

			task.delay(life, function()
				if p and p.Parent then p:Destroy() end
			end)
		end

		-- Trail Streaks
		if settings.VFXTrail and math.random() < 0.5 * intensity / 5 then
			local trail = Instance.new("Frame")
			trail.Size = UDim2.fromOffset(vfxSize * 3, vfxSize)
			trail.BackgroundColor3 = color
			trail.BackgroundTransparency = 0.3
			trail.AnchorPoint = Vector2.new(0.5, 0.5)
			trail.Position = UDim2.fromOffset(math.random(-40, 40), math.random(-40, 40))
			trail.BorderSizePixel = 0
			trail.ZIndex = 2147483644
			trail.Parent = center
			Instance.new("UICorner", trail).CornerRadius = UDim.new(1, 0)

			local angle = math.random() * math.pi * 2
			trail.Rotation = math.deg(angle)

			TweenService:Create(trail, TweenInfo.new(0.4 + math.random() * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(trail.Position.X.Offset + math.cos(angle) * 60, trail.Position.Y.Offset + math.sin(angle) * 60),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(vfxSize * 6, vfxSize * 0.5)
			}):Play()

			task.delay(0.7, function()
				if trail and trail.Parent then trail:Destroy() end
			end)
		end

		-- Glow Rings
		if settings.VFXGlow and math.random() < 0.15 * intensity / 5 then
			local glow = Instance.new("Frame")
			glow.Size = UDim2.fromOffset(10, 10)
			glow.BackgroundColor3 = color
			glow.BackgroundTransparency = 0.5
			glow.AnchorPoint = Vector2.new(0.5, 0.5)
			glow.Position = UDim2.fromScale(0.5, 0.5)
			glow.BorderSizePixel = 0
			glow.ZIndex = 2147483643
			glow.Parent = center
			Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

			TweenService:Create(glow, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(vfxSize * 15, vfxSize * 15),
				BackgroundTransparency = 1
			}):Play()

			task.delay(0.6, function()
				if glow and glow.Parent then glow:Destroy() end
			end)
		end

		-- Bloom Burst
		if settings.VFXBloom and math.random() < 0.2 * intensity / 5 then
			local bloom = Instance.new("Frame")
			bloom.Size = UDim2.fromOffset(vfxSize * 4, vfxSize * 4)
			bloom.BackgroundColor3 = color
			bloom.BackgroundTransparency = 0.6
			bloom.AnchorPoint = Vector2.new(0.5, 0.5)
			bloom.Position = UDim2.fromOffset(math.random(-30, 30), math.random(-30, 30))
			bloom.BorderSizePixel = 0
			bloom.ZIndex = 2147483642
			bloom.Parent = center
			Instance.new("UICorner", bloom).CornerRadius = UDim.new(1, 0)

			TweenService:Create(bloom, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(vfxSize * 12, vfxSize * 12),
				BackgroundTransparency = 1
			}):Play()

			task.delay(0.5, function()
				if bloom and bloom.Parent then bloom:Destroy() end
			end)
		end

		-- Sparkles
		if settings.VFXSparkle and math.random() < 0.4 * intensity / 5 then
			local sparkle = Instance.new("TextLabel")
			sparkle.Text = "✦"
			sparkle.Size = UDim2.fromOffset(20, 20)
			sparkle.BackgroundTransparency = 1
			sparkle.TextColor3 = color
			sparkle.Font = Enum.Font.Code
			sparkle.TextSize = vfxSize * 4
			sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
			sparkle.Position = UDim2.fromOffset(math.random(-50, 50), math.random(-50, 50))
			sparkle.ZIndex = 2147483645
			sparkle.Parent = center

			TweenService:Create(sparkle, TweenInfo.new(0.3 + math.random() * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(sparkle.Position.X.Offset, sparkle.Position.Y.Offset - 30),
				TextTransparency = 1,
				TextSize = vfxSize * 2
			}):Play()

			task.delay(0.6, function()
				if sparkle and sparkle.Parent then sparkle:Destroy() end
			end)
		end

		-- Ripples
		if settings.VFXRipple and math.random() < 0.1 * intensity / 5 then
			local ripple = Instance.new("Frame")
			ripple.Size = UDim2.fromOffset(10, 10)
			ripple.BackgroundTransparency = 1
			ripple.AnchorPoint = Vector2.new(0.5, 0.5)
			ripple.Position = UDim2.fromScale(0.5, 0.5)
			ripple.BorderSizePixel = 0
			ripple.ZIndex = 2147483643
			ripple.Parent = center

			local stroke = Instance.new("UIStroke", ripple)
			stroke.Color = color
			stroke.Thickness = vfxSize * 0.5

			Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

			TweenService:Create(ripple, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromOffset(vfxSize * 20, vfxSize * 20)
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 1
			}):Play()

			task.delay(0.8, function()
				if ripple and ripple.Parent then ripple:Destroy() end
			end)
		end

		-- Orbit Dots
		if settings.VFXOrbit and math.random() < 0.3 * intensity / 5 then
			local orbit = Instance.new("Frame")
			orbit.Size = UDim2.fromOffset(vfxSize * 2, vfxSize * 2)
			orbit.BackgroundColor3 = color
			orbit.BackgroundTransparency = 0
			orbit.AnchorPoint = Vector2.new(0.5, 0.5)
			orbit.Position = UDim2.fromScale(0.5, 0.5)
			orbit.BorderSizePixel = 0
			orbit.ZIndex = 2147483645
			orbit.Parent = center
			Instance.new("UICorner", orbit).CornerRadius = UDim.new(1, 0)

			local angle = math.random() * math.pi * 2
			local radius = 25 + math.random() * 30
			local speed = 1 + math.random() * 2
			local startTime = tick()

			local conn
			conn = RunService.RenderStepped:Connect(function()
				if not orbit or not orbit.Parent then
					conn:Disconnect()
					return
				end
				local elapsed = tick() - startTime
				local currentAngle = angle + elapsed * speed
				orbit.Position = UDim2.fromOffset(math.cos(currentAngle) * radius, math.sin(currentAngle) * radius)
				orbit.BackgroundTransparency = math.min(1, elapsed / 1.5)
				if elapsed > 1.5 then
					conn:Disconnect()
					if orbit and orbit.Parent then orbit:Destroy() end
				end
			end)
		end

		-- Shooting Stars
		if settings.VFXShootingStar and math.random() < 0.15 * intensity / 5 then
			local star = Instance.new("Frame")
			star.Size = UDim2.fromOffset(vfxSize * 3, vfxSize)
			star.BackgroundColor3 = color
			star.BackgroundTransparency = 0
			star.AnchorPoint = Vector2.new(0.5, 0.5)
			local startX = math.random(-60, 60)
			local startY = math.random(-60, 60)
			star.Position = UDim2.fromOffset(startX, startY)
			star.BorderSizePixel = 0
			star.ZIndex = 2147483645
			star.Parent = center
			Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)

			local endX = startX + math.random(-80, 80)
			local endY = startY + math.random(-80, 80)

			TweenService:Create(star, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(endX, endY),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(vfxSize, vfxSize * 0.3)
			}):Play()

			task.delay(0.4, function()
				if star and star.Parent then star:Destroy() end
			end)
		end

		-- Hearts
		if settings.VFXHeart and math.random() < 0.2 * intensity / 5 then
			local heart = Instance.new("TextLabel")
			heart.Text = "♥"
			heart.Size = UDim2.fromOffset(20, 20)
			heart.BackgroundTransparency = 1
			heart.TextColor3 = color
			heart.Font = Enum.Font.Code
			heart.TextSize = vfxSize * 5
			heart.AnchorPoint = Vector2.new(0.5, 0.5)
			heart.Position = UDim2.fromOffset(math.random(-40, 40), math.random(-40, 40))
			heart.ZIndex = 2147483645
			heart.Parent = center

			TweenService:Create(heart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(heart.Position.X.Offset, heart.Position.Y.Offset - 40),
				TextTransparency = 1,
				TextSize = vfxSize * 2
			}):Play()

			task.delay(0.5, function()
				if heart and heart.Parent then heart:Destroy() end
			end)
		end

		-- Lightning
		if settings.VFXLightning and math.random() < 0.15 * intensity / 5 then
			local bolt = Instance.new("Frame")
			bolt.Size = UDim2.fromOffset(vfxSize, vfxSize * 6)
			bolt.BackgroundColor3 = Color3.new(1, 1, 1)
			bolt.BackgroundTransparency = 0
			bolt.AnchorPoint = Vector2.new(0.5, 0.5)
			bolt.Position = UDim2.fromOffset(math.random(-30, 30), math.random(-30, 30))
			bolt.BorderSizePixel = 0
			bolt.ZIndex = 2147483645
			bolt.Parent = center
			bolt.Rotation = math.random(-30, 30)

			TweenService:Create(bolt, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			}):Play()

			task.delay(0.08, function()
				if bolt and bolt.Parent then bolt:Destroy() end
			end)
		end

		-- Ghosts
		if settings.VFXGhost and math.random() < 0.2 * intensity / 5 then
			local ghost = Instance.new("TextLabel")
			ghost.Text = "👻"
			ghost.Size = UDim2.fromOffset(24, 24)
			ghost.BackgroundTransparency = 1
			ghost.TextSize = vfxSize * 5
			ghost.AnchorPoint = Vector2.new(0.5, 0.5)
			ghost.Position = UDim2.fromOffset(math.random(-50, 50), math.random(-50, 50))
			ghost.ZIndex = 2147483645
			ghost.Parent = center

			TweenService:Create(ghost, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(ghost.Position.X.Offset, ghost.Position.Y.Offset - 50),
				TextTransparency = 1,
				TextSize = vfxSize * 2
			}):Play()

			task.delay(1, function()
				if ghost and ghost.Parent then ghost:Destroy() end
			end)
		end

		-- Confetti
		if settings.VFXConfetti and math.random() < 0.3 * intensity / 5 then
			local confetti = Instance.new("Frame")
			confetti.Size = UDim2.fromOffset(vfxSize * 2, vfxSize * 3)
			confetti.BackgroundColor3 = color
			confetti.BackgroundTransparency = 0
			confetti.AnchorPoint = Vector2.new(0.5, 0.5)
			confetti.Position = UDim2.fromOffset(math.random(-50, 50), -30)
			confetti.BorderSizePixel = 0
			confetti.ZIndex = 2147483645
			confetti.Parent = center
			confetti.Rotation = math.random(0, 360)

			TweenService:Create(confetti, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(confetti.Position.X.Offset + math.random(-20, 20), 50),
				BackgroundTransparency = 1,
				Rotation = confetti.Rotation + 180
			}):Play()

			task.delay(0.8, function()
				if confetti and confetti.Parent then confetti:Destroy() end
			end)
		end
	end

	-- ================= BUILD UI =================
	local presetSection, presetContent = createSection("Presets", content)
	createPresetSelector(presetContent)

	local crosshairSection, crosshairContent = createSection("Crosshair Size", content)
	createInputRow("Vertical Length", "VertLength", 1, 10000, false, crosshairContent)
	createInputRow("Horizontal Length", "HorzLength", 1, 10000, false, crosshairContent)
	createInputRow("Width", "Width", 1, 10000, false, crosshairContent)

	local colorSection, colorContent = createSection("Color", content)
	createColorPicker(colorContent)

	local animSection, animContent = createSection("Animation", content)
	createToggleRow("Pulse Breathing", "PulseEnabled", animContent)
	createInputRow("Pulse Speed", "PulseSpeed", 0.1, 20, false, animContent)
	createInputRow("Pulse Distance", "PulseDistance", 0, 20, false, animContent)

	local vfxSection, vfxContent = createSection("VFX Effects", content)
	createToggleRow("✨ Enable VFX", "VFXEnabled", vfxContent)
	createInputRow("VFX Intensity", "VFXIntensity", 1, 20, false, vfxContent)
	createInputRow("VFX Size", "VFXSize", 1, 20, false, vfxContent)
	createToggleRow("Trail Streaks", "VFXTrail", vfxContent)
	createToggleRow("Glow Rings", "VFXGlow", vfxContent)
	createToggleRow("Bloom Burst", "VFXBloom", vfxContent)
	createToggleRow("Sparkles", "VFXSparkle", vfxContent)
	createToggleRow("Ripples", "VFXRipple", vfxContent)
	createToggleRow("Orbit Dots", "VFXOrbit", vfxContent)
	createToggleRow("Shooting Stars", "VFXShootingStar", vfxContent)
	createToggleRow("Hearts", "VFXHeart", vfxContent)
	createToggleRow("Lightning", "VFXLightning", vfxContent)
	createToggleRow("Ghosts", "VFXGhost", vfxContent)
	createToggleRow("Confetti", "VFXConfetti", vfxContent)

	local appearanceSection, appearanceContent = createSection("Appearance", content)
	createInputRow("Rotation Speed", "RotationSpeed", 0, 10000, false, appearanceContent)
	createInputRow("Rainbow Speed", "RainbowSpeed", 0, 10000, false, appearanceContent)
	createInputRow("Y Offset", "YOffset", -50, 50, false, appearanceContent)
	createInputRow("Text Gap", "TextGap", 0, 10000, false, appearanceContent)
	createInputRow("Display Text", "Text", nil, nil, true, appearanceContent)

	local symbolSection, symbolContent = createSection("Symbol", content)
	createSymbolSelector(symbolContent)

	local toggleSection, toggleContent = createSection("Options", content)
	createToggleRow("Spin Animation", "SpinEnabled", toggleContent)

	local discordBtn = createDiscordButton(content)

	-- Update canvas size
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
	end)

	local function updatePanelHeight()
		local contentHeight = math.min(contentLayout.AbsoluteContentSize.Y + 70, 650)
		panel.Size = UDim2.fromOffset(280, contentHeight)
	end

	task.delay(0.1, updatePanelHeight)
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatePanelHeight)

	-- ================= COLLAPSE / EXPAND =================
	local panelExpanded = true

	local function collapsePanel()
		panelExpanded = false
		toggleBtn.Text = "+"
		TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(280, 48)
		}):Play()
	end

	local function expandPanel()
		panelExpanded = true
		toggleBtn.Text = "−"
		local targetHeight = math.min(contentLayout.AbsoluteContentSize.Y + 70, 650)
		TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(280, targetHeight)
		}):Play()
	end

	toggleBtn.MouseButton1Click:Connect(function()
		if panelExpanded then
			collapsePanel()
		else
			expandPanel()
		end
	end)

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			if panelExpanded then
				collapsePanel()
			else
				expandPanel()
			end
		end
	end)

	-- ================= MAIN LOOP =================
	local hue = 0
	local rotation = 0
	local pulseTime = 0

	data.connection = RunService.RenderStepped:Connect(function(dt)
		if not data.enabled then return end

		-- Force hide mouse every frame
		if UserInputService.MouseIconEnabled then
			UserInputService.MouseIconEnabled = false
		end
		if mouse.Icon ~= "" then
			mouse.Icon = ""
		end

		local mousePos = UserInputService:GetMouseLocation()
		local baseY = mousePos.Y + settings.YOffset

		center.Position = UDim2.fromOffset(mousePos.X, baseY)

		local crossBottomY

		-- Symbol overrides everything
		if settings.Symbol ~= "" then
			for _, part in pairs(crosshairParts) do
				if part and part.Parent then
					part.Visible = false
				end
			end
			crosshairSymbol.Visible = true
			crosshairSymbol.Text = settings.Symbol
			crosshairSymbol.TextSize = settings.VertLength

			crossBottomY = baseY + (settings.VertLength / 2)
		else
			crosshairSymbol.Visible = false

			if #crosshairParts == 0 then
				currentPresetParts = presets[settings.ActivePreset]()
			end

			for _, part in pairs(crosshairParts) do
				if part and part.Parent then
					part.Visible = true
				end
			end

			crossBottomY = baseY + (settings.VertLength / 2)
		end

		-- Pulse animation
		if settings.PulseEnabled and settings.Symbol == "" then
			pulseTime = pulseTime + dt * settings.PulseSpeed
			local pulseOffset = math.sin(pulseTime) * settings.PulseDistance

			for _, part in pairs(crosshairParts) do
				if part and part.Parent then
					local originalPos = part:GetAttribute("OriginalPos")
					if originalPos then
						local ox = originalPos.X.Offset
						local oy = originalPos.Y.Offset
						local dist = math.sqrt(ox * ox + oy * oy)

						if dist > 0.001 then
							local dirX = ox / dist
							local dirY = oy / dist
							part.Position = UDim2.new(
								originalPos.X.Scale,
								ox + dirX * pulseOffset,
								originalPos.Y.Scale,
								oy + dirY * pulseOffset
							)
						end
					end
				end
			end
		end

		-- Text position
		text.Position = UDim2.fromOffset(mousePos.X, crossBottomY + settings.TextGap)
		text.Text = settings.Text

		-- Spin
		if settings.SpinEnabled then
			rotation = rotation + settings.RotationSpeed * dt
			center.Rotation = rotation % 360
		else
			center.Rotation = 0
		end

		-- Determine color
		hue = (hue + settings.RainbowSpeed * dt) % 1
		local color
		if settings.UseRainbow then
			color = Color3.fromHSV(hue, 1, 1)
		else
			color = settings.CustomColor
		end

		-- Color all parts
		for _, part in pairs(crosshairParts) do
			if part and part.Parent then
				if part:IsA("Frame") then
					part.BackgroundColor3 = color
				end
				for _, child in pairs(part:GetChildren()) do
					if child:IsA("UIStroke") then
						child.Color = color
					end
				end
			end
		end

		crosshairSymbol.TextColor3 = color
		text.TextColor3 = color
		title.TextColor3 = color
		headerLine.BackgroundColor3 = color
		glowStroke.Color = smoothColor(Color3.fromRGB(100, 80, 255), color, 0.5)

		-- Spawn VFX
		spawnVFX(color, dt)
	end)

	notify("Crosshair enabled! Press [RightShift] for settings", Color3.fromRGB(120, 100, 255))
	print("Lunar Crosshair V2 Loaded | CoreGui overlay")
end

function UnloadLunarCrosshair()
	local data = _G.LunarCrosshairData
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local mouse = Players.LocalPlayer:GetMouse()

	if data.gui then
		data.gui:Destroy()
		data.gui = nil
	end
	if data.connection then
		data.connection:Disconnect()
		data.connection = nil
	end

	data.enabled = false
	data.settings = nil

	-- Restore default mouse
	UserInputService.MouseIconEnabled = true
	mouse.Icon = ""

	notify("Crosshair disabled. Default mouse restored.", Color3.fromRGB(255, 80, 80))
end

-- =============================================================
--  sun glare
-- =============================================================
local sunGlareData = {
	enabled = false,
	gui = nil,
	renderConnection = nil,
	blur = nil
}

local function enableSunGlare()
	if sunGlareData.enabled then
		notify("⚠️ Sun glare already enabled", Color3.fromRGB(255, 200, 100))
		return
	end
	
	sunGlareData.enabled = true
	
	if sunGlareData.gui then
		sunGlareData.gui:Destroy()
	end
	if sunGlareData.renderConnection then
		sunGlareData.renderConnection:Disconnect()
	end
	if sunGlareData.blur then
		sunGlareData.blur:Destroy()
	end
	
	local Lighting = game:GetService("Lighting")

	-- 🎥 Blur effect (depth simulation)
	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting
	sunGlareData.blur = blur
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SunGlare"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screenGui.DisplayOrder = 10
	screenGui.Parent = client.PlayerGui
	sunGlareData.gui = screenGui

	local host = Instance.new("Frame")
	host.Size = UDim2.new(1,0,1,0)
	host.BackgroundTransparency = 1
	host.Parent = screenGui

	local ShineOverlay = Instance.new("Frame")
	ShineOverlay.Size = UDim2.new(2,0,2,0)
	ShineOverlay.Position = UDim2.new(-0.5,0,-0.5,0)
	ShineOverlay.BackgroundColor3 = Color3.new(1,1,1)
	ShineOverlay.BackgroundTransparency = 1
	ShineOverlay.ZIndex = 6
	ShineOverlay.Parent = host

	local Haze = Instance.new("Frame")
	Haze.Size = UDim2.new(2,0,2,0)
	Haze.Position = UDim2.new(-0.5,0,-0.5,0)
	Haze.BackgroundColor3 = Color3.new(1,1,1)
	Haze.BackgroundTransparency = 1
	Haze.ZIndex = 5
	Haze.Parent = host

	local flareData = {
		{id="109801097", size=320},
		{id="109801061", size=180},
		{id="109801105", size=160},
		{id="109801051", size=200},
		{id="109801097", size=180},
		{id="109801105", size=90}
	}

	local lFlares = {}

	for i,data in ipairs(flareData) do
		local img = Instance.new("ImageLabel")
		img.Image = "http://www.roblox.com/asset/?id="..data.id
		img.Size = UDim2.new(0,data.size,0,data.size)
		img.BackgroundTransparency = 1
		img.ImageTransparency = 1
		img.ScaleType = Enum.ScaleType.Stretch
		img.Parent = host
		lFlares[img] = i
	end

	local function findFlareCoord(cf, sunPos)
		local v = cf:PointToObjectSpace(sunPos)
		local z = -v.Z
		if z > 0 then
			return v.X/45, -v.Y/45, true
		end
		return 0,0,false
	end

	local function isSunBlocked(origin, dir)
		local ignore = {client.Character}
		for i=1,10 do
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = ignore
			
			local r = workspace:Raycast(origin, dir*1000, params)
			if not r then return false end
			
			local h = r.Instance
			if h.Transparency > 0.05 or h.Material == Enum.Material.Glass then
				table.insert(ignore,h)
				origin = r.Position + dir*0.01
			else
				return true
			end
		end
		return false
	end

	local exposure = 0

	sunGlareData.renderConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
		if not sunGlareData.enabled then return end
		
		local cam = workspace.CurrentCamera
		local Lighting = game:GetService("Lighting")
		
		local x,y,z = findFlareCoord(cam.CFrame, cam.CFrame.Position + Lighting:GetSunDirection()*8)
		local blocked = isSunBlocked(cam.CFrame.Position, Lighting:GetSunDirection())
		local minutes = Lighting:GetMinutesAfterMidnight()

		if z and not blocked and minutes > 335 and minutes < 1105 then
			local dot = cam.CFrame.LookVector:Dot(Lighting:GetSunDirection())
			local target = math.clamp((dot - 0.65) * 2.8, 0, 1)
			target = target * target

			exposure = exposure + (target - exposure) * math.clamp(dt * 2, 0, 1)

			for flare,pos in pairs(lFlares) do
				local spread = pos*(1.4 + exposure*1.2)

				flare.Position = UDim2.new(
					0.5 + x*spread,
					-flare.AbsoluteSize.X/2,
					0.5 + y*spread,
					-flare.AbsoluteSize.Y/2
				)

				flare.Visible = true
				flare.ImageColor3 = Color3.new(1,1,1)
				flare.ImageTransparency = 1-(0.6*exposure)
			end

			local centerDist = math.clamp(math.abs(x)+math.abs(y),0,2)
			local hazeStrength = (1-centerDist) * exposure

			Haze.BackgroundTransparency = 1 - (hazeStrength * 0.25)
			ShineOverlay.BackgroundTransparency = 1 - (exposure * 0.18)

			-- 🎥 DEPTH-BASED BLUR (cinematic)
			local blurTarget = exposure * 18
			blur.Size = blur.Size + (blurTarget - blur.Size) * math.clamp(dt * 3, 0, 1)

		else
			exposure = exposure + (0 - exposure) * math.clamp(dt * 2, 0, 1)

			for flare in pairs(lFlares) do
				flare.Visible = false
			end

			Haze.BackgroundTransparency = 1
			ShineOverlay.BackgroundTransparency = 1

			blur.Size = blur.Size + (0 - blur.Size) * math.clamp(dt * 3, 0, 1)
		end
	end)

	notify("Sun glare enabled", Color3.fromRGB(255,220,100))
end

local function disableSunGlare()
	if not sunGlareData.enabled then
		notify("⚠️ Sun glare not enabled", Color3.fromRGB(255,200,100))
		return
	end
	
	sunGlareData.enabled = false
	
	if sunGlareData.renderConnection then
		sunGlareData.renderConnection:Disconnect()
	end
	
	if sunGlareData.gui then
		sunGlareData.gui:Destroy()
	end

	if sunGlareData.blur then
		sunGlareData.blur:Destroy()
	end
	
	notify("Sun glare disabled", Color3.fromRGB(255,100,100))
end
-- =============================================================
--  speed system
-- =============================================================
local speedPanelData = {
	panel = nil,
	enabled = false,
	bypassEnabled = false,
	speedValue = 100,
	mainConnection = nil,
	directionConnection = nil,
	charConnection = nil
}

local function createSpeedPanel()
	if speedPanelData.panel then
		speedPanelData.panel:Destroy()
		speedPanelData.panel = nil
		if speedPanelData.mainConnection then speedPanelData.mainConnection:Disconnect() speedPanelData.mainConnection = nil end
		if speedPanelData.directionConnection then speedPanelData.directionConnection:Disconnect() speedPanelData.directionConnection = nil end
		return
	end

	local panel = Instance.new("ScreenGui")
	panel.Name = "SpeedPanel"
	panel.ResetOnSpawn = false
	panel.DisplayOrder = 999999
	panel.IgnoreGuiInset = true
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Global
	panel.Parent = client.PlayerGui

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 350, 0, 290)
	main.Position = UDim2.new(0.5, -175, 0.5, -145)
	main.BackgroundColor3 = currentTheme.glass
	main.Active = true
	main.Draggable = true
	main.Parent = panel
	applyGlassEffect(main, globalConfig.uiTransparency, 0.4)

	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "SPEED CONTROL"
	title.Font = Enum.Font.Code
	title.TextSize = 26
	title.TextColor3 = currentTheme.accent
	title.TextTransparency = 0
	title.TextStrokeTransparency = 0.5
	title.TextStrokeColor3 = Color3.new(0,0,0)

	local speedDisplay = Instance.new("TextLabel", main)
	speedDisplay.Size = UDim2.new(1, 0, 0, 40)
	speedDisplay.Position = UDim2.new(0, 0, 0, 50)
	speedDisplay.BackgroundTransparency = 1
	speedDisplay.Text = "Speed: " .. speedPanelData.speedValue
	speedDisplay.Font = Enum.Font.Code
	speedDisplay.TextSize = 24
	speedDisplay.TextColor3 = globalConfig.textColor
	speedDisplay.TextTransparency = 0
	speedDisplay.TextStrokeTransparency = 0.5
	speedDisplay.TextStrokeColor3 = Color3.new(0,0,0)

	-- TextBox (clean input)
	local speedBox = Instance.new("TextBox", main)
	speedBox.Size = UDim2.new(0.8, 0, 0, 50)
	speedBox.Position = UDim2.new(0.1, 0, 0, 100)
	speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	speedBox.Text = tostring(speedPanelData.speedValue)
	speedBox.Font = Enum.Font.Code
	speedBox.TextSize = 28
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.PlaceholderText = "Enter speed (1-10000)"
	speedBox.ClearTextOnFocus = false
	applyGlassEffect(speedBox, 0.3, 0.6)
	Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

	local toggle1Btn = Instance.new("TextButton", main)
	toggle1Btn.Size = UDim2.new(0.9, 0, 0, 45)
	toggle1Btn.Position = UDim2.new(0.05, 0, 0, 165)
	toggle1Btn.BackgroundColor3 = speedPanelData.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
	toggle1Btn.Text = "Walkspeed: " .. (speedPanelData.enabled and "ON" or "OFF")
	toggle1Btn.Font = Enum.Font.Code
	toggle1Btn.TextSize = 18
	toggle1Btn.TextColor3 = Color3.new(0,0,0)
	applyGlassEffect(toggle1Btn, 0.2, 0.5)

	local toggle2Btn = Instance.new("TextButton", main)
	toggle2Btn.Size = UDim2.new(0.9, 0, 0, 45)
	toggle2Btn.Position = UDim2.new(0.05, 0, 0, 220)
	toggle2Btn.BackgroundColor3 = speedPanelData.bypassEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
	toggle2Btn.Text = "Loop + No Slide: " .. (speedPanelData.bypassEnabled and "ON" or "OFF")
	toggle2Btn.Font = Enum.Font.Code
	toggle2Btn.TextSize = 18
	toggle2Btn.TextColor3 = Color3.new(0,0,0)
	applyGlassEffect(toggle2Btn, 0.2, 0.5)

	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -45, 0, 8)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.Code
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Color3.new(1,1,1)
	applyGlassEffect(closeBtn, 0.2, 0.4)

	local function applySpeed()
		if not speedPanelData.enabled or not hum then return end
		if hum then
			hum.WalkSpeed = speedPanelData.speedValue
		end
	end

	-- TextBox logic
	speedBox.FocusLost:Connect(function()
		local num = tonumber(speedBox.Text)
		if num then
			speedPanelData.speedValue = math.clamp(math.floor(num), 1, 10000)
			speedDisplay.Text = "Speed: " .. speedPanelData.speedValue
			speedBox.Text = tostring(speedPanelData.speedValue)
			applySpeed()
		else
			speedBox.Text = tostring(speedPanelData.speedValue)
		end
	end)

	-- Simple Walkspeed Toggle (like 'speed' command)
	toggle1Btn.MouseButton1Click:Connect(function()
		speedPanelData.enabled = not speedPanelData.enabled
		toggle1Btn.Text = "Walkspeed: " .. (speedPanelData.enabled and "ON" or "OFF")
		toggle1Btn.BackgroundColor3 = speedPanelData.enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

		if speedPanelData.enabled then
			applySpeed()
		elseif hum then
			hum.WalkSpeed = 16
		end
	end)

	-- Loop + No Slide (like 'loopspeed' + your anti-slide request)
	toggle2Btn.MouseButton1Click:Connect(function()
		speedPanelData.bypassEnabled = not speedPanelData.bypassEnabled
		toggle2Btn.Text = "Loop + No Slide: " .. (speedPanelData.bypassEnabled and "ON" or "OFF")
		toggle2Btn.BackgroundColor3 = speedPanelData.bypassEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

		if speedPanelData.bypassEnabled then
			-- Main loop (like loopspeed)
			if speedPanelData.mainConnection then speedPanelData.mainConnection:Disconnect() end
			speedPanelData.mainConnection = RunService.Heartbeat:Connect(applySpeed)

			-- Instant direction change (no sliding when turning)
			if speedPanelData.directionConnection then speedPanelData.directionConnection:Disconnect() end
			local lastDir = Vector3.new()
			speedPanelData.directionConnection = RunService.Heartbeat:Connect(function()
				if not hum or not speedPanelData.enabled then return end

				local moveDir = hum.MoveDirection
				if moveDir.Magnitude > 0.1 then
					if lastDir:Dot(moveDir) < 0.65 then -- Sharp direction change
						local root = hum.RootPart
						if root then
							local vel = root.AssemblyLinearVelocity
							root.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0) -- Clear sideways momentum
						end
					end
					lastDir = moveDir
				end
			end)
		else
			if speedPanelData.mainConnection then
				speedPanelData.mainConnection:Disconnect()
				speedPanelData.mainConnection = nil
			end
			if speedPanelData.directionConnection then
				speedPanelData.directionConnection:Disconnect()
				speedPanelData.directionConnection = nil
			end
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		panel:Destroy()
		speedPanelData.panel = nil
		if speedPanelData.mainConnection then speedPanelData.mainConnection:Disconnect() speedPanelData.mainConnection = nil end
		if speedPanelData.directionConnection then speedPanelData.directionConnection:Disconnect() speedPanelData.directionConnection = nil end
	end)

	speedPanelData.panel = panel

	-- Persist after death (like loopspeed CharacterAdded)
	if speedPanelData.charConnection then speedPanelData.charConnection:Disconnect() end
	speedPanelData.charConnection = client.CharacterAdded:Connect(function(newChar)
		task.wait(0.4)
		char = newChar
		hum = newChar:WaitForChild("Humanoid", 5)
		if speedPanelData.enabled and hum then
			hum.WalkSpeed = speedPanelData.speedValue
		end
	end)
end
-- =============================================================
-- Vehicle fly 
-- =============================================================
local VehicleFlySystem = {
	enabled = false,
	uiSpeed = 1,
	actualSpeed = 50,
	speedMultiplier = 50,
	gui = nil,
	mainFrame = nil,
	flyBtn = nil,
	speedBox = nil,
	bodyGyro = nil,
	bodyVelocity = nil,
	connection = nil,
	currentVelocity = Vector3.new(0, 0, 0),
	lerpFactor = 0.25,
	vehicleSeat = nil,
	vehicleModel = nil
}

function VehicleFlySystem:CreatePanel()
	if self.gui then return end

	local playerGui = client:WaitForChild("PlayerGui")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "VehicleFlySystemPanel"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999999
	ScreenGui.Parent = playerGui
	self.gui = ScreenGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.new(0, 320, 0, 220)
	MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Parent = ScreenGui
	self.mainFrame = MainFrame

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = MainFrame

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 55)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
	}
	Gradient.Rotation = 90
	Gradient.Parent = MainFrame

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 45)
	TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 12)
	TopCorner.Parent = TopBar

	-- Title
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.6, 0, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "Vehicle fly:3"
	Title.Font = Enum.Font.Code
	Title.TextSize = 20
	Title.TextColor3 = Color3.fromRGB(255, 180, 50)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	-- Minimize Button
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 32, 0, 32)
	MinBtn.Position = UDim2.new(1, -75, 0.5, -16)
	MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	MinBtn.Text = "−"
	MinBtn.Font = Enum.Font.Code
	MinBtn.TextSize = 24
	MinBtn.TextColor3 = Color3.new(1, 1, 1)
	MinBtn.Parent = TopBar

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 8)
	MinCorner.Parent = MinBtn

	-- Close Button
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 32, 0, 32)
	CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	CloseBtn.Text = "×"
	CloseBtn.Font = Enum.Font.Code
	CloseBtn.TextSize = 22
	CloseBtn.TextColor3 = Color3.new(1, 1, 1)
	CloseBtn.Parent = TopBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseBtn

	-- Speed Label
	local SpeedLabel = Instance.new("TextLabel")
	SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
	SpeedLabel.Position = UDim2.new(0, 0, 0, 55)
	SpeedLabel.BackgroundTransparency = 1
	SpeedLabel.Text = "speed (1-10000)"
	SpeedLabel.Font = Enum.Font.Code
	SpeedLabel.TextSize = 14
	SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
	SpeedLabel.Parent = MainFrame

	-- Speed Input Box
	local SpeedInput = Instance.new("TextBox")
	SpeedInput.Size = UDim2.new(0, 180, 0, 45)
	SpeedInput.Position = UDim2.new(0.5, -90, 0, 85)
	SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	SpeedInput.Text = tostring(self.uiSpeed)
	SpeedInput.Font = Enum.Font.Code
	SpeedInput.TextSize = 22
	SpeedInput.TextColor3 = Color3.fromRGB(255, 200, 100)
	SpeedInput.ClearTextOnFocus = false
	SpeedInput.Parent = MainFrame

	local InputCorner = Instance.new("UICorner")
	InputCorner.CornerRadius = UDim.new(0, 10)
	InputCorner.Parent = SpeedInput

	self.speedBox = SpeedInput

	-- Stats Label
	local StatsLabel = Instance.new("TextLabel")
	StatsLabel.Size = UDim2.new(1, 0, 0, 20)
	StatsLabel.Position = UDim2.new(0, 0, 0, 135)
	StatsLabel.BackgroundTransparency = 1
	StatsLabel.Text = "Actual: 50 studs/sec"
	StatsLabel.Font = Enum.Font.Code
	StatsLabel.TextSize = 12
	StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
	StatsLabel.Parent = MainFrame

	-- Fly Toggle Button
	local FlyBtn = Instance.new("TextButton")
	FlyBtn.Size = UDim2.new(0, 200, 0, 50)
	FlyBtn.Position = UDim2.new(0.5, -100, 0, 160)
	FlyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
	FlyBtn.Text = "▶ start flying!"
	FlyBtn.Font = Enum.Font.Code
	FlyBtn.TextSize = 18
	FlyBtn.TextColor3 = Color3.new(1, 1, 1)
	FlyBtn.Parent = MainFrame

	local FlyCorner = Instance.new("UICorner")
	FlyCorner.CornerRadius = UDim.new(0, 12)
	FlyCorner.Parent = FlyBtn

	self.flyBtn = FlyBtn

	-- Controls Help
	local HelpLabel = Instance.new("TextLabel")
	HelpLabel.Size = UDim2.new(1, 0, 0, 20)
	HelpLabel.Position = UDim2.new(0, 0, 1, -25)
	HelpLabel.BackgroundTransparency = 1
	HelpLabel.Text = "WASD | Space ↑ | Shift ↓"
	HelpLabel.Font = Enum.Font.Code
	HelpLabel.TextSize = 11
	HelpLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
	HelpLabel.Parent = MainFrame

	-- Speed Input Handler
	SpeedInput.FocusLost:Connect(function()
		local newVal = tonumber(SpeedInput.Text)
		if newVal then
			newVal = math.clamp(math.floor(newVal), 1, 10000)
			self.uiSpeed = newVal
			self.actualSpeed = newVal * self.speedMultiplier
			SpeedInput.Text = tostring(newVal)
			StatsLabel.Text = "Actual: " .. self.actualSpeed .. " studs/sec"
			if self.enabled then
				notify("Vehicle fly speed: " .. newVal, Color3.fromRGB(255, 200, 100))
			end
		else
			SpeedInput.Text = tostring(self.uiSpeed)
		end
	end)

	-- Fly Button Handler
	FlyBtn.MouseButton1Click:Connect(function()
		self:ToggleFly()
	end)

	-- Minimize Handler
	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		if minimized then
			TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 45)}):Play()
			MinBtn.Text = "+"
			for _, obj in pairs(MainFrame:GetDescendants()) do
				if obj:IsA("GuiObject") and obj ~= TopBar and obj ~= MinBtn and obj ~= CloseBtn and obj.Parent ~= TopBar then
					obj.Visible = false
				end
			end
		else
			TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 220)}):Play()
			MinBtn.Text = "−"
			for _, obj in pairs(MainFrame:GetDescendants()) do
				if obj:IsA("GuiObject") then
					obj.Visible = true
				end
			end
		end
	end)

	-- Close Handler - just hides panel, doesn't stop fly
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
	end)
end

function VehicleFlySystem:GetVehiclePart()
	local char = client.Character
	if not char then return nil end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end

	local seat = hum.SeatPart
	if not seat then return nil end

	-- Find the vehicle model (parent of the seat)
	local vehicleModel = seat:FindFirstAncestorOfClass("Model")
	if not vehicleModel then
		vehicleModel = seat.Parent
	end

	-- Get the primary part or a suitable base part
	local vehiclePart = vehicleModel.PrimaryPart
	if not vehiclePart then
		-- Try to find a main chassis part
		for _, part in pairs(vehicleModel:GetDescendants()) do
			if part:IsA("BasePart") and part.Name:lower():match("chassis") or part.Name:lower():match("body") or part.Name:lower():match("base") then
				vehiclePart = part
				break
			end
		end
	end

	-- Fallback to the seat itself if no other part found
	if not vehiclePart then
		vehiclePart = seat
	end

	self.vehicleSeat = seat
	self.vehicleModel = vehicleModel

	return vehiclePart
end

function VehicleFlySystem:StartFly()
	local vehiclePart = self:GetVehiclePart()
	if not vehiclePart then
		notify("You must be in a vehicle seat!", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Anchor the vehicle part so physics doesn't fight us
	vehiclePart.Anchored = false

	-- Create BodyGyro to control rotation
	self.bodyGyro = Instance.new("BodyGyro")
	self.bodyGyro.P = 90000
	self.bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	self.bodyGyro.CFrame = vehiclePart.CFrame
	self.bodyGyro.Parent = vehiclePart

	-- Create BodyVelocity for movement
	self.bodyVelocity = Instance.new("BodyVelocity")
	self.bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	self.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	self.bodyVelocity.Parent = vehiclePart

	self.enabled = true
	self.currentVelocity = Vector3.new(0, 0, 0)

	if self.flyBtn then
		self.flyBtn.Text = "stop flying!"
		self.flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end

	self.connection = RunService.RenderStepped:Connect(function()
		if not self.enabled then return end

		local currentVehiclePart = self:GetVehiclePart()
		if not currentVehiclePart then
			self:StopFly()
			return
		end

		local cam = workspace.CurrentCamera

		if UserInputService:GetFocusedTextBox() then
			self.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			return
		end

		self.bodyGyro.CFrame = cam.CFrame

		local moveDir = Vector3.new(0, 0, 0)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end

		local targetVel = Vector3.new(0, 0, 0)
		if moveDir.Magnitude > 0 then
			targetVel = moveDir.Unit * self.actualSpeed
		end

		self.currentVelocity = self.currentVelocity:Lerp(targetVel, self.lerpFactor)
		self.bodyVelocity.Velocity = self.currentVelocity
	end)

	notify("Vehicle flying at speed " .. self.uiSpeed .. "!", Color3.fromRGB(255, 180, 50))
end

function VehicleFlySystem:StopFly()
	if not self.enabled then return end
	self.enabled = false

	if self.connection then self.connection:Disconnect() self.connection = nil end
	if self.bodyGyro then self.bodyGyro:Destroy() self.bodyGyro = nil end
	if self.bodyVelocity then self.bodyVelocity:Destroy() self.bodyVelocity = nil end

	self.currentVelocity = Vector3.new(0, 0, 0)
	self.vehicleSeat = nil
	self.vehicleModel = nil

	if self.flyBtn then
		self.flyBtn.Text = "▶ start fly!"
		self.flyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
	end

	notify("Vehicle fly stopped", Color3.fromRGB(255, 160, 60))
end

function VehicleFlySystem:ToggleFly()
	if self.enabled then self:StopFly() else self:StartFly() end
	return self.enabled
end

-- Death / seat exit handler
client.CharacterAdded:Connect(function()
	task.wait(0.1)
	if VehicleFlySystem.enabled then
		VehicleFlySystem:StopFly()
		if VehicleFlySystem.gui and VehicleFlySystem.flyBtn then
			VehicleFlySystem.flyBtn.Text = "▶ START VEHICLE FLY"
			VehicleFlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
		end
	end
end)

-- Monitor seat changes
local function monitorSeat()
	local char = client.Character
	if not char then return end
	local hum = char:WaitForChild("Humanoid")

	hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
		if not hum.SeatPart and VehicleFlySystem.enabled then
			VehicleFlySystem:StopFly()
		end
	end)
end

if client.Character then
	monitorSeat()
end
client.CharacterAdded:Connect(monitorSeat)

-- Command Functions
local function vehiclefly(plr, spd)
	if plr ~= client then
		notify("Vehicle fly only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Check if in a seat first
	local char = client.Character
	if not char then
		notify("Character not found!", Color3.fromRGB(255, 100, 100))
		return
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or not hum.SeatPart then
		notify("You must be in a vehicle seat first!", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Create panel if not exists
	VehicleFlySystem:CreatePanel()

	-- Update speed if provided
	if spd then
		local newSpeed = tonumber(spd)
		if newSpeed then
			VehicleFlySystem.uiSpeed = math.clamp(math.floor(newSpeed), 1, 10000)
			VehicleFlySystem.actualSpeed = VehicleFlySystem.uiSpeed * VehicleFlySystem.speedMultiplier
			if VehicleFlySystem.speedBox then
				VehicleFlySystem.speedBox.Text = tostring(VehicleFlySystem.uiSpeed)
			end
		end
	end

	-- Start flying immediately
	VehicleFlySystem:StartFly()

	-- Update button state
	if VehicleFlySystem.flyBtn then
		VehicleFlySystem.flyBtn.Text = "stop flying!"
		VehicleFlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end
end

local function unvehiclefly(plr)
	if plr ~= client then
		notify("Unvehiclefly only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	VehicleFlySystem:StopFly()

	-- Update button state
	if VehicleFlySystem.flyBtn then
		VehicleFlySystem.flyBtn.Text = "▶ start fly!"
		VehicleFlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
	end
end
-- =============================================================
-- Fly
-- =============================================================
local FlySystem = {
	enabled = false,
	uiSpeed = 1,
	actualSpeed = 50,
	speedMultiplier = 50,
	gui = nil,
	mainFrame = nil,
	flyBtn = nil,
	speedBox = nil,
	bodyGyro = nil,
	bodyVelocity = nil,
	connection = nil,
	currentVelocity = Vector3.new(0, 0, 0),
	lerpFactor = 0.25
}

function FlySystem:CreatePanel()
	if self.gui then return end

	local playerGui = client:WaitForChild("PlayerGui")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FlySystemPanel"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999999
	ScreenGui.Parent = playerGui
	self.gui = ScreenGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.new(0, 320, 0, 220)
	MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Parent = ScreenGui
	self.mainFrame = MainFrame

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = MainFrame

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 55)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
	}
	Gradient.Rotation = 90
	Gradient.Parent = MainFrame

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 45)
	TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainFrame

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 12)
	TopCorner.Parent = TopBar

	-- Title
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.6, 0, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "fly thingy!"
	Title.Font = Enum.Font.Code
	Title.TextSize = 20
	Title.TextColor3 = Color3.fromRGB(100, 200, 255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	-- Minimize Button
	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0, 32, 0, 32)
	MinBtn.Position = UDim2.new(1, -75, 0.5, -16)
	MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	MinBtn.Text = "−"
	MinBtn.Font = Enum.Font.Code
	MinBtn.TextSize = 24
	MinBtn.TextColor3 = Color3.new(1, 1, 1)
	MinBtn.Parent = TopBar

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 8)
	MinCorner.Parent = MinBtn

	-- Close Button
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 32, 0, 32)
	CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	CloseBtn.Text = "×"
	CloseBtn.Font = Enum.Font.Code
	CloseBtn.TextSize = 22
	CloseBtn.TextColor3 = Color3.new(1, 1, 1)
	CloseBtn.Parent = TopBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseBtn

	-- Speed Label
	local SpeedLabel = Instance.new("TextLabel")
	SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
	SpeedLabel.Position = UDim2.new(0, 0, 0, 55)
	SpeedLabel.BackgroundTransparency = 1
	SpeedLabel.Text = "speed (1-10000)"
	SpeedLabel.Font = Enum.Font.Code
	SpeedLabel.TextSize = 14
	SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
	SpeedLabel.Parent = MainFrame

	-- Speed Input Box
	local SpeedInput = Instance.new("TextBox")
	SpeedInput.Size = UDim2.new(0, 180, 0, 45)
	SpeedInput.Position = UDim2.new(0.5, -90, 0, 85)
	SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	SpeedInput.Text = tostring(self.uiSpeed)
	SpeedInput.Font = Enum.Font.Code
	SpeedInput.TextSize = 22
	SpeedInput.TextColor3 = Color3.fromRGB(100, 255, 150)
	SpeedInput.ClearTextOnFocus = false
	SpeedInput.Parent = MainFrame

	local InputCorner = Instance.new("UICorner")
	InputCorner.CornerRadius = UDim.new(0, 10)
	InputCorner.Parent = SpeedInput

	self.speedBox = SpeedInput

	-- Stats Label
	local StatsLabel = Instance.new("TextLabel")
	StatsLabel.Size = UDim2.new(1, 0, 0, 20)
	StatsLabel.Position = UDim2.new(0, 0, 0, 135)
	StatsLabel.BackgroundTransparency = 1
	StatsLabel.Text = "Actual: 50 studs/sec"
	StatsLabel.Font = Enum.Font.Code
	StatsLabel.TextSize = 12
	StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
	StatsLabel.Parent = MainFrame

	-- Fly Toggle Button
	local FlyBtn = Instance.new("TextButton")
	FlyBtn.Size = UDim2.new(0, 200, 0, 50)
	FlyBtn.Position = UDim2.new(0.5, -100, 0, 160)
	FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	FlyBtn.Text = "▶ start fly!"
	FlyBtn.Font = Enum.Font.Code
	FlyBtn.TextSize = 20
	FlyBtn.TextColor3 = Color3.new(1, 1, 1)
	FlyBtn.Parent = MainFrame

	local FlyCorner = Instance.new("UICorner")
	FlyCorner.CornerRadius = UDim.new(0, 12)
	FlyCorner.Parent = FlyBtn

	self.flyBtn = FlyBtn

	-- Controls Help
	local HelpLabel = Instance.new("TextLabel")
	HelpLabel.Size = UDim2.new(1, 0, 0, 20)
	HelpLabel.Position = UDim2.new(0, 0, 1, -25)
	HelpLabel.BackgroundTransparency = 1
	HelpLabel.Text = "WASD | Space ↑ | Shift ↓"
	HelpLabel.Font = Enum.Font.Code
	HelpLabel.TextSize = 11
	HelpLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
	HelpLabel.Parent = MainFrame

	-- Speed Input Handler
	SpeedInput.FocusLost:Connect(function()
		local newVal = tonumber(SpeedInput.Text)
		if newVal then
			newVal = math.clamp(math.floor(newVal), 1, 10000)
			self.uiSpeed = newVal
			self.actualSpeed = newVal * self.speedMultiplier
			SpeedInput.Text = tostring(newVal)
			StatsLabel.Text = "Actual: " .. self.actualSpeed .. " studs/sec"
			if self.enabled then
				notify("Fly speed: " .. newVal, Color3.fromRGB(100, 255, 100))
			end
		else
			SpeedInput.Text = tostring(self.uiSpeed)
		end
	end)

	-- Fly Button Handler
	FlyBtn.MouseButton1Click:Connect(function()
		self:ToggleFly()
	end)

	-- Minimize Handler
	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		if minimized then
			TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 45)}):Play()
			MinBtn.Text = "+"
			for _, obj in pairs(MainFrame:GetDescendants()) do
				if obj:IsA("GuiObject") and obj ~= TopBar and obj ~= MinBtn and obj ~= CloseBtn and obj.Parent ~= TopBar then
					obj.Visible = false
				end
			end
		else
			TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 220)}):Play()
			MinBtn.Text = "−"
			for _, obj in pairs(MainFrame:GetDescendants()) do
				if obj:IsA("GuiObject") then
					obj.Visible = true
				end
			end
		end
	end)

	-- Close Handler - just hides panel, doesn't stop fly
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
	end)
end

function FlySystem:StartFly()
	local char = client.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	hum.PlatformStand = true
	hum.AutoRotate = false

	self.bodyGyro = Instance.new("BodyGyro")
	self.bodyGyro.P = 90000
	self.bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	self.bodyGyro.CFrame = hrp.CFrame
	self.bodyGyro.Parent = hrp

	self.bodyVelocity = Instance.new("BodyVelocity")
	self.bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	self.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	self.bodyVelocity.Parent = hrp

	self.enabled = true
	self.currentVelocity = Vector3.new(0, 0, 0)

	-- Mobile detection
	local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

	if self.flyBtn then
		self.flyBtn.Text = "STOP FLY"
		self.flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end

	self.connection = RunService.RenderStepped:Connect(function()
		if not self.enabled then return end
		if not client.Character or not client.Character:FindFirstChild("HumanoidRootPart") then
			self:StopFly()
			return
		end

		local currentHrp = client.Character.HumanoidRootPart
		local cam = workspace.CurrentCamera

		if UserInputService:GetFocusedTextBox() then
			self.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			return
		end

		self.bodyGyro.CFrame = cam.CFrame

		local moveDir = Vector3.new(0, 0, 0)

		if isMobile then
	local hum = client.Character:FindFirstChildOfClass("Humanoid")

	if hum then
		local stickDir = hum.MoveDirection

		if stickDir.Magnitude > 0 then
			local camLook = cam.CFrame.LookVector
			local camRight = cam.CFrame.RightVector

			moveDir =
				(camLook * stickDir.Magnitude) +
				(camRight * (stickDir:Dot(camRight) * 0.5))
		end
	end
else
			-- PC: keyboard controls
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
		end

		local targetVel = Vector3.new(0, 0, 0)
		if moveDir.Magnitude > 0 then
			targetVel = moveDir.Unit * self.actualSpeed
		end

		self.currentVelocity = self.currentVelocity:Lerp(targetVel, self.lerpFactor)
		self.bodyVelocity.Velocity = self.currentVelocity
	end)

	notify("Flying at speed " .. self.uiSpeed .. "!", Color3.fromRGB(0, 255, 150))
end

function FlySystem:StopFly()
	if not self.enabled then return end
	self.enabled = false

	if self.connection then self.connection:Disconnect() self.connection = nil end
	if self.bodyGyro then self.bodyGyro:Destroy() self.bodyGyro = nil end
	if self.bodyVelocity then self.bodyVelocity:Destroy() self.bodyVelocity = nil end

	local char = client.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false hum.AutoRotate = true end

	self.currentVelocity = Vector3.new(0, 0, 0)

	if self.flyBtn then
		self.flyBtn.Text = "▶ start fly!"
		self.flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	end

	notify("Fly stopped", Color3.fromRGB(255, 160, 60))
end

function FlySystem:ToggleFly()
	if self.enabled then self:StopFly() else self:StartFly() end
	return self.enabled
end

-- Death handler
client.CharacterAdded:Connect(function()
	task.wait(0.1)
	if FlySystem.enabled then
		FlySystem:StopFly()
		if FlySystem.gui and FlySystem.flyBtn then
			FlySystem.flyBtn.Text = "▶ start flying!"
			FlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
		end
	end
end)

local function fly(plr, spd)
	if plr ~= client then
		notify("Fly only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Create panel if not exists
	FlySystem:CreatePanel()

	-- Update speed if provided
	if spd then
		local newSpeed = tonumber(spd)
		if newSpeed then
			FlySystem.uiSpeed = math.clamp(math.floor(newSpeed), 1, 10000)
			FlySystem.actualSpeed = FlySystem.uiSpeed * FlySystem.speedMultiplier
			if FlySystem.speedBox then
				FlySystem.speedBox.Text = tostring(FlySystem.uiSpeed)
			end
		end
	end

	-- Start flying immediately
	FlySystem:StartFly()

	-- Update button state
	if FlySystem.flyBtn then
		FlySystem.flyBtn.Text = "STOP FLY"
		FlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end
end

local function unfly(plr)
	if plr ~= client then
		notify("Unfly only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end

	FlySystem:StopFly()

	-- Update button state
	if FlySystem.flyBtn then
		FlySystem.flyBtn.Text = "▶ start flying!"
		FlySystem.flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	end
end
-- =============================================================
-- VIEW SYSTEM
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local viewData = {
	enabled = false,
	target = nil,
	originalCameraSubject = nil,
	originalCameraType = nil,
	originalWalkSpeed = 16,
	originalJumpPower = 50,
	originalPlatformStand = false,
	viewGui = nil,
}

local function freezeLocalCharacter(freeze)
	local char = LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if freeze then
		viewData.originalWalkSpeed     = hum.WalkSpeed
		viewData.originalJumpPower     = hum.JumpPower
		viewData.originalPlatformStand = hum.PlatformStand

		hum.WalkSpeed     = 0
		hum.JumpPower     = 0
		hum.PlatformStand = true  -- Prevents falling/sliding while frozen
	else
		hum.WalkSpeed     = viewData.originalWalkSpeed
		hum.JumpPower     = viewData.originalJumpPower
		hum.PlatformStand = viewData.originalPlatformStand


		task.delay(0.03, function()
			if hum and hum.Parent then
				hum:ChangeState(Enum.HumanoidStateType.Running)

			end
		end)
	end
end

local function view(targetPlayer)
	if viewData.enabled then
		notify("⚠️ Already viewing someone! Use !unview first", Color3.fromRGB(255, 100, 100))
		return
	end

	if not targetPlayer or not targetPlayer.Character then
		notify("❌ Player not found or has no character", Color3.fromRGB(255, 100, 100))
		return
	end

	local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not targetHum or targetHum.Health <= 0 then
		notify("❌ Target is dead or has no Humanoid", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Store originals
	viewData.enabled          = true
	viewData.target           = targetPlayer
	viewData.originalCameraSubject = Camera.CameraSubject
	viewData.originalCameraType    = Camera.CameraType

	-- Freeze your own character
	freezeLocalCharacter(true)

	Camera.CameraSubject = targetHum
	Camera.CameraType    = Enum.CameraType.Custom   

	-- Top label
	local viewGui = Instance.new("ScreenGui")
	viewGui.Name = "SpectateGui"
	viewGui.ResetOnSpawn = false
	viewGui.DisplayOrder = 999999
	viewGui.Parent = client.PlayerGui 

	local label = Instance.new("TextLabel")
	label.Size           = UDim2.new(0, 360, 0, 40)
	label.Position       = UDim2.new(0.5, -180, 0, 10)
	label.BackgroundTransparency = globalConfig.uiTransparency or 0.45
	label.BackgroundColor3 = currentTheme.glass or Color3.fromRGB(20, 20, 40)
	label.Text           = "👁️  Spectating: " .. targetPlayer.Name .. "  (@" .. targetPlayer.DisplayName .. ")  — Use mouse to look around"
	label.Font           = Enum.Font.Code
	label.TextSize       = 18
	label.TextColor3     = globalConfig.textColor or Color3.fromRGB(230, 230, 255)
	label.TextStrokeTransparency = 0.7
	label.TextStrokeColor3 = Color3.new(0,0,0)
	label.BorderSizePixel = 0
	label.Parent = viewGui

	if applyGlassEffect then
		applyGlassEffect(label, globalConfig.uiTransparency or 0.45, 0.35)
	end

	viewData.viewGui = viewGui

	notify("👁️ Now viewing " .. targetPlayer.Name .. " — full free look like you're them", Color3.fromRGB(100, 255, 100))
end

local function unview()
	if not viewData.enabled then
		notify("⚠️ Not viewing anyone", Color3.fromRGB(255, 100, 100))
		return
	end

	viewData.enabled = false

	-- Restore camera **before** unfreezing (prevents glitches)
	Camera.CameraSubject = viewData.originalCameraSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
	Camera.CameraType    = viewData.originalCameraType or Enum.CameraType.Custom

	-- Unfreeze
	freezeLocalCharacter(false)

	-- Clean up GUI
	if viewData.viewGui then
		viewData.viewGui:Destroy()
		viewData.viewGui = nil
	end

	viewData.target = nil
	viewData.originalCameraSubject = nil
	viewData.originalCameraType = nil

	notify("Stopped spectating — back to normal", Color3.fromRGB(255, 160, 60))
end

-- Auto-stop if target disappears/dies/leaves
Players.PlayerRemoving:Connect(function(plr)
	if viewData.target == plr and viewData.enabled then
		unview()
	end
end)

LocalPlayer.CharacterRemoving:Connect(function()
	if viewData.enabled then
		unview()
	end
end)
-- =============================================================
-- JOIN LOGS PANEL
-- =============================================================
local joinLogsData = {
	panel = nil,
	entries = {},
	connections = {}
}

local function createJoinLogsPanel()
	if joinLogsData.panel then
		joinLogsData.panel:Destroy()
		joinLogsData.panel = nil
		for _, conn in ipairs(joinLogsData.connections) do
			conn:Disconnect()
		end
		joinLogsData.connections = {}
		return
	end

	local panel = Instance.new("ScreenGui")
	panel.Name = "JoinLogsPanel"
	panel.ResetOnSpawn = false
	panel.DisplayOrder = 999999
	panel.Parent = client.PlayerGui

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 500, 0, 400)
	main.Position = UDim2.new(0.5, -250, 0.5, -200)
	main.BackgroundColor3 = currentTheme.glass
	main.Active = true
	main.Draggable = true
	main.Parent = panel
	applyGlassEffect(main, globalConfig.uiTransparency, 0.4)

	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(1, -50, 0, 45)
	title.Position = UDim2.new(0, 15, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = "JOIN/LEAVE LOGS"
	title.Font = Enum.Font.Code
	title.TextSize = 22
	title.TextColor3 = currentTheme.accent
	title.TextTransparency = 0 -- SOLID
	title.TextStrokeTransparency = 0.5
	title.TextStrokeColor3 = Color3.new(0,0,0)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -45, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.Code
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.TextTransparency = 0 -- SOLID
	applyGlassEffect(closeBtn, 0.2, 0.4)

	local headers = Instance.new("Frame", main)
	headers.Size = UDim2.new(1, -20, 0, 30)
	headers.Position = UDim2.new(0, 10, 0, 55)
	headers.BackgroundColor3 = currentTheme.btn
	applyGlassEffect(headers, 0.3, 0.6)

	local timeHeader = Instance.new("TextLabel", headers)
	timeHeader.Size = UDim2.new(0.2, 0, 1, 0)
	timeHeader.BackgroundTransparency = 1
	timeHeader.Text = "Time"
	timeHeader.Font = Enum.Font.Code
	timeHeader.TextSize = 14
	timeHeader.TextColor3 = globalConfig.textColor
	timeHeader.TextTransparency = 0 -- SOLID
	timeHeader.TextStrokeTransparency = 0.5
	timeHeader.TextStrokeColor3 = Color3.new(0,0,0)

	local userHeader = Instance.new("TextLabel", headers)
	userHeader.Size = UDim2.new(0.4, 0, 1, 0)
	userHeader.Position = UDim2.new(0.2, 0, 0, 0)
	userHeader.BackgroundTransparency = 1
	userHeader.Text = "Username"
	userHeader.Font = Enum.Font.Code
	userHeader.TextSize = 14
	userHeader.TextColor3 = globalConfig.textColor
	userHeader.TextTransparency = 0 -- SOLID
	userHeader.TextStrokeTransparency = 0.5
	userHeader.TextStrokeColor3 = Color3.new(0,0,0)

	local distHeader = Instance.new("TextLabel", headers)
	distHeader.Size = UDim2.new(0.2, 0, 1, 0)
	distHeader.Position = UDim2.new(0.6, 0, 0, 0)
	distHeader.BackgroundTransparency = 1
	distHeader.Text = "Distance"
	distHeader.Font = Enum.Font.Code
	distHeader.TextSize = 14
	distHeader.TextColor3 = globalConfig.textColor
	distHeader.TextTransparency = 0 -- SOLID
	distHeader.TextStrokeTransparency = 0.5
	distHeader.TextStrokeColor3 = Color3.new(0,0,0)

	local actionHeader = Instance.new("TextLabel", headers)
	actionHeader.Size = UDim2.new(0.2, 0, 1, 0)
	actionHeader.Position = UDim2.new(0.8, 0, 0, 0)
	actionHeader.BackgroundTransparency = 1
	actionHeader.Text = "Action"
	actionHeader.Font = Enum.Font.Code
	actionHeader.TextSize = 14
	actionHeader.TextColor3 = globalConfig.textColor
	actionHeader.TextTransparency = 0 -- SOLID
	actionHeader.TextStrokeTransparency = 0.5
	actionHeader.TextStrokeColor3 = Color3.new(0,0,0)

	local scroll = Instance.new("ScrollingFrame", main)
	scroll.Size = UDim2.new(1, -20, 1, -100)
	scroll.Position = UDim2.new(0, 10, 0, 90)
	scroll.BackgroundTransparency = 0.4
	scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	scroll.ScrollBarThickness = 8
	scroll.ScrollBarImageColor3 = currentTheme.accent
	applyGlassEffect(scroll, 0.5, 0.7)

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local function addLogEntry(plr, action)
		local entry = Instance.new("Frame")
		entry.Size = UDim2.new(1, -10, 0, 35)
		entry.BackgroundColor3 = action == "JOINED" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
		entry.BackgroundTransparency = 0.8
		entry.BorderSizePixel = 0

		local timeLabel = Instance.new("TextLabel", entry)
		timeLabel.Size = UDim2.new(0.2, 0, 1, 0)
		timeLabel.BackgroundTransparency = 1
		timeLabel.Text = os.date("%H:%M:%S")
		timeLabel.Font = Enum.Font.Code
		timeLabel.TextSize = 12
		timeLabel.TextColor3 = globalConfig.textColor
		timeLabel.TextTransparency = 0 -- SOLID
		timeLabel.TextStrokeTransparency = 0.5
		timeLabel.TextStrokeColor3 = Color3.new(0,0,0)

		local userLabel = Instance.new("TextLabel", entry)
		userLabel.Size = UDim2.new(0.4, 0, 1, 0)
		userLabel.Position = UDim2.new(0.2, 0, 0, 0)
		userLabel.BackgroundTransparency = 1
		userLabel.Text = plr.Name
		userLabel.Font = Enum.Font.Code
		userLabel.TextSize = 14
		userLabel.TextColor3 = globalConfig.textColor
		userLabel.TextTransparency = 0 -- SOLID
		userLabel.TextStrokeTransparency = 0.5
		userLabel.TextStrokeColor3 = Color3.new(0,0,0)

		local dist = "N/A"
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and hrp then
			dist = math.floor((plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) .. " studs"
		end

		local distLabel = Instance.new("TextLabel", entry)
		distLabel.Size = UDim2.new(0.2, 0, 1, 0)
		distLabel.Position = UDim2.new(0.6, 0, 0, 0)
		distLabel.BackgroundTransparency = 1
		distLabel.Text = dist
		distLabel.Font = Enum.Font.Code
		distLabel.TextSize = 12
		distLabel.TextColor3 = globalConfig.textColor
		distLabel.TextTransparency = 0 -- SOLID
		distLabel.TextStrokeTransparency = 0.5
		distLabel.TextStrokeColor3 = Color3.new(0,0,0)

		local actionLabel = Instance.new("TextLabel", entry)
		actionLabel.Size = UDim2.new(0.2, 0, 1, 0)
		actionLabel.Position = UDim2.new(0.8, 0, 0, 0)
		actionLabel.BackgroundTransparency = 1
		actionLabel.Text = action
		actionLabel.Font = Enum.Font.Code
		actionLabel.TextSize = 14
		actionLabel.TextColor3 = action == "JOINED" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
		actionLabel.TextTransparency = 0 -- SOLID
		actionLabel.TextStrokeTransparency = 0.5
		actionLabel.TextStrokeColor3 = Color3.new(0,0,0)

		entry.Parent = scroll
		table.insert(joinLogsData.entries, entry)

		if #joinLogsData.entries > 50 then
			joinLogsData.entries[1]:Destroy()
			table.remove(joinLogsData.entries, 1)
		end

		scroll.CanvasSize = UDim2.new(0, 0, 0, #joinLogsData.entries * 40)
		scroll.CanvasPosition = Vector2.new(0, #joinLogsData.entries * 40)
	end

	local joinConn = Players.PlayerAdded:Connect(function(plr)
		addLogEntry(plr, "JOINED")
	end)

	local leaveConn = Players.PlayerRemoving:Connect(function(plr)
		addLogEntry(plr, "LEFT")
	end)

	table.insert(joinLogsData.connections, joinConn)
	table.insert(joinLogsData.connections, leaveConn)

	closeBtn.MouseButton1Click:Connect(function()
		panel:Destroy()
		joinLogsData.panel = nil
		for _, conn in ipairs(joinLogsData.connections) do
			conn:Disconnect()
		end
		joinLogsData.connections = {}
	end)

	joinLogsData.panel = panel
	notify("Join logs panel opened", Color3.fromRGB(100, 255, 100))
end

-- =============================================================
-- ENHANCED ESP 
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local client = Players.LocalPlayer

-- ============================================
-- ESP DATA - PERSISTENT TRACKING
-- ============================================
local espData = {
	enabled = false,
	playerESP = {},
	globalConnections = {},
	distanceConn = nil,
	myCharConn = nil,
	globalEnabled = false,
	trackedUserIds = {},
	individualTargets = {}
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function getMyHRP()
	local char = client.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local function clearPlayerESP(plr)
	local data = espData.playerESP[plr]
	if not data then return end

	for _, conn in ipairs(data.connections or {}) do
		if conn then conn:Disconnect() end
	end
	data.connections = {}

	for _, obj in ipairs(data.objects or {}) do
		if obj and obj.Parent then
			pcall(function() obj:Destroy() end)
		end
	end
	data.objects = {}
	data.distLabel = nil

	espData.playerESP[plr] = nil
end

local function clearAllESP()
	for plr, _ in pairs(espData.playerESP) do
		clearPlayerESP(plr)
	end
	espData.playerESP = {}
end

-- ============================================
-- CORE ESP ATTACHMENT
-- ============================================
local function attachESP(plr, char)
	if plr == client then return end
	if not char then return end

	-- Always clear old first to prevent duplicates
	clearPlayerESP(plr)

	local data = {
		connections = {},
		objects = {},
		distLabel = nil,
		lastChar = char
	}

	espData.playerESP[plr] = data

	-- Wait for parts with timeout
	local head = char:WaitForChild("Head", 5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if not head or not hrp then 
		-- Retry once after short delay
		task.delay(1, function()
			if plr.Character and plr.Character ~= char then
				attachESP(plr, plr.Character)
			end
		end)
		return 
	end

	local teamColor = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 80, 80)

	-- HIGHLIGHT (Chams)
	local highlight = Instance.new("Highlight")
	highlight.Name = "LunarESP_" .. plr.Name
	highlight.Adornee = char
	highlight.FillTransparency = 0.85
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.FillColor = teamColor
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = workspace
	table.insert(data.objects, highlight)

	-- BILLBOARD GUI
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "LunarESP_Billboard_" .. plr.Name
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2.8, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 10000
	billboard.Parent = client.PlayerGui

	-- Name Label
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, 0, 0.55, 0)
	nameLabel.Font = Enum.Font.Code
	nameLabel.TextSize = 14
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	nameLabel.Text = plr.DisplayName ~= plr.Name and "@" .. plr.Name .. " (" .. plr.DisplayName .. ")" or "@" .. plr.Name
	nameLabel.TextColor3 = teamColor
	nameLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	nameLabel.Parent = billboard

	-- Distance Label
	local distLabel = Instance.new("TextLabel")
	distLabel.Name = "Distance"
	distLabel.BackgroundTransparency = 1
	distLabel.Position = UDim2.new(0, 0, 0.55, 0)
	distLabel.Size = UDim2.new(1, 0, 0.45, 0)
	distLabel.Font = Enum.Font.Code
	distLabel.TextSize = 12
	distLabel.TextStrokeTransparency = 0.4
	distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	distLabel.Text = "0 studs"
	distLabel.TextYAlignment = Enum.TextYAlignment.Top
	distLabel.Parent = billboard

	table.insert(data.objects, billboard)
	data.distLabel = distLabel

	-- Health tracking
	if humanoid then
		local healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			local healthPercent = humanoid.Health / humanoid.MaxHealth
			if healthPercent <= 0 then
				for _, obj in ipairs(data.objects) do
					if obj:IsA("Highlight") then
						obj.FillTransparency = 1
						obj.OutlineTransparency = 0.8
					end
				end
				if nameLabel then
					nameLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
				end
			else
				for _, obj in ipairs(data.objects) do
					if obj:IsA("Highlight") then
						obj.FillTransparency = 0.85
						obj.OutlineTransparency = 0
					end
				end
				if nameLabel then
					nameLabel.TextColor3 = teamColor
				end
			end
		end)
		table.insert(data.connections, healthConn)

		-- Death handler - IMMEDIATELY reattach on respawn (NO DELAY)
		local diedConn = humanoid.Died:Connect(function()
			-- Clear current ESP immediately
			clearPlayerESP(plr)

			-- Wait for new character and reattach if ESP is still enabled for this player
			local newCharConn
			newCharConn = plr.CharacterAdded:Connect(function(newChar)
				if newCharConn then
					newCharConn:Disconnect()
				end
				-- Check if this player should still have ESP (global or individual)
				local shouldTrack = espData.globalEnabled or espData.trackedUserIds[plr.UserId] or espData.individualTargets[plr.UserId]
				if shouldTrack then
					task.wait(0.3)
					attachESP(plr, newChar)
				end
			end)
		end)
		table.insert(data.connections, diedConn)
	end

	-- Team change handler
	local teamConn = plr:GetPropertyChangedSignal("Team"):Connect(function()
		local newColor = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 80, 80)
		for _, obj in ipairs(data.objects) do
			if obj:IsA("Highlight") then
				obj.FillColor = newColor
			end
		end
		if nameLabel then
			nameLabel.TextColor3 = newColor
		end
	end)
	table.insert(data.connections, teamConn)

	-- Character removing handler (for when they reset without dying)
	local charRemovingConn = char.AncestryChanged:Connect(function()
		if not char.Parent then
			-- Character was destroyed, clear ESP
			task.delay(0.1, function()
				if not plr.Character or plr.Character ~= char then
					clearPlayerESP(plr)
				end
			end)
		end
	end)
	table.insert(data.connections, charRemovingConn)
end

-- ============================================
-- SETUP ESP FOR SINGLE PLAYER
-- ============================================
local function createPlayerESP(plr)
	if plr == client then return end

	-- Apply immediately if they have character
	if plr.Character then
		task.spawn(function()
			attachESP(plr, plr.Character)
		end)
	end

	-- Handle their respawns
	local charConn = plr.CharacterAdded:Connect(function(char)
		-- Check if this player should still have ESP
		local shouldTrack = espData.globalEnabled or espData.trackedUserIds[plr.UserId] or espData.individualTargets[plr.UserId]
		if shouldTrack then
			task.wait(0.3)
			clearPlayerESP(plr)
			attachESP(plr, char)
		end
	end)

	if not espData.playerESP[plr] then
		espData.playerESP[plr] = { connections = { charConn }, objects = {}, distLabel = nil }
	else
		table.insert(espData.playerESP[plr].connections, charConn)
	end
end

-- ============================================
-- DISTANCE UPDATER (ROBUST)
-- ============================================
local function startDistanceUpdater()
	if espData.distanceConn then return end

	espData.distanceConn = RunService.RenderStepped:Connect(function()
		local myHRP = getMyHRP()

		for plr, data in pairs(espData.playerESP) do
			-- Skip if player left
			if not plr or not plr.Parent then
				clearPlayerESP(plr)
			else
				-- Update distance if possible
				if data.distLabel and data.distLabel.Parent then
					if myHRP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						local targetHRP = plr.Character.HumanoidRootPart
						local dist = (targetHRP.Position - myHRP.Position).Magnitude
						data.distLabel.Text = math.floor(dist) .. " studs"
					else
						data.distLabel.Text = "..."
					end
				end
			end
		end
	end)
end

-- ============================================
-- ENABLE ESP FOR SPECIFIC PLAYER
-- ============================================
function enableESPPlayer(targetPlr)
	if not targetPlr then
		notify("Player not found", Color3.fromRGB(255, 100, 100))
		return
	end

	if targetPlr == client then
		notify("Can't ESP yourself", Color3.fromRGB(255, 200, 100))
		return
	end

	-- NEW: Add to persistent tracking
	espData.individualTargets[targetPlr.UserId] = true
	-- Also track by UserId for rejoin persistence
	espData.trackedUserIds[targetPlr.UserId] = true

	startDistanceUpdater()
	createPlayerESP(targetPlr)
	notify("ESP enabled for " .. targetPlr.Name, Color3.fromRGB(0, 255, 100))
end

-- ============================================
-- DISABLE ESP FOR SPECIFIC PLAYER
-- ============================================
function disableESPPlayer(targetPlr)
	if not targetPlr then
		notify("Player not found", Color3.fromRGB(255, 100, 100))
		return
	end

	-- NEW: Remove from persistent tracking
	espData.individualTargets[targetPlr.UserId] = nil
	espData.trackedUserIds[targetPlr.UserId] = nil

	clearPlayerESP(targetPlr)
	notify("ESP disabled for " .. targetPlr.Name, Color3.fromRGB(255, 180, 0))
end

-- ============================================
-- ENABLE ESP FOR ALL (GLOBAL)
-- ============================================
function enableESPAll()
	if espData.globalEnabled then return end
	espData.globalEnabled = true
	espData.enabled = true

	-- NEW: Track all current players by UserId
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= client then
			espData.trackedUserIds[plr.UserId] = true
		end
	end

	-- Apply to ALL current players
	for _, plr in ipairs(Players:GetPlayers()) do
		createPlayerESP(plr)
	end

	-- Auto-apply to NEW players joining
	local newPlayerConn = Players.PlayerAdded:Connect(function(plr)
		if espData.globalEnabled then
			-- NEW: Automatically track new players
			espData.trackedUserIds[plr.UserId] = true
			task.wait(0.5)
			createPlayerESP(plr)
		end
	end)
	table.insert(espData.globalConnections, newPlayerConn)

	-- Handle players LEAVING
	local playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
		clearPlayerESP(plr)
		-- NEW: Keep them tracked so ESP reapplies if they rejoin
		-- (don't remove from trackedUserIds - they stay tracked)
	end)
	table.insert(espData.globalConnections, playerRemovingConn)

	-- Handle MY respawn - reapply all ESP
	if espData.myCharConn then
		espData.myCharConn:Disconnect()
	end

	espData.myCharConn = client.CharacterAdded:Connect(function()
		task.wait(0.8)
		if not espData.globalEnabled then return end

		-- Clear and reapply all
		for plr, _ in pairs(espData.playerESP) do
			clearPlayerESP(plr)
		end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= client then
				createPlayerESP(plr)
			end
		end
	end)

	-- NEW: Handle rejoins - when a tracked player rejoins, reapply ESP
	local rejoinConn = Players.PlayerAdded:Connect(function(plr)
		if espData.trackedUserIds[plr.UserId] then
			-- This player was previously tracked, reapply ESP
			task.wait(0.5)
			if plr.Character then
				attachESP(plr, plr.Character)
			end
			createPlayerESP(plr)
		end
	end)
	table.insert(espData.globalConnections, rejoinConn)

	startDistanceUpdater()
	notify("ESP enabled for all players", Color3.fromRGB(0, 255, 100))
end

-- ============================================
-- DISABLE ESP FOR ALL (GLOBAL)
-- ============================================
function disableESPAll()
	if not espData.globalEnabled and not next(espData.playerESP) then
		notify("ESP not active", Color3.fromRGB(255, 200, 100))
		return
	end

	espData.globalEnabled = false
	espData.enabled = false

	-- NEW: Clear ALL tracking
	espData.trackedUserIds = {}
	espData.individualTargets = {}

	-- Disconnect global connections
	if espData.myCharConn then
		espData.myCharConn:Disconnect()
		espData.myCharConn = nil
	end

	for _, conn in ipairs(espData.globalConnections) do
		if conn then conn:Disconnect() end
	end
	espData.globalConnections = {}

	-- Clear all player ESP
	clearAllESP()

	-- Clean up distance conn
	if espData.distanceConn then
		espData.distanceConn:Disconnect()
		espData.distanceConn = nil
	end

	notify("ESP disabled for ALL", Color3.fromRGB(255, 180, 0))
end
-- =============================================================
-- SPIN SYSTEM
-- =============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local spinData = {}

function spin(plr, speed)

	speed = tonumber(speed) or 20
	speed = math.clamp(speed, 1, 10000)

	local char = plr.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	-- Stop old spin
	if spinData[plr] then
		unspin(plr)
	end

	hum.AutoRotate = false

	-- Attachment (YOU ALREADY HAD THIS)
	local attachment = Instance.new("Attachment")
	attachment.Name = "SpinAttachment"
	attachment.Parent = hrp

	-- REAL SPIN MOTOR (replaces AlignOrientation only)
	local angular = Instance.new("AngularVelocity")
	angular.Name = "SpinVelocity"
	angular.Attachment0 = attachment
	angular.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	angular.MaxTorque = math.huge

	-- the actual speed you type
	angular.AngularVelocity = Vector3.new(0, speed, 0)

	angular.Parent = hrp

	spinData[plr] = {
		attachment = attachment,
		angular = angular,
		connection = nil
	}

	-- keep server ownership so Roblox doesn't override it
	spinData[plr].connection = RunService.Stepped:Connect(function()
		if hrp and hrp.Parent then
			pcall(function()
				hrp:SetNetworkOwner(nil)
			end)
		end
	end)
end


function unspin(plr)

	local data = spinData[plr]
	if not data then return end

	if data.connection then
		data.connection:Disconnect()
	end

	if data.angular then
		data.angular:Destroy()
	end

	if data.attachment then
		data.attachment:Destroy()
	end

	local char = plr.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.AutoRotate = true
		end
	end

	spinData[plr] = nil
end


Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		unspin(plr)
	end)
end)

-- =============================================================
-- LEAVE COMMAND
-- =============================================================
local function leaveGame()
	game:Shutdown()
	notify("👋 Leaving game...", Color3.fromRGB(255, 100, 100))
end

-- =============================================================
-- unload script
-- =============================================================
local function unload()
	local CoreGui = game:GetService("CoreGui")

	-- Destroy from both PlayerGui and CoreGui
	local function destroyMatchingGuis(parent)
		for _, gui in ipairs(parent:GetChildren()) do
			if gui:IsA("ScreenGui") and (
				gui.Name == "LunarGui" or 
				gui.Name == "LunarNotifs" or 
				gui.Name == "LunarWatermark" or
				gui.Name == "LunarCrosshair" or
				gui.Name == "LunarCrosshairCMD" or
				gui.Name == "AimbotPanel" or 
				gui.Name == "logsPanel" or 
				gui.Name == "stopwatchPanel" or
				gui.Name == "SpeedPanel" or 
				gui.Name == "JoinLogsPanel" or
				gui.Name == "ViewGui" or
				gui.Name == "CmdBarGui" or 
				gui.Name:find("^Lunar") or 
				gui.Name:find("Panel")
			) then
				gui:Destroy()
			end
		end
	end

	destroyMatchingGuis(client.PlayerGui)
	destroyMatchingGuis(CoreGui)

	-- === CRITICAL: Stop crosshair/watermark via _G data ===
	if _G.LunarCrosshairData then
		_G.LunarCrosshairData.enabled = false
		if _G.LunarCrosshairData.connection then
			_G.LunarCrosshairData.connection:Disconnect()
			_G.LunarCrosshairData.connection = nil
		end
		if _G.LunarCrosshairData.gui then
			_G.LunarCrosshairData.gui:Destroy()
			_G.LunarCrosshairData.gui = nil
		end
	end

	-- Clean up other data tables
	local dataTables = {speedPanelData, viewData, spinData}
	for _, data in ipairs(dataTables) do
		if data then
			for k, v in pairs(data) do
				if typeof(v) == "RBXScriptConnection" then
					v:Disconnect()
				end
			end
			if data.enabled ~= nil then data.enabled = false end
			if data.gui and typeof(data.gui) == "Instance" then
				pcall(function() data.gui:Destroy() end)
			end
		end
	end

	-- Disable features
	pcall(disableESPAll)
	pcall(disableFreecam)

	-- Restore chat
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	end)

	-- Nuke commands
	processCmd = function() end
	_G.processCmd = function() end

	if addcmd then addcmd = function() end end
	if notify then notify = function() end end

	pcall(function()
		notify("💥 Script fully destroyed", Color3.fromRGB(255, 80, 80))
	end)
end

-- ============================================
-- INFINITE JUMP 
-- ============================================
local infJumpData = {
	enabled = false,
	beganConnection = nil,
	endedConnection = nil,
	jumpRequestConnection = nil,
	charConnection = nil,
	heartbeatConnection = nil,
	holdingJump = false,
	currentChar = nil,
	currentHRP = nil
}

local function setupInfJump()
	local char = client.Character
	if not char then
		return
	end

	infJumpData.currentChar = char

	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if hrp then
		infJumpData.currentHRP = hrp
	end
end

local function enableInfJump()
	if infJumpData.enabled then
		notify("⚠️ Infinite jump already enabled", Color3.fromRGB(255, 200, 100))
		return
	end

	infJumpData.enabled = true
	infJumpData.holdingJump = false

	setupInfJump()

	-- Cleanup old connections
	if infJumpData.beganConnection then
		infJumpData.beganConnection:Disconnect()
	end

	if infJumpData.endedConnection then
		infJumpData.endedConnection:Disconnect()
	end

	if infJumpData.jumpRequestConnection then
		infJumpData.jumpRequestConnection:Disconnect()
	end

	if infJumpData.heartbeatConnection then
		infJumpData.heartbeatConnection:Disconnect()
	end

	-- PC Space Key
	infJumpData.beganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not infJumpData.enabled then
			return
		end

		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Space then
			infJumpData.holdingJump = true
		end
	end)

	infJumpData.endedConnection = UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			infJumpData.holdingJump = false
		end
	end)

	-- Mobile + Controller Jump Button
	infJumpData.jumpRequestConnection = UserInputService.JumpRequest:Connect(function()
		if not infJumpData.enabled then
			return
		end

		local hrp = infJumpData.currentHRP

		if hrp and hrp.Parent then
			local vel = hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity = Vector3.new(
				vel.X,
				math.max(vel.Y + 15, 60),
				vel.Z
			)
		end
	end)

	-- Hold Space Flight
	infJumpData.heartbeatConnection = RunService.Heartbeat:Connect(function()
		if not infJumpData.enabled then
			return
		end

		if not infJumpData.holdingJump then
			return
		end

		local hrp = infJumpData.currentHRP

		if hrp and hrp.Parent then
			local vel = hrp.AssemblyLinearVelocity

			if vel.Y <= 25 then
				hrp.AssemblyLinearVelocity = Vector3.new(
					vel.X,
					math.max(vel.Y + 5, 50),
					vel.Z
				)
			end
		end
	end)

	-- Respawn Support
	if infJumpData.charConnection then
		infJumpData.charConnection:Disconnect()
	end

	infJumpData.charConnection = client.CharacterAdded:Connect(function()
		task.wait(0.5)

		if infJumpData.enabled then
			setupInfJump()
		end
	end)

	notify("Infinite jump enabled", Color3.fromRGB(0, 255, 100))
end

local function disableInfJump()
	if not infJumpData.enabled then
		notify("⚠️ Infinite jump not enabled", Color3.fromRGB(255, 200, 100))
		return
	end

	infJumpData.enabled = false
	infJumpData.holdingJump = false

	if infJumpData.beganConnection then
		infJumpData.beganConnection:Disconnect()
		infJumpData.beganConnection = nil
	end

	if infJumpData.endedConnection then
		infJumpData.endedConnection:Disconnect()
		infJumpData.endedConnection = nil
	end

	if infJumpData.jumpRequestConnection then
		infJumpData.jumpRequestConnection:Disconnect()
		infJumpData.jumpRequestConnection = nil
	end

	if infJumpData.heartbeatConnection then
		infJumpData.heartbeatConnection:Disconnect()
		infJumpData.heartbeatConnection = nil
	end

	if infJumpData.charConnection then
		infJumpData.charConnection:Disconnect()
		infJumpData.charConnection = nil
	end

	infJumpData.currentChar = nil
	infJumpData.currentHRP = nil

	notify("❌ Infinite jump disabled", Color3.fromRGB(255, 100, 100))
end
-- =============================================================
-- Aimbot
-- =============================================================
local aimbotData = {
	enabled = false,
	smoothness = 0.5,
	smoothnessEnabled = true,
	teamCheck = true, -- ON by default so you don't lock teammates
	wallCheck = false,
	targetTeam = nil,
	aimPart = "HumanoidRootPart",
	predictionEnabled = false,
	predictionAmount = 0.15,
	
	-- Sticky target system
	currentTarget = nil,
	targetLockTime = 0,
	targetStickiness = 0.3, -- seconds to stick to target before allowing switch
	
	panel = nil,
	teamsList = nil,
	connection = nil,
	inputBeganConn = nil,
	inputEndedConn = nil,
	minimized = false,
	mainFrame = nil,
	rightClickHeld = false,
	fovCircle = nil,
	fovEnabled = false,
	fovSize = 150
}

local function createAimbotPanel()
	local CoreGui = game:GetService("CoreGui")

	-- Cleanup
	if aimbotData.panel then aimbotData.panel:Destroy() end
	if aimbotData.connection then aimbotData.connection:Disconnect() end
	if aimbotData.inputBeganConn then aimbotData.inputBeganConn:Disconnect() end
	if aimbotData.inputEndedConn then aimbotData.inputEndedConn:Disconnect() end
	if aimbotData.fovCircle then aimbotData.fovCircle:Remove() end

	aimbotData.enabled = false
	aimbotData.targetTeam = nil
	aimbotData.currentTarget = nil
	aimbotData.minimized = false
	aimbotData.rightClickHeld = false

	-- COREGUI
	local panel = Instance.new("ScreenGui")
	panel.Name = "AimbotPanel"
	panel.ResetOnSpawn = false
	panel.DisplayOrder = 2147483646
	panel.ZIndexBehavior = Enum.ZIndexBehavior.Global
	panel.ScreenInsets = Enum.ScreenInsets.None
	panel.IgnoreGuiInset = true
	panel.Parent = CoreGui

	-- MAIN FRAME
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 420, 0, 520)
	main.Position = UDim2.new(0, 430, 0.5, -260)
	main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = true
	main.ClipsDescendants = true
	main.ZIndex = 2147483646
	main.Parent = panel
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	aimbotData.mainFrame = main

	-- TITLE BAR
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 2147483646
	titleBar.Parent = main
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "🎯 AIMBOT"
	title.Font = Enum.Font.Code
	title.TextSize = 22
	title.TextColor3 = currentTheme.accent
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextStrokeTransparency = 0.5
	title.TextStrokeColor3 = Color3.new(0,0,0)
	title.ZIndex = 2147483647
	title.Parent = titleBar

	-- Minimize
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
	minimizeBtn.Position = UDim2.new(1, -75, 0.5, -17.5)
	minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	minimizeBtn.Text = "−"
	minimizeBtn.Font = Enum.Font.Code
	minimizeBtn.TextSize = 20
	minimizeBtn.TextColor3 = Color3.new(1,1,1)
	minimizeBtn.BorderSizePixel = 0
	minimizeBtn.ZIndex = 2147483647
	minimizeBtn.Parent = titleBar
	Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

	-- Close
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeBtn.Text = "×"
	closeBtn.Font = Enum.Font.Code
	closeBtn.TextSize = 22
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.BorderSizePixel = 0
	closeBtn.ZIndex = 2147483647
	closeBtn.Parent = titleBar
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	closeBtn.MouseButton1Click:Connect(function()
		aimbotData.enabled = false
		if aimbotData.connection then aimbotData.connection:Disconnect() end
		if aimbotData.inputBeganConn then aimbotData.inputBeganConn:Disconnect() end
		if aimbotData.inputEndedConn then aimbotData.inputEndedConn:Disconnect() end
		if aimbotData.fovCircle then aimbotData.fovCircle:Remove() end

		panel:Destroy()
		aimbotData.panel = nil
		aimbotData.currentTarget = nil
		notify("Aimbot closed. Use !aimbot to reopen.", Color3.fromRGB(255, 160, 60))
	end)

	minimizeBtn.MouseButton1Click:Connect(function()
		aimbotData.minimized = not aimbotData.minimized
		if aimbotData.minimized then
			main:TweenSize(UDim2.new(0, 420, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			contentScroll.Visible = false
			minimizeBtn.Text = "+"
		else
			main:TweenSize(UDim2.new(0, 420, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			contentScroll.Visible = true
			minimizeBtn.Text = "−"
		end
	end)

	-- CONTENT
	local contentScroll = Instance.new("ScrollingFrame")
	contentScroll.Name = "Content"
	contentScroll.Size = UDim2.new(1, -20, 1, -60)
	contentScroll.Position = UDim2.new(0, 10, 0, 55)
	contentScroll.BackgroundTransparency = 1
	contentScroll.BorderSizePixel = 0
	contentScroll.ScrollBarThickness = 6
	contentScroll.ScrollBarImageColor3 = currentTheme.accent
	contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentScroll.ZIndex = 2147483646
	contentScroll.Parent = main

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Parent = contentScroll

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 20)
	padding.Parent = contentScroll

	-- Helpers
	local function createHeader(text)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0.95, 0, 0, 32)
		container.BackgroundColor3 = currentTheme.accent
		container.BorderSizePixel = 0
		container.ZIndex = 2147483646
		container.Parent = contentScroll
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.Code
		label.TextSize = 14
		label.TextColor3 = Color3.new(0, 0, 0)
		label.TextStrokeTransparency = 0.8
		label.ZIndex = 2147483647
		label.Parent = container
		return container
	end

	local function createButton()
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.95, 0, 0, 40)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
		btn.Font = Enum.Font.Code
		btn.TextSize = 15
		btn.AutoButtonColor = true
		btn.BorderSizePixel = 0
		btn.ZIndex = 2147483646
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		return btn
	end

	local function createToggle(name, key, callback)
		local btn = createButton()
		btn.Text = name .. ": " .. (aimbotData[key] and "ON ✓" or "OFF ✗")
		btn.TextColor3 = aimbotData[key] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
		btn.TextStrokeTransparency = 0.5
		btn.TextStrokeColor3 = Color3.new(0,0,0)
		btn.Parent = contentScroll

		btn.MouseButton1Click:Connect(function()
			aimbotData[key] = not aimbotData[key]
			btn.Text = name .. ": " .. (aimbotData[key] and "ON ✓" or "OFF ✗")
			btn.TextColor3 = aimbotData[key] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
			if callback then callback(aimbotData[key]) end
		end)
		return btn
	end

	-- TARGETING SECTION
	createHeader("lunar loves femboys")

	-- Team Check (auto-detects your team)
	createToggle("Team Check (Auto)", "teamCheck", function(enabled)
		if enabled then
			notify("Team Check ON — Won't lock teammates", Color3.fromRGB(100, 255, 100))
		else
			notify("Team Check OFF — Will lock anyone", Color3.fromRGB(255, 100, 100))
		end
	end)

	-- Wall Check
	createToggle("Wall Check", "wallCheck")

	-- Aim Part
	local aimPartBtn = createButton()
	aimPartBtn.Text = "Aim Part: " .. (aimbotData.aimPart == "Head" and "HEAD" or "TORSO")
	aimPartBtn.TextColor3 = currentTheme.accent
	aimPartBtn.Parent = contentScroll
	aimPartBtn.MouseButton1Click:Connect(function()
		aimbotData.aimPart = aimbotData.aimPart == "Head" and "HumanoidRootPart" or "Head"
		aimPartBtn.Text = "Aim Part: " .. (aimbotData.aimPart == "Head" and "HEAD" or "TORSO")
	end)

	-- SETTINGS SECTION
	createHeader("blah blah blah")

	createToggle("Aimbot Enabled", "enabled")
	createToggle("Smoothness", "smoothnessEnabled")

	-- FOV Circle Toggle
	createToggle("FOV Circle", "fovEnabled", function(enabled)
		if enabled then
			if not aimbotData.fovCircle then
				aimbotData.fovCircle = Drawing.new("Circle")
				aimbotData.fovCircle.Thickness = 2
				aimbotData.fovCircle.NumSides = 64
				aimbotData.fovCircle.Filled = false
				aimbotData.fovCircle.Visible = true
			end
			notify("FOV Circle ON — Only locks inside circle", Color3.fromRGB(100, 200, 255))
		else
			if aimbotData.fovCircle then
				aimbotData.fovCircle.Visible = false
			end
		end
	end)

	-- Prediction
	createToggle("Prediction", "predictionEnabled")

	-- SLIDERS
	createHeader("blah blah blah")

	local function createSlider(labelText, dataKey, minVal, maxVal, isInt)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0.95, 0, 0, 55)
		container.BackgroundTransparency = 1
		container.ZIndex = 2147483646
		container.Parent = contentScroll

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 22)
		label.BackgroundTransparency = 1
		label.Text = labelText .. ": " .. aimbotData[dataKey]
		label.Font = Enum.Font.Code
		label.TextSize = 14
		label.TextColor3 = globalConfig.textColor
		label.ZIndex = 2147483647
		label.Parent = container

		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(1, 0, 0, 10)
		sliderFrame.Position = UDim2.new(0, 0, 0, 28)
		sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		sliderFrame.BorderSizePixel = 0
		sliderFrame.ZIndex = 2147483646
		sliderFrame.Parent = container
		Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 5)

		local fill = Instance.new("Frame")
		fill.BackgroundColor3 = currentTheme.accent
		fill.BorderSizePixel = 0
		fill.ZIndex = 2147483647
		fill.Parent = sliderFrame
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

		local drag = Instance.new("TextButton")
		drag.Size = UDim2.new(0, 16, 0, 16)
		drag.BackgroundColor3 = Color3.new(1,1,1)
		drag.BorderSizePixel = 0
		drag.Text = ""
		drag.ZIndex = 2147483647
		drag.Parent = sliderFrame
		Instance.new("UICorner", drag).CornerRadius = UDim.new(1, 0)

		local dragging = false
		drag.InputBegan:Connect(function(i) 
			if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end 
		end)
		UserInputService.InputEnded:Connect(function(i) 
			if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
		end)

		UserInputService.InputChanged:Connect(function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				local percent = math.clamp((i.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				drag.Position = UDim2.new(percent, -8, 0.5, -8)

				local value = minVal + percent * (maxVal - minVal)
				if isInt then value = math.floor(value) else value = math.round(value * 100) / 100 end
				aimbotData[dataKey] = value
				label.Text = labelText .. ": " .. value
			end
		end)

		local initP = (aimbotData[dataKey] - minVal) / (maxVal - minVal)
		fill.Size = UDim2.new(initP, 0, 1, 0)
		drag.Position = UDim2.new(initP, -8, 0.5, -8)
	end

	createSlider("Smoothness", "smoothness", 0.1, 1, false)
	createSlider("Prediction", "predictionAmount", 0, 0.5, false)
	createSlider("FOV Size", "fovSize", 50, 400, true)

	aimbotData.panel = panel

	-- ================= STICKY AIMBOT LOGIC =================
	local function isValidTarget(plr)
		if not plr or plr == client or not plr.Character then return false end
		local char = plr.Character
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return false end

		-- Team check: auto-detect your current team
		if aimbotData.teamCheck and client.Team and plr.Team and client.Team == plr.Team then
			return false
		end

		if aimbotData.wallCheck then
			local cam = workspace.CurrentCamera
			local root = char:FindFirstChild(aimbotData.aimPart) or char:FindFirstChild("HumanoidRootPart")
			if not root then return false end
			local origin = cam.CFrame.Position
			local dir = (root.Position - origin) * 0.95
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = {client.Character or Instance.new("Folder"), char}
			params.FilterType = Enum.RaycastFilterType.Blacklist
			local result = workspace:Raycast(origin, dir, params)
			if result then return false end
		end
		return true
	end

	local function getTargetPosition(rootPart)
		local pos = rootPart.Position
		if aimbotData.predictionEnabled and rootPart.AssemblyLinearVelocity then
			local vel = rootPart.AssemblyLinearVelocity
			local dist = (pos - workspace.CurrentCamera.CFrame.Position).Magnitude
			pos = pos + vel * (dist / 1000) * aimbotData.predictionAmount
		end
		return pos
	end

	local function getDistanceToMouse(plr)
		local mousePos = UserInputService:GetMouseLocation()
		local cam = workspace.CurrentCamera
		local root = plr.Character:FindFirstChild(aimbotData.aimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
		if not root then return math.huge end

		local pos = getTargetPosition(root)
		local screenPos, onScreen = cam:WorldToViewportPoint(pos)
		if not onScreen then return math.huge end

		-- FOV check
		if aimbotData.fovEnabled then
			local centerDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
			if centerDist > aimbotData.fovSize then return math.huge end
		end

		return (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
	end

	-- STICKY TARGET: Once locked, stay on them unless they die/go offscreen for too long
	local function updateStickyTarget()
		local now = tick()

		-- Check if current target is still valid
		if aimbotData.currentTarget then
			if not isValidTarget(aimbotData.currentTarget) then
				aimbotData.currentTarget = nil
				aimbotData.targetLockTime = 0
			else
				local dist = getDistanceToMouse(aimbotData.currentTarget)
				-- Still in FOV? Keep them
				if dist < math.huge then
					aimbotData.targetLockTime = now
					return aimbotData.currentTarget
				end
				-- Out of FOV for more than 0.3s? Allow switch
				if now - aimbotData.targetLockTime > 0.3 then
					aimbotData.currentTarget = nil
				else
					return aimbotData.currentTarget -- still sticky
				end
			end
		end

		-- Find new target
		local closest, closestDist = nil, math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			if isValidTarget(plr) then
				local dist = getDistanceToMouse(plr)
				if dist < closestDist then
					closestDist = dist
					closest = plr
				end
			end
		end

		if closest then
			aimbotData.currentTarget = closest
			aimbotData.targetLockTime = now
		end

		return closest
	end

	-- FOV Circle update
	local fovConnection = RunService.RenderStepped:Connect(function()
		if aimbotData.fovEnabled and aimbotData.fovCircle then
			local mousePos = UserInputService:GetMouseLocation()
			aimbotData.fovCircle.Position = mousePos
			aimbotData.fovCircle.Radius = aimbotData.fovSize
			aimbotData.fovCircle.Color = aimbotData.currentTarget and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(100, 200, 255)
			aimbotData.fovCircle.Visible = true
		elseif aimbotData.fovCircle then
			aimbotData.fovCircle.Visible = false
		end
	end)

	-- Main aimbot loop
	aimbotData.connection = RunService.RenderStepped:Connect(function()
		if not (aimbotData.enabled and aimbotData.rightClickHeld) then
			aimbotData.currentTarget = nil
			return
		end

		local target = updateStickyTarget()
		if not target or not target.Character then return end

		local root = target.Character:FindFirstChild(aimbotData.aimPart) or target.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local predictedPos = getTargetPosition(root)
		local screenPos = workspace.CurrentCamera:WorldToViewportPoint(predictedPos)
		local mousePos = UserInputService:GetMouseLocation()
		local targetScreen = Vector2.new(screenPos.X, screenPos.Y)

		local moveVec
		if aimbotData.smoothnessEnabled then
			moveVec = mousePos:Lerp(targetScreen, 1 - aimbotData.smoothness)
		else
			moveVec = targetScreen
		end

		if mousemoverel then
			mousemoverel(moveVec.X - mousePos.X, moveVec.Y - mousePos.Y)
		end
	end)

	aimbotData.inputBeganConn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			aimbotData.rightClickHeld = true
		end
	end)

	aimbotData.inputEndedConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			aimbotData.rightClickHeld = false
			aimbotData.currentTarget = nil -- release target on right-click up
		end
	end)

	notify("Aimbot loaded! Right-click to lock. Sticky target enabled.", Color3.fromRGB(100, 200, 255))
end
-- =============================================================
-- UNLOCK MOUSE SYSTEM
-- =============================================================
local mouseUnlockData = {
	enabled = false,
	connection = nil
}

local function toggleMouseUnlock()
	mouseUnlockData.enabled = not mouseUnlockData.enabled

	if mouseUnlockData.enabled then
		notify("Mouse unlock enabled! Press F to toggle lock/unlock", Color3.fromRGB(100, 255, 100))

		mouseUnlockData.connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
				local currentState = UserInputService.MouseBehavior
				if currentState == Enum.MouseBehavior.LockCenter then
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
					UserInputService.MouseIconEnabled = true
					notify("🔓 Mouse UNLOCKED - Move freely", Color3.fromRGB(100, 255, 100))
				else
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
					UserInputService.MouseIconEnabled = false
					notify("🔒 Mouse LOCKED - FPS mode", Color3.fromRGB(255, 100, 100))
				end
			end
		end)
	else
		if mouseUnlockData.connection then
			mouseUnlockData.connection:Disconnect()
			mouseUnlockData.connection = nil
		end
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
		notify("❌ Mouse unlock disabled", Color3.fromRGB(255, 100, 100))
	end
end

-- =============================================================
-- panel management
-- =============================================================
local subPanels = {
	logs = nil,
	stopwatch = nil
}

local function createSubPanel(name, size, titleText)
	local existing = client.PlayerGui:FindFirstChild(name .. "Panel")
	if existing then
		existing:Destroy()
		if subPanels[name] then
			subPanels[name] = nil
		end
		return nil
	end

	local panel = Instance.new("ScreenGui")
	panel.Name = name .. "Panel"
	panel.ResetOnSpawn = false
	panel.DisplayOrder = 999999
	panel.Parent = client.PlayerGui

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = size
	main.Position = UDim2.new(0, 430, 0.5, -size.Y.Offset/2)
	main.BackgroundColor3 = currentTheme.glass
	main.Active = true
	main.Draggable = true
	main.Parent = panel
	applyGlassEffect(main, globalConfig.uiTransparency, 0.4)

	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(1, -50, 0, 45)
	title.Position = UDim2.new(0, 15, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.Font = Enum.Font.Code
	title.TextSize = 22
	title.TextColor3 = currentTheme.accent
	title.TextTransparency = 0 -- SOLID
	title.TextStrokeTransparency = 0.5
	title.TextStrokeColor3 = Color3.new(0,0,0)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -45, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.Code
	closeBtn.TextSize = 20
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.TextTransparency = 0 -- SOLID
	applyGlassEffect(closeBtn, 0.2, 0.4)

	closeBtn.MouseButton1Click:Connect(function()
		panel:Destroy()
		subPanels[name] = nil
	end)

	subPanels[name] = panel
	return main
end

-- =============================================================
-- Logs panel
-- =============================================================
local logsScroll, logEntries = nil, {}

local function addLog(sender, message)
	if not logsScroll or not logsScroll.Parent then return end
	if #logEntries > 70 then
		if logEntries[1] then logEntries[1]:Destroy() end
		table.remove(logEntries, 1)
	end
	local entry = Instance.new("TextLabel")
	entry.Size = UDim2.new(1, -16, 0, 32)
	entry.BackgroundTransparency = 0.8
	entry.BackgroundColor3 = currentTheme.btn
	entry.TextXAlignment = Enum.TextXAlignment.Left
	entry.RichText = true
	entry.Text = " <font color='rgb(140,180,255)'><b>" .. sender .. "</b></font>: " .. message
	entry.TextColor3 = globalConfig.textColor
	entry.TextSize = 15
	entry.Font = Enum.Font.Code
	entry.TextWrapped = true
	entry.TextTransparency = 0 -- SOLID
	entry.TextStrokeTransparency = 0.5
	entry.TextStrokeColor3 = Color3.new(0,0,0)
	entry.Parent = logsScroll
	applyGlassEffect(entry, 0.6, 0.8)
	table.insert(logEntries, entry)
	logsScroll.CanvasSize = UDim2.new(0,0,0, #logEntries * 36)
	logsScroll.CanvasPosition = Vector2.new(0, #logEntries * 36)
end

local function toggleLogs()
	if subPanels.logs then
		subPanels.logs:Destroy()
		subPanels.logs = nil
		logsScroll = nil
		return
	end

	local main = createSubPanel("logs", UDim2.new(0, 420, 0, 380), "CHAT LOGS")
	if not main then return end

	logsScroll = Instance.new("ScrollingFrame", main)
	logsScroll.Size = UDim2.new(1, -20, 1, -65)
	logsScroll.Position = UDim2.new(0, 10, 0, 55)
	logsScroll.BackgroundTransparency = 0.4
	logsScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	logsScroll.ScrollBarThickness = 8
	logsScroll.ScrollBarImageColor3 = currentTheme.accent
	applyGlassEffect(logsScroll, 0.5, 0.7)

	local layout = Instance.new("UIListLayout", logsScroll)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local clearBtn = Instance.new("TextButton", main)
	clearBtn.Size = UDim2.new(0, 90, 0, 35)
	clearBtn.Position = UDim2.new(1, -140, 0, 5)
	clearBtn.BackgroundColor3 = currentTheme.btn
	clearBtn.Text = "Clear"
	clearBtn.Font = Enum.Font.Code
	clearBtn.TextSize = 16
	clearBtn.TextColor3 = globalConfig.textColor
	clearBtn.TextTransparency = 0 -- SOLID
	applyGlassEffect(clearBtn, 0.25, 0.5)

	clearBtn.MouseButton1Click:Connect(function()
		for _, entry in ipairs(logEntries) do
			if entry then entry:Destroy() end
		end
		logEntries = {}
		logsScroll.CanvasSize = UDim2.new(0,0,0,0)
	end)

	notify("Logs panel opened", Color3.fromRGB(180,180,255))
end

TextChatService.MessageReceived:Connect(function(msg)
	if msg.TextSource then
		addLog(msg.TextSource.Name, msg.Text)
	end
end)

-- =============================================================
-- Stopwatch panel
-- =============================================================
local stopwatchData = {
	running = false,
	startTime = 0,
	conn = nil,
	label = nil
}

local function toggleStopwatch()
	if subPanels.stopwatch then
		subPanels.stopwatch:Destroy()
		subPanels.stopwatch = nil
		if stopwatchData.conn then
			stopwatchData.conn:Disconnect()
			stopwatchData.conn = nil
		end
		stopwatchData.running = false
		return
	end

	local main = createSubPanel("stopwatch", UDim2.new(0, 380, 0, 220), "STOPWATCH")
	if not main then return end

	local timeLabel = Instance.new("TextLabel", main)
	timeLabel.Size = UDim2.new(1, -20, 0, 90)
	timeLabel.Position = UDim2.new(0, 10, 0, 55)
	timeLabel.BackgroundTransparency = 0.3
	timeLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	timeLabel.Text = "00:00.00"
	timeLabel.Font = Enum.Font.Code
	timeLabel.TextSize = 56
	timeLabel.TextColor3 = currentTheme.accent
	timeLabel.TextTransparency = 0 -- SOLID
	timeLabel.TextStrokeTransparency = 0.5
	timeLabel.TextStrokeColor3 = Color3.new(0,0,0)
	applyGlassEffect(timeLabel, 0.4, 0.6)

	local btnFrame = Instance.new("Frame", main)
	btnFrame.Size = UDim2.new(1, -20, 0, 55)
	btnFrame.Position = UDim2.new(0, 10, 0, 155)
	btnFrame.BackgroundTransparency = 1

	local startBtn = Instance.new("TextButton", btnFrame)
	startBtn.Size = UDim2.new(0.48, 0, 1, 0)
	startBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	startBtn.Text = "START"
	startBtn.Font = Enum.Font.Code
	startBtn.TextSize = 22
	startBtn.TextColor3 = Color3.new(0,0,0)
	startBtn.TextTransparency = 0 -- SOLID
	applyGlassEffect(startBtn, 0.15, 0.4)

	local resetBtn = Instance.new("TextButton", btnFrame)
	resetBtn.Size = UDim2.new(0.48, 0, 1, 0)
	resetBtn.Position = UDim2.new(0.52, 0, 0, 0)
	resetBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	resetBtn.Text = "RESET"
	resetBtn.Font = Enum.Font.Code
	resetBtn.TextSize = 22
	resetBtn.TextColor3 = Color3.new(0,0,0)
	resetBtn.TextTransparency = 0 -- SOLID
	applyGlassEffect(resetBtn, 0.15, 0.4)

	local function formatTime(t)
		local mins = math.floor(t / 60)
		local secs = math.floor(t % 60)
		local ms = math.floor((t % 1) * 100)
		return string.format("%02d:%02d.%02d", mins, secs, ms)
	end

	startBtn.MouseButton1Click:Connect(function()
		if stopwatchData.running then
			stopwatchData.running = false
			if stopwatchData.conn then
				stopwatchData.conn:Disconnect()
				stopwatchData.conn = nil
			end
			startBtn.Text = "RESUME"
			startBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		else
			stopwatchData.running = true
			local current = tick()
			stopwatchData.startTime = current - (stopwatchData.startTime or 0)
			stopwatchData.conn = RunService.Heartbeat:Connect(function()
				if stopwatchData.running then
					local elapsed = tick() - stopwatchData.startTime
					timeLabel.Text = formatTime(elapsed)
				end
			end)
			startBtn.Text = "PAUSE"
			startBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
		end
	end)

	resetBtn.MouseButton1Click:Connect(function()
		stopwatchData.running = false
		if stopwatchData.conn then
			stopwatchData.conn:Disconnect()
			stopwatchData.conn = nil
		end
		stopwatchData.startTime = 0
		timeLabel.Text = "00:00.00"
		startBtn.Text = "START"
		startBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	end)

	stopwatchData.label = timeLabel
	notify("Stopwatch panel opened", Color3.fromRGB(200, 200, 255))
end

-- =============================================================
-- Remove waypoint
-- =============================================================
local function removeWaypoint()
	if #waypoints == 0 then
		notify("⚠️ No waypoints to remove", Color3.fromRGB(255, 100, 100))
		return
	end

	local last = waypoints[#waypoints]
	if last then
		if last.conn then last.conn:Disconnect() end
		if last.part then last.part:Destroy() end
		table.remove(waypoints, #waypoints)
		notify("Removed waypoint #" .. (#waypoints + 1), Color3.fromRGB(255, 160, 60))
	end
end

-- =============================================================
-- UTILITIES
-- =============================================================
local function getPlr(str)
	if not str or str:lower() == "me" then return client end
	str = str:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1,#str) == str or (p.DisplayName or ""):lower():sub(1,#str) == str then
			return p
		end
	end
	return nil
end

local function getHRP(p)
	local c = p.Character
	if c then
		local part = c:FindFirstChild("HumanoidRootPart")
		if part then
			return part
		end
	end
	return nil
end

local function getHum(p)
	local c = p.Character
	if c then
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum then
			return hum
		end
	end
	return nil
end

-- =============================================================
-- ALL COMMANDS
-- =============================================================
local noclipConn
local frozen = {}
local gods = {}
local invis = {}
local rainbowData = {}
local ragdolls = {}
------------------------------------------------
--  speed
------------------------------------------------
local function setspeed(plr, num)
	if plr ~= client then
		notify("❌ Speed only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if hum then
		hum.WalkSpeed = tonumber(num) or 16
		notify("WalkSpeed set to " .. hum.WalkSpeed, currentTheme.accent)
	end
end
------------------------------------------------
-- noclip
------------------------------------------------
local function noclip(plr)
	if plr ~= client then
		notify("❌ Noclip only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	if noclipConn then 
		notify("⚠️ Noclip already enabled", Color3.fromRGB(255, 200, 100))
		return 
	end
	noclipConn = RunService.Stepped:Connect(function()
		if client.Character then
			for _, part in client.Character:GetDescendants() do
				if part:IsA("BasePart") then
					pcall(function() part.CanCollide = false end)
				end
			end
		end
	end)
	notify("Noclip enabled", Color3.fromRGB(100, 255, 120))
end
------------------------------------------------
-- unnoclip
------------------------------------------------
local function unnoclip(plr)
	if plr ~= client then
		notify("❌ Unnoclip only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
	if client.Character then
		for _, part in client.Character:GetDescendants() do
			if part:IsA("BasePart") then
				pcall(function() part.CanCollide = true end)
			end
		end
	end
	notify("⚠️Noclip disabled", Color3.fromRGB(255, 120, 100))
end
------------------------------------------------
-- kill
------------------------------------------------
local function kill(plr)
	local char = plr and plr.Character
	if not char then 
		notify("⚠️DOES NOT WORK⚠️", Color3.fromRGB(255, 100, 100))
		return 
	end
	pcall(function()
		local hum = getHum(plr)
		if hum then hum.Health = 0 end
		char:BreakJoints()
	end)
	notify("Only works in FTAP ⚠️DOES NOT WORK⚠️" .. plr.Name, Color3.fromRGB(255, 80, 80))
end
------------------------------------------------
-- tp
------------------------------------------------
local function tp(p1, p2)
	if p1 ~= client then
		notify("❌ Teleport only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	if not p2 then
		notify("❌ No target player specified", Color3.fromRGB(255, 100, 100))
		return
	end
	local h1, h2 = getHRP(p1), getHRP(p2)
	if h1 and h2 then
		h1.CFrame = h2.CFrame * CFrame.new(0, 3, 0)
		notify("Teleported to " .. p2.Name, currentTheme.accent)
	else
		notify("❌ Teleport failed - missing character parts", Color3.fromRGB(255, 100, 100))
	end
end
------------------------------------------------
-- to
------------------------------------------------
local function gotoMe(target)
	if not target then
		notify("❌ No target specified", Color3.fromRGB(255, 100, 100))
		return
	end
	tp(client, target)
end
------------------------------------------------
-- Jumppower
------------------------------------------------
local function jump(plr, pow)
	if plr ~= client then
		notify("❌ Jump only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if hum then
		hum.JumpPower = tonumber(pow) or 50
		notify("Jump power set to " .. hum.JumpPower, Color3.fromRGB(200, 200, 100))
	end
end
------------------------------------------------
-- sit
------------------------------------------------
local function sit(plr)
	if plr ~= client then
		notify("❌ Sit only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if hum then 
		hum.Sit = true 
		notify("Sitting", Color3.fromRGB(200, 150, 255))
	end
end
------------------------------------------------
-- Lay
------------------------------------------------
local function lay(plr)
	if plr ~= client then
		notify("❌ Lay only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if hum then
		hum.Sit = true
		task.wait(0.1)
		local hrp = getHRP(plr)
		if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0) end
		notify("Laying down", Color3.fromRGB(200, 150, 255))
	end
end
------------------------------------------------
-- Freeze
------------------------------------------------
local function freeze(plr)
	if plr ~= client then
		notify("❌ Freeze only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if not hum or frozen[plr] then 
		notify("⚠️ Already frozen", Color3.fromRGB(255, 200, 100))
		return 
	end
	frozen[plr] = {ws = hum.WalkSpeed, jp = hum.JumpPower}
	hum.WalkSpeed = 0
	hum.JumpPower = 0
	notify("Frozen", Color3.fromRGB(100, 100, 255))
end
------------------------------------------------
-- Unfreeze
------------------------------------------------
local function unfreeze(plr)
	if plr ~= client then
		notify("❌ Unfreeze only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local data = frozen[plr]
	local hum = getHum(plr)
	if data and hum then
		hum.WalkSpeed = data.ws
		hum.JumpPower = data.jp
		frozen[plr] = nil
		notify("Unfrozen", Color3.fromRGB(200, 100, 200))
	else
		notify("⚠️Not frozen", Color3.fromRGB(255, 200, 100))
	end
end
------------------------------------------------
-- Fling/clicktp (ALL FLINGS USE SAME WORKING METHOD)
------------------------------------------------
TouchFling = {
	enabled = false,
	flingAll = false,
	lockFling = false,
	clickTP = false,
	oneTimeTP = false,
	selectedPlayer = nil,
	movel = 0.1,
	clickTPKey = Enum.KeyCode.E,
	isSelectingKey = false,
	gui = nil,
	mainFrame = nil,
	toggles = {},
	buttons = {},
	isMinimized = false,
	flingAllIndex = 1,
	flingAllTimer = 0,
	isMobile = false,
	-- NEW: Track the active fling loop thread so we can stop it
	flingThread = nil,
	-- NEW: Track if fling loop should stop
	stopFling = false,
	-- NEW: For fling all - track current target and whether to move on
	flingAllCurrentTarget = nil,
	flingAllStuckTimer = 0,
	_t = nil,
	_v = nil,
	_p = nil,
	_c = nil,
	_b = nil,
	_l = nil,
	_s = nil,
	_f = nil,
	_m = nil,
	_n = nil,
	_o = nil,
	_r = nil,
	_u = nil,
	_d = false,
	_g = nil,
	_h = nil,
	_i = nil,
	_j = nil,
	_k = nil,
	_q = nil,
	_w = nil,
	_x = nil,
	_y = nil,
	_z = nil,
	_a = nil,
	_e = nil
}

-- Check mobile
TouchFling._v = workspace.CurrentCamera.ViewportSize
if UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or not UserInputService.MouseEnabled or TouchFling._v.X < 700 or TouchFling._v.Y < 500) then
	TouchFling.isMobile = true
end

function TouchFling:UpdateToggle(name, displayName)
	TouchFling._t = self[name]
	TouchFling._b = self.toggles[name]
	if TouchFling._b then
		TouchFling._b.Text = displayName .. ": " .. (TouchFling._t and "ON" or "OFF")
		if name == "lockFling" then
			TouchFling._b.TextColor3 = TouchFling._t and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(255, 80, 80)
		else
			TouchFling._b.TextColor3 = TouchFling._t and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80)
		end
	end
end

function TouchFling:UpdateKeybindButton()
	TouchFling._b = self.toggles.keybindBtn
	if TouchFling._b then
		TouchFling._t = self.clickTPKey and self.clickTPKey.Name or "None"
		if self.clickTPKey == "MouseButton1" then TouchFling._t = "Mouse1" end
		if self.clickTPKey == "MouseButton2" then TouchFling._t = "Mouse2" end
		TouchFling._b.Text = "Click TP Key: " .. TouchFling._t
		TouchFling._b.TextColor3 = Color3.fromRGB(100, 200, 255)
	end
end

function TouchFling:SelectPlayer(player)
	self.selectedPlayer = player
	for plr, btn in pairs(self.buttons) do
		if btn and btn.Parent then
			btn.BackgroundColor3 = (plr == player) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 50)
		end
	end
end

function TouchFling:ToggleMinimize()
	if not self.mainFrame then return end
	TouchFling._t = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TouchFling._f = self.mainFrame
	if not self.isMinimized then
		self.isMinimized = true
		TweenService:Create(TouchFling._f, TouchFling._t, {Size = UDim2.new(0, TouchFling._f.Size.X.Offset, 0, 40)}):Play()
		for _, obj in pairs(TouchFling._f:GetDescendants()) do
			if obj:IsA("TextButton") and obj.Name ~= "MinimizeBtn" and obj.Name ~= "CloseBtn" then
				TweenService:Create(obj, TouchFling._t, {TextTransparency = 1}):Play()
			elseif obj:IsA("TextLabel") and obj.Name ~= "Title" then
				TweenService:Create(obj, TouchFling._t, {TextTransparency = 1}):Play()
			elseif obj:IsA("ScrollingFrame") or (obj:IsA("Frame") and obj.Name ~= "TopBar") then
				TweenService:Create(obj, TouchFling._t, {BackgroundTransparency = 1}):Play()
			end
		end
		TouchFling._b = TouchFling._f:FindFirstChild("TopBar") and TouchFling._f.TopBar:FindFirstChild("MinimizeBtn")
		if TouchFling._b then TouchFling._b.Text = "+" end
	else
		self.isMinimized = false
		TouchFling._h = self.isMobile and 420 or 540
		TweenService:Create(TouchFling._f, TouchFling._t, {Size = UDim2.new(0, TouchFling._f.Size.X.Offset, 0, TouchFling._h)}):Play()
		for _, obj in pairs(TouchFling._f:GetDescendants()) do
			if obj:IsA("TextButton") and obj.Name ~= "MinimizeBtn" and obj.Name ~= "CloseBtn" then
				TweenService:Create(obj, TouchFling._t, {TextTransparency = 0}):Play()
			elseif obj:IsA("TextLabel") then
				TweenService:Create(obj, TouchFling._t, {TextTransparency = (obj.Name == "Watermark") and 0.5 or 0}):Play()
			elseif obj:IsA("ScrollingFrame") then
				TweenService:Create(obj, TouchFling._t, {BackgroundTransparency = 0.7}):Play()
			elseif obj:IsA("Frame") and obj.Name ~= "TopBar" then
				TweenService:Create(obj, TouchFling._t, {BackgroundTransparency = 0}):Play()
			end
		end
		TouchFling._b = TouchFling._f:FindFirstChild("TopBar") and TouchFling._f.TopBar:FindFirstChild("MinimizeBtn")
		if TouchFling._b then TouchFling._b.Text = "-" end
	end
end

function TouchFling:StartKeySelection()
	if self.isSelectingKey then return end
	self.isSelectingKey = true
	if self.toggles.keybindBtn then
		self.toggles.keybindBtn.Text = "Press any key..."
		self.toggles.keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
	end
	TouchFling._c = nil
	TouchFling._c = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self.clickTPKey = input.KeyCode
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.clickTPKey = "MouseButton1"
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.clickTPKey = "MouseButton2"
		else
			return
		end
		TouchFling._c:Disconnect()
		self.isSelectingKey = false
		self:UpdateKeybindButton()
	end)
end

-- WORKING: The spin fling method that actually works
-- This is used by ALL fling features (Touch Fling, Fling All, Lock Fling)
function TouchFling:DoSpinFling()
	local char = client.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local vel = root.Velocity
	root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
	RunService.RenderStepped:Wait()
	if root.Parent then root.Velocity = vel end
	RunService.Stepped:Wait()
	if root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
end

-- FIXED: Start the fling loop as a separate thread that can be stopped
function TouchFling:StartFlingLoop()
	-- Kill any existing thread
	if self.flingThread then
		self.stopFling = true
		task.wait(0.1)
		self.flingThread = nil
	end

	self.stopFling = false
	self.flingThread = task.spawn(function()
		while not self.stopFling do
			self:DoSpinFling()
			RunService.Heartbeat:Wait()
		end
		-- When stopped, make sure velocity is normal
		local char = client.Character
		if char then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.Velocity = Vector3.new(0, 0, 0)
			end
		end
	end)
end

function TouchFling:StopFlingLoop()
	self.stopFling = true
	if self.flingThread then
		self.flingThread = nil
	end
	-- Reset velocity immediately
	local char = client.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(0, 0, 0)
		end
	end
end

-- NEW: Check if a player has been flung (moved far or falling fast)
function TouchFling:IsPlayerFlung(player)
	if not player or not player.Character then return true end
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	local hum = player.Character:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return true end
	if hum.Health <= 0 then return true end

	local vel = hrp.Velocity
	if vel.Magnitude > 100 then return true end
	if hrp.Position.Y < -50 then return true end

	return false
end

-- NEW: Get valid fling targets
function TouchFling:GetValidTargets()
	TouchFling._l = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= client and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				table.insert(TouchFling._l, plr)
			end
		end
	end
	return TouchFling._l
end

function TouchFling:CreateGUI()
	if self.gui then 
		self.gui.Enabled = true
		return 
	end

	TouchFling._s = Instance.new("ScreenGui")
	TouchFling._s.Name = "LunarTouchFling"
	TouchFling._s.ResetOnSpawn = false
	TouchFling._s.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local success = pcall(function()
		TouchFling._s.Parent = game:GetService("CoreGui")
	end)
	if not success then
		TouchFling._s.Parent = client:WaitForChild("PlayerGui")
	end

	self.gui = TouchFling._s

	TouchFling._m = self.isMobile
	TouchFling._w = TouchFling._m and 260 or 300
	TouchFling._h = TouchFling._m and 420 or 540
	TouchFling._b = TouchFling._m and 32 or 38
	TouchFling._t = TouchFling._m and 11 or 13
	TouchFling._u = TouchFling._m and 18 or 22

	TouchFling._f = Instance.new("Frame")
	TouchFling._f.Name = "Main"
	TouchFling._f.Parent = TouchFling._s
	TouchFling._f.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	TouchFling._f.BorderSizePixel = 0
	TouchFling._f.Position = UDim2.new(0.35, 0, 0.3, 0)
	TouchFling._f.Size = UDim2.new(0, TouchFling._w, 0, TouchFling._h)
	TouchFling._f.Active = true
	TouchFling._f.ClipsDescendants = true
	self.mainFrame = TouchFling._f

	self.dragActive = false
	self.dragStartPos = nil
	self.dragFrameStart = nil

	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 12)
	TouchFling._c.Parent = TouchFling._f

	TouchFling._r = Instance.new("UIGradient")
	TouchFling._r.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))}
	TouchFling._r.Rotation = 90
	TouchFling._r.Parent = TouchFling._f

	TouchFling._o = Instance.new("Frame")
	TouchFling._o.Name = "TopBar"
	TouchFling._o.Parent = TouchFling._f
	TouchFling._o.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	TouchFling._o.BorderSizePixel = 0
	TouchFling._o.Size = UDim2.new(1, 0, 0, 36)
	TouchFling._o.Active = true
	TouchFling._o.ZIndex = 10

	TouchFling._o.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.dragActive = true
			self.dragStartPos = input.Position
			self.dragFrameStart = TouchFling._f.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then 
					self.dragActive = false 
				end
			end)
		end
	end)

	TouchFling._o.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and self.dragActive then
			TouchFling._i = input.Position - self.dragStartPos
			TouchFling._f.Position = UDim2.new(
				self.dragFrameStart.X.Scale, self.dragFrameStart.X.Offset + TouchFling._i.X,
				self.dragFrameStart.Y.Scale, self.dragFrameStart.Y.Offset + TouchFling._i.Y
			)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and self.dragActive then
			TouchFling._i = input.Position - self.dragStartPos
			TouchFling._f.Position = UDim2.new(
				self.dragFrameStart.X.Scale, self.dragFrameStart.X.Offset + TouchFling._i.X,
				self.dragFrameStart.Y.Scale, self.dragFrameStart.Y.Offset + TouchFling._i.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.dragActive = false
		end
	end)

	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 12)
	TouchFling._c.Parent = TouchFling._o

	TouchFling._l = Instance.new("TextLabel")
	TouchFling._l.Name = "Title"
	TouchFling._l.Parent = TouchFling._o
	TouchFling._l.BackgroundTransparency = 1
	TouchFling._l.Position = UDim2.new(0, 10, 0, 0)
	TouchFling._l.Size = UDim2.new(0.5, 0, 1, 0)
	TouchFling._l.Font = Enum.Font.Code
	TouchFling._l.Text = "Touch Fling"
	TouchFling._l.TextColor3 = Color3.fromRGB(180, 220, 255)
	TouchFling._l.TextSize = TouchFling._u
	TouchFling._l.TextXAlignment = Enum.TextXAlignment.Left
	TouchFling._l.ZIndex = 11

	TouchFling._b = Instance.new("TextButton")
	TouchFling._b.Name = "MinimizeBtn"
	TouchFling._b.Parent = TouchFling._o
	TouchFling._b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	TouchFling._b.Position = UDim2.new(1, -65, 0.5, -12)
	TouchFling._b.Size = UDim2.new(0, 26, 0, 26)
	TouchFling._b.Font = Enum.Font.Code
	TouchFling._b.Text = "-"
	TouchFling._b.TextColor3 = Color3.new(1, 1, 1)
	TouchFling._b.TextSize = 18
	TouchFling._b.ZIndex = 11
	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 8)
	TouchFling._c.Parent = TouchFling._b

	TouchFling._n = Instance.new("TextButton")
	TouchFling._n.Name = "CloseBtn"
	TouchFling._n.Parent = TouchFling._o
	TouchFling._n.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	TouchFling._n.Position = UDim2.new(1, -34, 0.5, -12)
	TouchFling._n.Size = UDim2.new(0, 26, 0, 26)
	TouchFling._n.Font = Enum.Font.Code
	TouchFling._n.Text = "X"
	TouchFling._n.TextColor3 = Color3.new(1, 1, 1)
	TouchFling._n.TextSize = 16
	TouchFling._n.ZIndex = 11
	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 8)
	TouchFling._c.Parent = TouchFling._n

	TouchFling._n.MouseButton1Click:Connect(function()
		self:StopFlingLoop()
		self.gui:Destroy()
		self.gui = nil
		self.mainFrame = nil
		self.toggles = {}
		self.buttons = {}
		self.enabled = false
		self.flingAll = false
		self.lockFling = false
		self.clickTP = false
		self.oneTimeTP = false
		self.selectedPlayer = nil
		self.isMinimized = false
	end)

	TouchFling._b.MouseButton1Click:Connect(function()
		self:ToggleMinimize()
	end)

	local function makeToggle(y, text, name)
		TouchFling._b = Instance.new("TextButton")
		TouchFling._b.Name = name
		TouchFling._b.Parent = TouchFling._f
		TouchFling._b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
		TouchFling._b.Position = UDim2.new(0.1, 0, y, 0)
		TouchFling._b.Size = UDim2.new(0.8, 0, 0, (TouchFling._m and 32 or 38))
		TouchFling._b.Font = Enum.Font.Code
		TouchFling._b.Text = text .. ": OFF"
		TouchFling._b.TextColor3 = Color3.fromRGB(255, 80, 80)
		TouchFling._b.TextSize = (TouchFling._m and 11 or 13)
		TouchFling._c = Instance.new("UICorner")
		TouchFling._c.CornerRadius = UDim.new(0, 10)
		TouchFling._c.Parent = TouchFling._b
		return TouchFling._b
	end

	self.toggles.enabled = makeToggle(0.10, "Touch Fling", "TouchFling")
	self.toggles.flingAll = makeToggle(0.20, "Fling All", "FlingAll")
	self.toggles.lockFling = makeToggle(0.30, "Lock Fling", "LockFling")
	self.toggles.clickTP = makeToggle(0.40, "Click TP", "ClickTP")
	self.toggles.oneTimeTP = makeToggle(0.50, "One-Time TP", "OneTimeTP")

	self.toggles.keybindBtn = Instance.new("TextButton")
	self.toggles.keybindBtn.Name = "KeybindBtn"
	self.toggles.keybindBtn.Parent = TouchFling._f
	self.toggles.keybindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	self.toggles.keybindBtn.Position = UDim2.new(0.1, 0, 0.60, 0)
	self.toggles.keybindBtn.Size = UDim2.new(0.8, 0, 0, (TouchFling._m and 32 or 38))
	self.toggles.keybindBtn.Font = Enum.Font.Code
	self.toggles.keybindBtn.Text = "Click TP Key: E"
	self.toggles.keybindBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
	self.toggles.keybindBtn.TextSize = (TouchFling._m and 11 or 13)
	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 10)
	TouchFling._c.Parent = self.toggles.keybindBtn

	self.toggles.enabled.MouseButton1Click:Connect(function()
		self.enabled = not self.enabled
		if self.enabled then
			self:StartFlingLoop()
		else
			self:StopFlingLoop()
		end
		self:UpdateToggle("enabled", "Touch Fling")
	end)

	self.toggles.flingAll.MouseButton1Click:Connect(function()
		self.flingAll = not self.flingAll
		self.flingAllIndex = 1
		self.flingAllTimer = 0
		self.flingAllCurrentTarget = nil
		self.flingAllStuckTimer = 0
		self:UpdateToggle("flingAll", "Fling All")
	end)

	self.toggles.lockFling.MouseButton1Click:Connect(function()
		self.lockFling = not self.lockFling
		self:UpdateToggle("lockFling", "Lock Fling")
	end)

	self.toggles.clickTP.MouseButton1Click:Connect(function()
		self.clickTP = not self.clickTP
		self:UpdateToggle("clickTP", "Click TP")
	end)

	self.toggles.oneTimeTP.MouseButton1Click:Connect(function()
		self.oneTimeTP = not self.oneTimeTP
		self:UpdateToggle("oneTimeTP", "One-Time TP")
	end)

	self.toggles.keybindBtn.MouseButton1Click:Connect(function()
		self:StartKeySelection()
	end)

	TouchFling._l = Instance.new("TextLabel")
	TouchFling._l.Name = "ListLabel"
	TouchFling._l.Parent = TouchFling._f
	TouchFling._l.BackgroundTransparency = 1
	TouchFling._l.Position = UDim2.new(0.1, 0, 0.70, 0)
	TouchFling._l.Size = UDim2.new(0.8, 0, 0, 18)
	TouchFling._l.Font = Enum.Font.Code
	TouchFling._l.Text = "Select Player"
	TouchFling._l.TextColor3 = Color3.fromRGB(200, 200, 255)
	TouchFling._l.TextSize = (TouchFling._m and 11 or 13) + 1

	TouchFling._s = Instance.new("ScrollingFrame")
	TouchFling._s.Name = "PlayerScroll"
	TouchFling._s.Parent = TouchFling._f
	TouchFling._s.Position = UDim2.new(0.1, 0, 0.75, 0)
	TouchFling._s.Size = UDim2.new(0.8, 0, 0, (TouchFling._m and 80 or 100))
	TouchFling._s.BackgroundTransparency = 0.7
	TouchFling._s.ScrollBarThickness = 4
	TouchFling._c = Instance.new("UICorner")
	TouchFling._c.CornerRadius = UDim.new(0, 8)
	TouchFling._c.Parent = TouchFling._s

	TouchFling._u = Instance.new("UIListLayout")
	TouchFling._u.Parent = TouchFling._s
	TouchFling._u.Padding = UDim.new(0, 4)

	TouchFling._l = Instance.new("TextLabel")
	TouchFling._l.Name = "Watermark"
	TouchFling._l.Parent = TouchFling._f
	TouchFling._l.BackgroundTransparency = 1
	TouchFling._l.Position = UDim2.new(0.05, 0, 0.93, 0)
	TouchFling._l.Size = UDim2.new(0.9, 0, 0, 16)
	TouchFling._l.Font = Enum.Font.Code
	TouchFling._l.Text = "https://discord.gg/ydNKRbFmUd"
	TouchFling._l.TextColor3 = Color3.fromRGB(120, 180, 255)
	TouchFling._l.TextSize = 11
	TouchFling._l.TextTransparency = 0.5

	local function refreshList()
		for plr, btn in pairs(self.buttons) do
			if not plr.Parent then 
				btn:Destroy()
				self.buttons[plr] = nil 
			end
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= client and not self.buttons[plr] then
				TouchFling._b = Instance.new("TextButton")
				TouchFling._b.Size = UDim2.new(1, -8, 0, 28)
				TouchFling._b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
				TouchFling._b.Text = plr.Name
				TouchFling._b.TextColor3 = Color3.new(1, 1, 1)
				TouchFling._b.Font = Enum.Font.Code
				TouchFling._b.TextSize = 14
				TouchFling._b.Parent = TouchFling._s
				TouchFling._c = Instance.new("UICorner")
				TouchFling._c.CornerRadius = UDim.new(0, 8)
				TouchFling._c.Parent = TouchFling._b
				TouchFling._b.MouseButton1Click:Connect(function()
					self:SelectPlayer(plr)
				end)
				self.buttons[plr] = TouchFling._b
			end
		end
		TouchFling._s.CanvasSize = UDim2.new(0, 0, 0, TouchFling._u.AbsoluteContentSize.Y + 10)
	end

	Players.PlayerAdded:Connect(refreshList)
	Players.PlayerRemoving:Connect(refreshList)
	refreshList()
	self:UpdateKeybindButton()
end

-- Click TP with Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if TouchFling.dragActive then return end
	if gameProcessed then return end
	if not TouchFling.clickTP then return end

	local shouldTP = false

	if TouchFling.clickTPKey == "MouseButton1" and input.UserInputType == Enum.UserInputType.MouseButton1 then
		shouldTP = true
	elseif TouchFling.clickTPKey == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
		shouldTP = true
	elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == TouchFling.clickTPKey then
		shouldTP = true
	end

	if shouldTP and Mouse.Target then
		TouchFling._t = client.Character and client.Character:FindFirstChild("HumanoidRootPart")
		if TouchFling._t then
			TouchFling._t.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end
end)

-- FIXED: Main Loop - ALL flings use DoSpinFling
RunService.Heartbeat:Connect(function(deltaTime)
	-- FIXED: Fling All - teleport into person, stick until flung, then move to next
	if TouchFling.flingAll then
		local targets = TouchFling:GetValidTargets()
		if #targets == 0 then return end

		-- If no current target or current target is flung/dead, pick next
		if not TouchFling.flingAllCurrentTarget or TouchFling:IsPlayerFlung(TouchFling.flingAllCurrentTarget) then
			local targetIndex = TouchFling.flingAllIndex
			if targetIndex > #targets then
				targetIndex = 1
				TouchFling.flingAllIndex = 1
			end

			TouchFling.flingAllCurrentTarget = targets[targetIndex]
			TouchFling.flingAllStuckTimer = 0
			TouchFling.flingAllIndex = targetIndex + 1
			if TouchFling.flingAllIndex > #targets then
				TouchFling.flingAllIndex = 1
			end
		end

		-- Stick to current target and fling them using the SAME spin method
		if TouchFling.flingAllCurrentTarget and TouchFling.flingAllCurrentTarget.Character then
			local targetRoot = TouchFling.flingAllCurrentTarget.Character:FindFirstChild("HumanoidRootPart")
			local myRoot = client.Character and client.Character:FindFirstChild("HumanoidRootPart")

			if targetRoot and myRoot then
				-- Teleport directly into them
				myRoot.CFrame = targetRoot.CFrame

				-- Use the SAME working spin fling method
				TouchFling:DoSpinFling()

				-- Safety: if stuck too long (3 sec), force move to next
				TouchFling.flingAllStuckTimer = TouchFling.flingAllStuckTimer + deltaTime
				if TouchFling.flingAllStuckTimer >= 3 then
					TouchFling.flingAllCurrentTarget = nil
					TouchFling.flingAllStuckTimer = 0
				end
			end
		end
	else
		-- Reset when disabled
		TouchFling.flingAllCurrentTarget = nil
		TouchFling.flingAllStuckTimer = 0
		TouchFling.flingAllTimer = 0
	end

	-- FIXED: Lock Fling - uses the SAME DoSpinFling method
	if TouchFling.lockFling and TouchFling.selectedPlayer and TouchFling.selectedPlayer.Character then
		TouchFling._t = client.Character and client.Character:FindFirstChild("HumanoidRootPart")
		TouchFling._v = TouchFling.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
		if TouchFling._t and TouchFling._v then
			-- Stay on top of them
			TouchFling._t.CFrame = TouchFling._v.CFrame
			-- Use the SAME working spin fling method
			TouchFling:DoSpinFling()
		end
	end

	-- One-Time TP
	if TouchFling.oneTimeTP and TouchFling.selectedPlayer and TouchFling.selectedPlayer.Character then
		TouchFling._t = client.Character and client.Character:FindFirstChild("HumanoidRootPart")
		TouchFling._v = TouchFling.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
		if TouchFling._t and TouchFling._v then
			TouchFling._t.CFrame = TouchFling._v.CFrame
		end
	end
end)
------------------------------------------------
-- FOV
------------------------------------------------
local function setFov(val)
	local num = tonumber(val)
	if num and num >= 1 and num <= 120 then
		workspace.CurrentCamera.FieldOfView = num
		notify("FOV set to " .. num, currentTheme.accent)
	else
		notify("❌ Invalid FOV (1-120)", Color3.fromRGB(255, 100, 100))
	end
end
------------------------------------------------
-- kick
------------------------------------------------
local function kick(plr)
	if plr == client then
		client:Kick("Kicked via Lunar Admin")
	else
		notify("⚠️ Kick only works on yourself (client-side)", Color3.fromRGB(255, 170, 0))
	end
end
------------------------------------------------
-- ragdoll
------------------------------------------------
local function ragdoll(plr)
	if plr ~= client then
		notify("❌ Ragdoll only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local char = plr.Character
	if not char then 
		notify("❌ No character to ragdoll", Color3.fromRGB(255, 100, 100))
		return 
	end
	local hum = getHum(plr)
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	hum.PlatformStand = true
	local joints = {}
	for _, v in char:GetDescendants() do
		if v:IsA("Motor6D") then
			v.Enabled = false
			table.insert(joints, v)
		end
	end
	ragdolls[plr] = joints
	notify("Ragdolled", Color3.fromRGB(200, 100, 100))
end
------------------------------------------------
-- unragdoll
------------------------------------------------
local function unragdoll(plr)
	if plr ~= client then
		notify("❌ Unragdoll only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local joints = ragdolls[plr]
	if not joints then 
		notify("⚠️ Not ragdolled", Color3.fromRGB(255, 200, 100))
		return 
	end
	for _, v in ipairs(joints) do v.Enabled = true end
	local hum = getHum(plr)
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		hum.PlatformStand = false
	end
	ragdolls[plr] = nil
	notify("Unragdolled", Color3.fromRGB(100, 200, 100))
end
------------------------------------------------
-- console
------------------------------------------------
local function console()
	StarterGui:SetCore("DevConsoleVisible", true)
	notify("Console opened", Color3.fromRGB(180, 180, 255))
end
------------------------------------------------
-- disable fall damage
------------------------------------------------
local function disableFallDamage()
	local conn = client.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		end
	end)
	notify("⚠️THIS DOES NOT WORK⚠️", Color3.fromRGB(100, 255, 180))
end
------------------------------------------------
-- enable inventory
------------------------------------------------
local function enableCore(name)
	local enum
	if name == "inventory" then enum = Enum.CoreGuiType.Backpack
	elseif name == "playerlist" then enum = Enum.CoreGuiType.PlayerList
	else 
		notify("❌ Unknown core GUI: " .. tostring(name), Color3.fromRGB(255, 100, 100))
		return 
	end
	local current = StarterGui:GetCoreGuiEnabled(enum)
	StarterGui:SetCoreGuiEnabled(enum, not current)
	notify("✅ " .. name:gsub("^%l", string.upper) .. (not current and " enabled" or " disabled"), Color3.fromRGB(180, 180, 255))
end
------------------------------------------------
-- trip
------------------------------------------------
local function trip(plr)
	if plr ~= client then
		notify("❌ Trip only works on yourself", Color3.fromRGB(255, 100, 100))
		return
	end
	local hum = getHum(plr)
	if hum then
		hum.Sit = true
		hum.Jump = true
		notify("Tripped", Color3.fromRGB(255, 180, 100))
	end
end

------------------------------------
-- explode 
------------------------------------

local function explode(plr)
	local char = plr.Character
	if not char then
		notify("❌ No character found", Color3.fromRGB(255, 100, 100))
		return
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root or humanoid.Health <= 0 then
		notify("❌ Cannot explode - invalid or already dead", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Step 1: Create a big visible explosion for everyone
	local explosion = Instance.new("Explosion")
	explosion.Position = root.Position
	explosion.BlastRadius = 12           -- decent size
	explosion.BlastPressure = 500000     -- strong visual push
	explosion.DestroyJointRadiusPercent = 0  -- don't auto-break joints (we do it manually)
	explosion.Parent = workspace

	-- Step 2: Force death + ragdoll (kills you and makes physics take over)
	humanoid.Health = 0
	humanoid:ChangeState(Enum.HumanoidStateType.Dead)

	-- Step 3: Detach limbs visibly (breaks Motor6D joints → parts fly apart)
	-- This is what makes limbs scatter like an explosion
	for _, motor in ipairs(char:GetDescendants()) do
		if motor:IsA("Motor6D") and motor.Part1 and motor.Part0 then
			-- Create a BallSocketConstraint or just break the joint
			-- Option A: Simple break (most games let this replicate)
			motor.Enabled = false

			-- Option B: Replace with BallSocket + NoCollision for flying parts (more dramatic)
			local socket = Instance.new("BallSocketConstraint")
			socket.Attachment0 = Instance.new("Attachment", motor.Part0)
			socket.Attachment1 = Instance.new("Attachment", motor.Part1)
			socket.LimitsEnabled = false
			socket.Parent = motor.Part0

			-- Optional: Give random velocity to make limbs fly farther
			if motor.Part1:IsA("BasePart") then
				motor.Part1.Velocity = Vector3.new(
					math.random(-80,80),
					math.random(60,140),
					math.random(-80,80)
				)
				motor.Part1.RotVelocity = Vector3.new(
					math.random(-10,10),
					math.random(-10,10),
					math.random(-10,10)
				)
			end
		end
	end

	-- Step 4: Extra ragdoll physics boost (makes body flop/scatter more)
	if root then
		root.Velocity = Vector3.new(0, 80, 0)  -- upward kick
		root.AssemblyLinearVelocity = Vector3.new(
			math.random(-60,60),
			math.random(40,100),
			math.random(-60,60)
		)
	end

	-- Optional: Hide head or make dramatic (some games detect head removal)
	local head = char:FindFirstChild("Head")
	if head then
		head.Transparency = 0.3  -- slight fade or leave visible
		head.Velocity = Vector3.new(math.random(-50,50), 100, math.random(-50,50))
	end

	notify("Exploded! Limbs detached & scattered", Color3.fromRGB(255, 60, 60))
end
------------------------------------------------
-- fire
------------------------------------------------
local function fire(plr)
	local hrp = getHRP(plr)
	if hrp and not hrp:FindFirstChild("Fire") then
		local f = Instance.new("Fire", hrp)
		f.Size = 10
		f.Heat = 25
		notify("On fire", Color3.fromRGB(255, 100, 0))
	else
		notify("⚠️ Already on fire or no character", Color3.fromRGB(255, 200, 100))
	end
end
------------------------------------------------
-- unfire
------------------------------------------------
local function unfire(plr)
	local hrp = getHRP(plr)
	if hrp then
		local f = hrp:FindFirstChild("Fire")
		if f then 
			f:Destroy() 
			notify("Fire off", Color3.fromRGB(200, 100, 0))
		else
			notify("Not on fire", Color3.fromRGB(255, 200, 100))
		end
	end
end
------------------------------------------------
-- first person/thrid person
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local client = Players.LocalPlayer  -- assuming 'client' is LocalPlayer in your script

local function thirdp()
	-- Step 1: Switch to Classic mode (allows zooming)
	client.CameraMode = Enum.CameraMode.Classic

	-- Step 2: Temporarily force a zoom-out to exit first person reliably
	-- (Roblox camera won't exit FP just by setting Classic if already zoomed in)
	local originalMinZoom = client.CameraMinZoomDistance
	client.CameraMinZoomDistance = 10  -- or higher, forces zoom out
	client.CameraMaxZoomDistance = 400

	-- Wait one frame so the camera module processes the change and zooms out
	RunService.RenderStepped:Wait()  -- or task.wait(0.03) if you prefer

	-- Step 3: Restore normal min zoom (so player can zoom in again if they want)
	client.CameraMinZoomDistance = originalMinZoom  -- or set to 0.5 if you want tight zoom allowed

	-- Step 4: Fix "invisible to self" glitch
	-- Roblox sets LocalTransparencyModifier = 1 on parts in FP; doesn't always reset
	local character = client.Character
	if character then
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
				obj.LocalTransparencyModifier = 0
			end
		end

		-- Optional: If head/face is still hidden, force it visible too
		local head = character:FindFirstChild("Head")
		if head then
			head.LocalTransparencyModifier = 0
		end
	end

	-- Optional: Re-focus camera on your humanoid to snap back cleanly
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		workspace.CurrentCamera.CameraSubject = humanoid
	end

	notify("Third person enabled (forced zoom out + visibility fix)", currentTheme.accent)
end

local function firstp()
	client.CameraMode = Enum.CameraMode.LockFirstPerson
	notify("First person enabled", currentTheme.accent)
end
------------------------------------------------
-- advanced Waypoint
------------------------------------------------
local function waypoint()
	local num = #waypoints + 1
	local wp = Instance.new("Part")
	wp.Size = Vector3.new(1,1,1)
	wp.Transparency = 1
	wp.Anchored = true
	wp.CanCollide = false
	wp.Position = hrp.Position + Vector3.new(0, 5, 0)
	wp.Parent = workspace
	local bb = Instance.new("BillboardGui")
	bb.Adornee = wp
	bb.Size = UDim2.new(0, 100, 0, 100)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.Parent = wp
	local symbol = Instance.new("TextLabel", bb)
	symbol.Size = UDim2.new(1,0,0.5,0)
	symbol.BackgroundTransparency = 1
	symbol.Text = "★"
	symbol.Font = Enum.Font.Code
	symbol.TextSize = 40
	symbol.TextColor3 = Color3.new(1,1,1)
	symbol.TextStrokeTransparency = 0
	symbol.TextStrokeColor3 = Color3.new(0,0,0)
	local distLabel = Instance.new("TextLabel", bb)
	distLabel.Size = UDim2.new(1,0,0.5,0)
	distLabel.Position = UDim2.new(0,0,0.5,0)
	distLabel.BackgroundTransparency = 1
	distLabel.Text = "0 studs"
	distLabel.Font = Enum.Font.Code
	distLabel.TextSize = 18
	distLabel.TextColor3 = Color3.new(1,1,1)
	distLabel.TextStrokeTransparency = 0.5
	local conn = RunService.Heartbeat:Connect(function()
		if not wp.Parent then conn:Disconnect() return end
		local dist = (hrp.Position - wp.Position).Magnitude
		distLabel.Text = math.floor(dist) .. " studs"
	end)
	table.insert(waypoints, {part = wp, conn = conn})
	notify("Waypoint #" .. num .. " added", currentTheme.accent)
end

------------------------------------------------
-- advanced tracers
------------------------------------------------

local tracerSystem = {
	enabled = false,
	players = {},
	beams = {} -- Track all beams for cleanup
}

-- Thinner, better looking tracers
local TRACER_SETTINGS = {
	width0 = 0.05,        -- Much thinner (was 0.2)
	width1 = 0.02,        -- Taper to point
	transparency = 0.15,   -- More visible (was 0.3)
	brightness = 2,      -- Neon glow effect
	texture = "rbxassetid://7151778302", -- Optional: thin line texture
	textureLength = 1,
	textureMode = Enum.TextureMode.Stretch
}

local function getMyHRP()
	if client.Character then
		return client.Character:FindFirstChild("HumanoidRootPart")
	end
	return nil
end

local function getTracerColor(plr)
	if not client.Team or not plr.Team then
		return Color3.fromRGB(200, 200, 255) -- Soft white/blue if no team
	end

	if plr.Team == client.Team then
		return Color3.fromRGB(0, 255, 150)   -- Bright green for friendly
	else
		return Color3.fromRGB(255, 50, 50)   -- Bright red for enemy
	end
end

local function clearPlayer(plr)
	local data = tracerSystem.players[plr]
	if not data then return end

	if data.beam then 
		data.beam:Destroy() 
	end
	if data.att0 then 
		data.att0:Destroy() 
	end
	if data.att1 then 
		data.att1:Destroy() 
	end

	for _, conn in ipairs(data.connections or {}) do
		conn:Disconnect()
	end

	tracerSystem.players[plr] = nil
end

local function clearAllTracers()
	for plr, _ in pairs(tracerSystem.players) do
		clearPlayer(plr)
	end
	tracerSystem.players = {}
	tracerSystem.enabled = false
end

local function createBeam(att0, att1, color)
	local beam = Instance.new("Beam")
	beam.Width0 = TRACER_SETTINGS.width0
	beam.Width1 = TRACER_SETTINGS.width1
	beam.Transparency = NumberSequence.new(TRACER_SETTINGS.transparency)
	beam.FaceCamera = true
	beam.Color = ColorSequence.new(color)
	beam.LightEmission = TRACER_SETTINGS.brightness
	beam.LightInfluence = 0
	beam.Segments = 1
	beam.ZOffset = 0

	beam.Attachment0 = att0
	beam.Attachment1 = att1
	beam.Parent = workspace.Terrain -- Use Terrain instead of workspace for cleaner hierarchy

	return beam
end

local function attachTracer(plr, char)
	if not tracerSystem.enabled then return end
	if plr == client then return end

	local myHRP = getMyHRP()
	if not myHRP then return end

	local enemyHRP = char:WaitForChild("HumanoidRootPart", 10)
	if not enemyHRP then return end

	-- Clear existing first
	clearPlayer(plr)

	local data = { connections = {} }
	tracerSystem.players[plr] = data

	-- Create attachments
	local att0 = Instance.new("Attachment")
	att0.Name = "TracerAtt0_" .. plr.Name
	att0.Parent = myHRP
	att0.WorldPosition = myHRP.Position

	local att1 = Instance.new("Attachment")
	att1.Name = "TracerAtt1_" .. plr.Name
	att1.Parent = enemyHRP
	att1.WorldPosition = enemyHRP.Position

	-- Create beam with improved visuals
	local beam = createBeam(att0, att1, getTracerColor(plr))

	data.beam = beam
	data.att0 = att0
	data.att1 = att1

	-- Update color if THEY change team
	table.insert(data.connections,
		plr:GetPropertyChangedSignal("Team"):Connect(function()
			if data.beam then
				data.beam.Color = ColorSequence.new(getTracerColor(plr))
			end
		end)
	)

	-- Update color if YOU change team
	table.insert(data.connections,
		client:GetPropertyChangedSignal("Team"):Connect(function()
			if data.beam then
				data.beam.Color = ColorSequence.new(getTracerColor(plr))
			end
		end)
	)

	-- Handle THEIR respawn
	table.insert(data.connections,
		plr.CharacterAdded:Connect(function(newChar)
			task.wait(0.3)
			attachTracer(plr, newChar)
		end)
	)

	-- Handle THEIR death (remove beam until respawn)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		table.insert(data.connections,
			humanoid.Died:Connect(function()
				clearPlayer(plr)
			end)
		)
	end
end

-- Main enable/disable functions
function tracerSystem:Enable()
	if self.enabled then return end
	self.enabled = true

	-- Attach to all existing players
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= client and plr.Character then
			task.spawn(function()
				attachTracer(plr, plr.Character)
			end)
		end
	end

	-- Listen for new players
	self.playerAddedConn = Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function(char)
			task.wait(0.2)
			if self.enabled then
				attachTracer(plr, char)
			end
		end)
	end)

	-- Clean up when players leave
	self.playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
		clearPlayer(plr)
	end)

	-- Update our position when we respawn
	self.charAddedConn = client.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		if not self.enabled then return end

		-- Reattach all tracers to new character
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= client and plr.Character then
				task.spawn(function()
					attachTracer(plr, plr.Character)
				end)
			end
		end
	end)

	-- Constant update loop for smooth positioning
	self.updateLoop = RunService.Heartbeat:Connect(function()
		if not self.enabled then return end

		local myHRP = getMyHRP()
		if not myHRP then return end

		for plr, data in pairs(self.players) do
			if data.att0 and data.att0.Parent then
				data.att0.WorldPosition = myHRP.Position
			end
		end
	end)
end

function tracerSystem:Disable()
	if not self.enabled then return end
	self.enabled = false

	-- Disconnect all connections
	if self.playerAddedConn then self.playerAddedConn:Disconnect() end
	if self.playerRemovingConn then self.playerRemovingConn:Disconnect() end
	if self.charAddedConn then self.charAddedConn:Disconnect() end
	if self.updateLoop then self.updateLoop:Disconnect() end

	-- Clear all tracers
	clearAllTracers()
end

function tracerSystem:Toggle()
	if self.enabled then
		self:Disable()
		return false
	else
		self:Enable()
		return true
	end
end

----------------------------------------------------
-- CREATE FOR PLAYER
----------------------------------------------------
local function createForPlayer(plr)
	if plr == client then return end
	if tracerSystem.players[plr] then return end

	if plr.Character then
		attachTracer(plr, plr.Character)
	end
end

----------------------------------------------------
-- ENABLE
----------------------------------------------------
function enableTracers()

	if tracerSystem.enabled then return end
	tracerSystem.enabled = true

	-- existing players
	for _,plr in ipairs(Players:GetPlayers()) do
		createForPlayer(plr)
	end

	-- new players
	table.insert(tracerSystem.connections,
		Players.PlayerAdded:Connect(function(plr)
			if tracerSystem.enabled then
				createForPlayer(plr)
			end
		end)
	)

	-- cleanup on leave
	table.insert(tracerSystem.connections,
		Players.PlayerRemoving:Connect(function(plr)
			clearPlayer(plr)
		end)
	)

	-- YOU respawn → rebuild all
	table.insert(tracerSystem.connections,
		client.CharacterAdded:Connect(function()
			task.wait(0.3)

			for plr,_ in pairs(tracerSystem.players) do
				clearPlayer(plr)
			end

			for _,plr in ipairs(Players:GetPlayers()) do
				createForPlayer(plr)
			end
		end)
	)

	notify("Tracers enabled", currentTheme.accent)
end

----------------------------------------------------
-- DISABLE
----------------------------------------------------
function disableTracers()

	if not tracerSystem.enabled then return end
	tracerSystem.enabled = false

	for _,conn in ipairs(tracerSystem.connections) do
		conn:Disconnect()
	end
	tracerSystem.connections = {}

	for plr,_ in pairs(tracerSystem.players) do
		clearPlayer(plr)
	end

	tracerSystem.players = {}

	notify("❌ Tracers disabled", currentTheme.accent)
end
----------------------------------------------------
-- advanced Disable tracers
------------------------------------------------
local function disableTracers()
	tracersEnabled = false
	clearTracers()
	notify("❌ Tracers disabled", currentTheme.accent)
end

-- =============================================================
-- COMMAND PROCESSOR
-- =============================================================
function processCmd(msg)
	if not msg or msg:sub(1,1) ~= prefix then return end
	
	local args = {}
	for word in msg:sub(2):gmatch("%S+") do
		table.insert(args, word)
	end
	
	local cmd = table.remove(args, 1):lower()
	local target = getPlr(args[1] or "me")

	notify(prefix .. cmd, Color3.fromRGB(180, 180, 255))

	if cmd == "aimbot" then
		createAimbotPanel()
		
	elseif cmd == "antilag" then
		_G.StartAntiLag(msg)

	elseif cmd == "unantilag" then
		_G.StopAntiLag(msg)

	elseif cmd == "boombox" then
		_G.BoomboxRun(msg)
		
-- Orbit
	elseif cmd == "orbit" then
		_G.StartOrbit(args)

	elseif cmd == "unorbit" then
		_G.StopOrbit()

-- Loop Goto
	elseif cmd == "loopgoto" then
		_G.StartLoopGoto(args)

	elseif cmd == "unloopgoto" then
		_G.StopLoopGoto()

-- Walk on Water
	elseif cmd == "walkonwater" then
		_G.EnableWalkOnWater()

	elseif cmd == "unwalkonwater" then
		_G.DisableWalkOnWater()

	elseif cmd == "tpwalk" then
		_G.EnableTPWalk(args)

	elseif cmd == "untpwalk" then
		_G.DisableTPWalk()

-- Super Jump
	elseif cmd == "superjump" then
		_G.EnableSuperJump(args)

	elseif cmd == "unsuperjump" then
		_G.DisableSuperJump()

-- Gravity
	elseif cmd == "gravity" then
		_G.SetGravity(args)

	elseif cmd == "resetgravity" then
		_G.ResetGravity()

-- Camlock
	elseif cmd == "camlock" then
		_G.StartCamlock(args)

	elseif cmd == "uncamlock" then
		_G.StopCamlock()

-- Zoom (PC Only)
	elseif cmd == "zoom" then
		_G.SetZoom(args)

	elseif cmd == "unzoom" then
		_G.ClearZoom()

-- XRay
	elseif cmd == "xray" then
		_G.EnableXray()

	elseif cmd == "unxray" then
		_G.DisableXray()

-- Time Set
	elseif cmd == "timeset" then
		_G.SetTime(args)

	elseif cmd == "resettime" then
		_G.ResetTime()

-- Copy Chat
	elseif cmd == "copychat" then
		_G.StartCopyChat(args)

	elseif cmd == "uncopychat" then
		_G.StopCopyChat()

	elseif cmd == "bang" then
		_G.StartBang(args)

	elseif cmd == "unbang" then
		_G.StopBang()

	elseif cmd == "clicktp" then
		
	elseif cmd == "cmdbar" then
		toggleCmdBar()
		
	elseif cmd == "jerk" then
		_G.GiveJerkTool()

	elseif cmd == "unjerk" then
		_G.RemoveJerkTool()

	elseif cmd == "console" then
		console()
		
	elseif cmd == "crosshair" then
		LoadLunarCrosshair()

	elseif cmd == "uncrosshair" then
		UnloadLunarCrosshair()

	elseif cmd == "unload" then
		unload()
		
	elseif cmd == "disablefalldamage" then
		disableFallDamage()

	elseif cmd == "enable" then
		local what = args[1] or ""
		if what == "inventory" or what == "playerlist" then
			enableCore(what)
		end

	elseif cmd == "esp" then
		if args[1] == "all" then 
			enableESPAll()
		else
			-- ESP specific player
			local target = getPlr(args[1] or "me")
			if target and target ~= client then
				enableESPPlayer(target)
			else
				notify("Usage: !esp all or !esp [player]", Color3.fromRGB(255, 200, 100))
			end
		end
		
	elseif cmd == "unesp" then
		if args[1] == "all" then 
			disableESPAll()
		else
			-- Remove ESP from specific player
			local target = getPlr(args[1] or "me")
			if target and target ~= client then
				disableESPPlayer(target)
			else
				notify("Usage: !unesp all or !unesp [player]", Color3.fromRGB(255, 200, 100))
			end
		end
-----------------------------------------------------------------  esp	-----------------------------------------------------------------
-----------------------------------------------------------------		-----------------------------------------------------------------
	elseif cmd == "explode" then
		explode(target)
		
	elseif cmd == "fire" then
		fire(target)
		
	elseif cmd == "firstp" then
		firstp()
		
	elseif cmd == "fling" then
		TouchFling:CreateGUI()
		StarterGui:SetCore("SendNotification", {
			Title = "Touch Fling", 
			Text = "GUI Opened", 
			Duration = 3
		})
		
	elseif cmd == "flashlight" then
    	openFlashlight()

	elseif cmd == "unflashlight" then
   	 	closeFlashlight()

	elseif cmd == "fly" then
		fly(target, args[2])
		
	elseif cmd == "freecam" then
		enableFreecam()

   	elseif cmd == "mm2" then
    	openmm2esp()
		
	elseif cmd == "freeze" then
		freeze(target)
		
	elseif cmd == "infjump" then
		enableInfJump()
		
	elseif cmd == "joinlogs" then
		createJoinLogsPanel()
		
	elseif cmd == "jump" then
		jump(client, args[1])
		
	elseif cmd == "kill" then
		if args[1] == "all" then 
			for _, p in ipairs(Players:GetPlayers()) do kill(p) end
		elseif args[1] == "me" then 
			kill(client)
		else 
			kill(target) 
		end
		
	elseif cmd == "lay" then
		lay(client)
		
	elseif cmd == "leave" then
		leaveGame()
		
	elseif cmd == "logs" then
		toggleLogs()
		
	elseif cmd == "noclip" then
		noclip(target)
		
	elseif cmd == "ping" then
		ping()
		
	elseif cmd == "ragdoll" then
		ragdoll(client)
		
	elseif cmd == "rejoin" then
		rejoin(LocalPlayer, args)
		
	elseif cmd == "removewaypoint" then
		removeWaypoint()
		
	elseif cmd == "resetspeed" then
		resetspeed(target)
		
	elseif cmd == "sit" then
		sit(client)
		
	elseif cmd == "speed" then
		if args[1] == "me" then
			createSpeedPanel()
		else
			setspeed(target, args[2])
		end
		
	elseif cmd == "serverhop" then
		serverhop(target, args)

	elseif cmd == "!rejoin" then
    	rejoin(client, args)

	elseif cmd == "spin" then
		spin(client, args[1])
		
	elseif cmd == "stopwatch" then
		toggleStopwatch()
		
	elseif cmd == "thirdp" then
		thirdp()
		
	elseif cmd == "to" then
		gotoMe(target)
		
	elseif cmd == "trip" then
		trip(target)
		
	elseif cmd == "tracers" then
		tracerSystem:Enable()
		StarterGui:SetCore("SendNotification", {
			Title = "Tracers", 
			Text = "Enabled - Thin neon tracers active", 
			Duration = 3
		})
		
	elseif cmd == "unautoexec" then
		unautoexecCommand()
		
	elseif cmd == "add" then
   	 if args[1] == "all" then
        addAllFriends()
   	 else
        addFriend(args[1])
    	end

	elseif cmd == "unadd" then
    if args[1] == "all" then
        unaddAllFriends()
    else
        unaddFriend(args[1])
    end

	elseif cmd == "unfire" then
		unfire(target)
		
	elseif cmd == "unfling" then
		if TouchFling.gui then
			TouchFling.gui:Destroy()
			TouchFling.gui = nil
			TouchFling.mainFrame = nil
			TouchFling.toggles = {}
			TouchFling.buttons = {}
			TouchFling.enabled = false
			TouchFling.flingAll = false
			TouchFling.lockFling = false
			TouchFling.clickTP = false
			TouchFling.oneTimeTP = false
			TouchFling.selectedPlayer = nil
		end
		StarterGui:SetCore("SendNotification", {
			Title = "Touch Fling", 
			Text = "GUI Closed", 
			Duration = 3
		})
		
	elseif cmd == "unfly" then
		unfly(target)
		FlySystem:StopFly()
		
	elseif cmd == "unfreecam" then
		disableFreecam()

	elseif cmd == "sunglare" then
		enableSunGlare()
		
	elseif cmd == "unsunglare" then
		disableSunGlare()
		
	elseif cmd == "unfreeze" then
		unfreeze(target)
		
	elseif cmd == "uninfjump" then
		disableInfJump()
		
	elseif cmd == "unnoclip" then
		unnoclip(target)
		
	elseif cmd == "unragdoll" then
		unragdoll(client)
		
	elseif cmd == "unspin" then
		unspin(client)
		
	elseif cmd == "untracers" then
		tracerSystem:Disable()
		StarterGui:SetCore("SendNotification", {
			Title = "Tracers", 
			Text = "Disabled - All tracers cleared", 
			Duration = 3
		})
		
	elseif cmd == "vehiclefly" then
		vehiclefly(client, args[2])
	
	elseif cmd == "unvehiclefly" then
		unvehiclefly(client)

	elseif cmd == "unview" then
		unview()
		
	elseif cmd == "view" then
		view(target)

	elseif cmd == "volume" then
		Volume(client, args)
		
	elseif cmd == "waypoint" then
		waypoint()
		
	elseif cmd == "fov" then
		setFov(args[1])
		
	elseif cmd == "kick" then
		kick(target)
		
	elseif cmd == "unlockmouse" then
		toggleMouseUnlock()
		
	else
		notify("❌ Unknown command: " .. cmd, Color3.fromRGB(255, 100, 100))
	end
end
-- =============================================================
-- Main Gui :3
-- =============================================================
-- Mobile detection at top
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
local smallestSide = math.min(viewport.X, viewport.Y)

local scale, fontScale
if isMobile then
	if smallestSide < 600 then
		scale = 0.42
		fontScale = 0.68
	elseif smallestSide < 800 then
		scale = 0.52
		fontScale = 0.75
	else
		scale = 0.62
		fontScale = 0.82
	end
else
	scale = 1
	fontScale = 1
end

lunarGui = Instance.new("ScreenGui")
lunarGui.Name = "LunarGui"
lunarGui.ResetOnSpawn = false
lunarGui.Enabled = false
lunarGui.DisplayOrder = 2147483646
lunarGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
lunarGui.ScreenInsets = Enum.ScreenInsets.None
lunarGui.IgnoreGuiInset = true
lunarGui.Parent = game:GetService("CoreGui")

mainFrame = Instance.new("Frame", lunarGui)
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, math.floor(420 * scale), 0, math.floor(560 * scale))
mainFrame.Position = UDim2.new(1, math.floor(-440 * scale), 0.5, math.floor(-280 * scale))
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 2147483647
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Top Bar
topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, math.floor(50 * scale))
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
topBar.BorderSizePixel = 0
topBar.ZIndex = 2147483647
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

-- Title
titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, math.floor(-100 * scale), 1, 0)
titleLabel.Position = UDim2.new(0, math.floor(15 * scale), 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Project Lunar"
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = math.floor(24 * fontScale)
titleLabel.TextColor3 = currentTheme.accent
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.new(0,0,0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2147483647

-- Minimize Button
minBtn = Instance.new("TextButton", topBar)
minBtn.Name = "MinimizeBtn"
minBtn.Size = UDim2.new(0, math.floor(35 * scale), 0, math.floor(35 * scale))
minBtn.Position = UDim2.new(1, math.floor(-40 * scale), 0.5, math.floor(-17.5 * scale))
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minBtn.Text = "−"
minBtn.Font = Enum.Font.Code
minBtn.TextSize = math.floor(20 * fontScale)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 2147483647
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Minimize functionality
local minimized = false
local origSize = mainFrame.Size
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		mainFrame:TweenSize(UDim2.new(0, math.floor(420 * scale), 0, math.floor(50 * scale)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
		minBtn.Text = "+"
	else
		mainFrame:TweenSize(origSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
		minBtn.Text = "−"
	end
end)

-- Resize Handle
resizeHandle = Instance.new("TextButton", mainFrame)
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, math.floor(20 * scale), 0, math.floor(20 * scale))
resizeHandle.Position = UDim2.new(1, math.floor(-20 * scale), 1, math.floor(-20 * scale))
resizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
resizeHandle.Text = "◢"
resizeHandle.Font = Enum.Font.Code
resizeHandle.TextSize = math.floor(10 * fontScale)
resizeHandle.TextColor3 = Color3.fromRGB(150, 150, 150)
resizeHandle.BorderSizePixel = 0
resizeHandle.AutoButtonColor = false
resizeHandle.Active = true
resizeHandle.ZIndex = 2147483647
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

-- Resize logic
local resizing = false
local startSize, startPos

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		startSize = mainFrame.Size
		startPos = input.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - startPos
		mainFrame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + d.X, math.floor(320 * scale), math.floor(800 * scale)), 0, math.clamp(startSize.Y.Offset + d.Y, math.floor(300 * scale), math.floor(700 * scale)))
	end
end)

-- Tabs
tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, math.floor(-20 * scale), 0, math.floor(40 * scale))
tabBar.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(60 * scale))
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 2147483647

cmdTab = Instance.new("TextButton", tabBar)
cmdTab.Name = "CmdTab"
cmdTab.Size = UDim2.new(0.333, -5, 1, 0)
cmdTab.BackgroundColor3 = currentTheme.accent
cmdTab.Text = "Commands"
cmdTab.Font = Enum.Font.Code
cmdTab.TextSize = math.floor(16 * fontScale)
cmdTab.TextColor3 = Color3.new(0,0,0)
cmdTab.BorderSizePixel = 0
cmdTab.ZIndex = 2147483647
Instance.new("UICorner", cmdTab).CornerRadius = UDim.new(0, 6)

setTab = Instance.new("TextButton", tabBar)
setTab.Name = "SetTab"
setTab.Size = UDim2.new(0.333, -5, 1, 0)
setTab.Position = UDim2.new(0.333, 2.5, 0, 0)
setTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
setTab.Text = "Settings"
setTab.Font = Enum.Font.Code
setTab.TextSize = math.floor(16 * fontScale)
setTab.TextColor3 = globalConfig.textColor
setTab.BorderSizePixel = 0
setTab.ZIndex = 2147483647
Instance.new("UICorner", setTab).CornerRadius = UDim.new(0, 6)

-- Content Container
contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, math.floor(-20 * scale), 1, math.floor(-110 * scale))
contentFrame.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(110 * scale))
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 2147483647

-- ========== COMMANDS TAB ==========
cmdFrame = Instance.new("Frame", contentFrame)
cmdFrame.Name = "CmdFrame"
cmdFrame.Size = UDim2.new(1, 0, 1, 0)
cmdFrame.BackgroundTransparency = 1
cmdFrame.ZIndex = 2147483647

-- Command Bar (replaces search bar)
cmdBarFrame = Instance.new("Frame", cmdFrame)
cmdBarFrame.Name = "CmdBarFrame"
cmdBarFrame.Size = UDim2.new(1, 0, 0, math.floor(38 * scale))
cmdBarFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
cmdBarFrame.BorderSizePixel = 0
cmdBarFrame.ZIndex = 2147483647
Instance.new("UICorner", cmdBarFrame).CornerRadius = UDim.new(0, 6)

-- Icon
local a = Instance.new("TextLabel", cmdBarFrame)
a.Name = "CmdIcon"
a.Size = UDim2.new(0, math.floor(28 * scale), 0, math.floor(28 * scale))
a.Position = UDim2.new(0, math.floor(6 * scale), 0.5, math.floor(-14 * scale))
a.BackgroundTransparency = 1
a.Text = "PL"
a.Font = Enum.Font.Code
a.TextSize = math.floor(12 * fontScale)
a.TextColor3 = currentTheme.accent
a.ZIndex = 2147483647

-- Input box
a = Instance.new("TextBox", cmdBarFrame)
a.Name = "CmdInput"
a.Size = UDim2.new(1, math.floor(-110 * scale), 1, 0)
a.Position = UDim2.new(0, math.floor(36 * scale), 0, 0)
a.BackgroundTransparency = 1
a.Text = ""
a.PlaceholderText = "Type command..."
a.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
a.Font = Enum.Font.Code
a.TextSize = math.floor(14 * fontScale)
a.TextColor3 = globalConfig.textColor
a.TextStrokeTransparency = 0.5
a.TextStrokeColor3 = Color3.new(0,0,0)
a.ClearTextOnFocus = false
a.ZIndex = 2147483647
cmdInput = a

-- Execute Button
a = Instance.new("TextButton", cmdBarFrame)
a.Name = "ExecBtn"
a.Size = UDim2.new(0, math.floor(30 * scale), 0, math.floor(26 * scale))
a.Position = UDim2.new(1, math.floor(-68 * scale), 0.5, math.floor(-13 * scale))
a.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
a.Text = "▶"
a.Font = Enum.Font.Code
a.TextSize = math.floor(12 * fontScale)
a.TextColor3 = Color3.new(1,1,1)
a.BorderSizePixel = 0
a.ZIndex = 2147483647
Instance.new("UICorner", a).CornerRadius = UDim.new(0, 5)
execBtn = a

-- Command List Button
a = Instance.new("TextButton", cmdBarFrame)
a.Name = "CmdListBtn"
a.Size = UDim2.new(0, math.floor(30 * scale), 0, math.floor(26 * scale))
a.Position = UDim2.new(1, math.floor(-36 * scale), 0.5, math.floor(-13 * scale))
a.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
a.Text = "📋"
a.Font = Enum.Font.Code
a.TextSize = math.floor(12 * fontScale)  -- <-- THIS IS WRONG
a.TextColor3 = Color3.new(1,1,1)
a.BorderSizePixel = 0
a.ZIndex = 2147483647
Instance.new("UICorner", a).CornerRadius = UDim.new(0, 5)
cmdListBtn = a

-- Dropdown for autocomplete
a = Instance.new("Frame", cmdBarFrame)
a.Name = "Dropdown"
a.Size = UDim2.new(1, 0, 0, math.floor(140 * scale))
a.Position = UDim2.new(0, 0, 1, math.floor(4 * scale))
a.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
a.BackgroundTransparency = 0.15
a.BorderSizePixel = 0
a.Visible = false
a.ClipsDescendants = true
a.ZIndex = 2147483647
Instance.new("UICorner", a).CornerRadius = UDim.new(0, 6)
dropdown = a

a = Instance.new("UIStroke", dropdown)
a.Color = Color3.fromRGB(70, 70, 110)
a.Thickness = 1
a.Transparency = 0.5

a = Instance.new("ScrollingFrame", dropdown)
a.Name = "Scroll"
a.Size = UDim2.new(1, math.floor(-12 * scale), 1, math.floor(-10 * scale))
a.Position = UDim2.new(0, math.floor(6 * scale), 0, math.floor(5 * scale))
a.BackgroundTransparency = 1
a.ScrollBarThickness = math.floor(3 * scale)
a.ScrollBarImageColor3 = currentTheme.accent
a.ZIndex = 2147483647
dropdownScroll = a

a = Instance.new("UIListLayout", dropdownScroll)
a.Padding = UDim.new(0, math.floor(2 * scale))

-- Command List Panel (side panel)
a = Instance.new("Frame", cmdFrame)
a.Name = "CmdListPanel"
a.Size = UDim2.new(0, math.floor(200 * scale), 1, math.floor(-48 * scale))
a.Position = UDim2.new(1, math.floor(8 * scale), 0, math.floor(48 * scale))
a.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
a.BackgroundTransparency = 0.3
a.BorderSizePixel = 0
a.Visible = false
a.ZIndex = 2147483647
Instance.new("UICorner", a).CornerRadius = UDim.new(0, 8)
cmdListPanel = a

a = Instance.new("UIStroke", cmdListPanel)
a.Color = Color3.fromRGB(70, 70, 110)
a.Thickness = 1
a.Transparency = 0.45

a = Instance.new("TextLabel", cmdListPanel)
a.Size = UDim2.new(1, 0, 0, math.floor(30 * scale))
a.BackgroundTransparency = 1
a.Text = "📋 Commands"
a.Font = Enum.Font.Code
a.TextSize = math.floor(13 * fontScale)
a.TextColor3 = currentTheme.accent
a.ZIndex = 2147483647

a = Instance.new("TextButton", cmdListPanel)
a.Size = UDim2.new(0, math.floor(24 * scale), 0, math.floor(24 * scale))
a.Position = UDim2.new(1, math.floor(-28 * scale), 0, math.floor(3 * scale))
a.BackgroundTransparency = 1
a.Text = "✕"
a.Font = Enum.Font.Code
a.TextSize = math.floor(14 * fontScale)
a.TextColor3 = Color3.fromRGB(255, 100, 100)
a.ZIndex = 2147483647
panelClose = a

a = Instance.new("ScrollingFrame", cmdListPanel)
a.Name = "ListScroll"
a.Size = UDim2.new(1, math.floor(-12 * scale), 1, math.floor(-38 * scale))
a.Position = UDim2.new(0, math.floor(6 * scale), 0, math.floor(32 * scale))
a.BackgroundTransparency = 1
a.ScrollBarThickness = math.floor(3 * scale)
a.ScrollBarImageColor3 = currentTheme.accent
a.ZIndex = 2147483647
listScroll = a

a = Instance.new("UIListLayout", listScroll)
a.Padding = UDim.new(0, math.floor(2 * scale))

-- All commands for dropdown and panel
allCommands = {
"!aimbot", "!antilag", "!bang", "!unbang", "!boombox", "!camlock", "!uncamlock", "!clicktp", "!cmdbar", "!console", "!copychat", "!uncopychat", "!crosshair", "!unload",
	"!disablefalldamage", "!enable inventory", "!enable playerlist",
	"!esp all", "!explode", "!fire", "!firstp", "!fling", "!flashlight", "!fly",
	"!flyspeed", "!freecam", "!freeze", "!gravity", "!resetgravity", "!infjump", "!joinlogs", "!jerk", "!unjerk", "!jump",
	"!kill", "!lay", "!leave", "!logs", "!loopgoto", "!tpwalk", "!untpwalk", "!unloopgoto", "!noclip", "!mm2", "!orbit", "!unorbit", "!ping", "!ragdoll",
	"!rejoin", "!removewaypoint", "!resetspeed", "!resettime", "!sit", "!speed", "!serverhop",
	"!spin", "!stopwatch", "!sunglare", "!superjump", "!unsuperjump", "!thirdp", "!timeset", "!to", "!trip", "!tracers",
	"!unantilag", "!uncrosshair", "!unesp", "!unfire", "!unfling", "!unflashlight", "!unfly",
	"!unfreecam", "!unfreeze", "!unnoclip", "!unragdoll",
	"!unsunglare", "!unspin", "!untracers", "!unview", "!unvehiclefly", "!unwalkonwater", "!unxray", "!unzoom", "!view", "!vehiclefly", "!volume", "!waypoint",
	"!walkonwater", "!xray", "!zoom", "!fov", "!kick", "!unlockmouse"
}

-- Populate command list panel (FIXED: Proper hover detection for ScrollingFrame)
local function createCmdListButton(cmd)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, math.floor(24 * scale))
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
	btn.BackgroundTransparency = 0.45
	btn.Text = "  " .. cmd
	btn.Font = Enum.Font.Code
	btn.TextSize = math.floor(11 * fontScale)
	btn.TextColor3 = Color3.fromRGB(205, 205, 225)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = listScroll
	btn.ZIndex = 2147483647
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

	local isHovered = false

	btn.MouseEnter:Connect(function()
		isHovered = true
		btn.BackgroundColor3 = Color3.fromRGB(55, 55, 85)
		btn.TextColor3 = Color3.fromRGB(100, 200, 255)
	end)

	btn.MouseLeave:Connect(function()
		isHovered = false
		btn.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
		btn.TextColor3 = Color3.fromRGB(205, 205, 225)
	end)

	-- FIX: Reset hover state when scrolling away
	listScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if isHovered then
			local mousePos = UserInputService:GetMouseLocation()
			local absPos = btn.AbsolutePosition
			local absSize = btn.AbsoluteSize
			if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
			   mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
				isHovered = false
				btn.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
				btn.TextColor3 = Color3.fromRGB(205, 205, 225)
			end
		end
	end)

	btn.MouseButton1Click:Connect(function()
		cmdInput.Text = cmd .. " "
		cmdInput.CursorPosition = #cmdInput.Text + 1
		cmdListPanel.Visible = false
		cmdInput:CaptureFocus()
	end)

	return btn
end

for _, cmd in ipairs(allCommands) do
	createCmdListButton(cmd)
end

listScroll.CanvasSize = UDim2.new(0, 0, 0, #allCommands * math.floor(26 * scale))

-- Panel close
panelClose.MouseButton1Click:Connect(function()
	cmdListPanel.Visible = false
end)

-- Toggle command list panel
cmdListBtn.MouseButton1Click:Connect(function()
	cmdListPanel.Visible = not cmdListPanel.Visible
end)

-- Execute command function
function executeCommand()
	local cmdText = cmdInput.Text:match("^%s*(.-)%s*$")
	if cmdText and cmdText ~= "" then
		if notify then
			notify("▶️ " .. cmdText, Color3.fromRGB(100, 200, 255))
		end
		if processCmd then
			processCmd(cmdText)
		else
			warn("processCmd not found!")
		end
		cmdInput.Text = ""
		dropdown.Visible = false
		cmdScroll.Visible = true
	end
end

execBtn.MouseButton1Click:Connect(executeCommand)

cmdInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then executeCommand() end
end)


function updateDropdown(text)
	for _, child in ipairs(dropdownScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	if text == "" then
		dropdown.Visible = false
		cmdScroll.Visible = true
		return
	end

	-- Hide the big command list so dropdown is clickable on top
	cmdScroll.Visible = false

	local matches = {}
	local lowerText = text:lower()

	-- Priority 1: Starts with text
	for _, cmd in ipairs(allCommands) do
		if cmd:lower():sub(1, #lowerText) == lowerText then
			table.insert(matches, cmd)
		end
	end

	-- Priority 2: Contains text anywhere
	for _, cmd in ipairs(allCommands) do
		local alreadyAdded = false
		for _, m in ipairs(matches) do
			if m == cmd then alreadyAdded = true break end
		end
		if not alreadyAdded and cmd:lower():find(lowerText, 1, true) then
			table.insert(matches, cmd)
		end
	end

	-- Priority 3: Fuzzy match (each char appears in order)
	if #matches == 0 then
		for _, cmd in ipairs(allCommands) do
			local cmdLower = cmd:lower()
			local textIdx = 1
			for i = 1, #cmdLower do
				if cmdLower:sub(i, i) == lowerText:sub(textIdx, textIdx) then
					textIdx = textIdx + 1
					if textIdx > #lowerText then break end
				end
			end
			if textIdx > #lowerText then
				table.insert(matches, cmd)
			end
		end
	end

	if #matches > 0 then
		dropdown.Visible = true
		for _, match in ipairs(matches) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, math.floor(24 * scale))
			btn.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
			btn.BackgroundTransparency = 0.4
			btn.Text = "  " .. match
			btn.Font = Enum.Font.Code
			btn.TextSize = math.floor(12 * fontScale)
			btn.TextColor3 = Color3.fromRGB(220, 220, 240)
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Parent = dropdownScroll
			btn.ZIndex = 2147483647
			btn.AutoButtonColor = false
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

			btn.MouseButton1Click:Connect(function()
				cmdInput.Text = match .. " "
				cmdInput.CursorPosition = #cmdInput.Text + 1
				dropdown.Visible = false
				cmdScroll.Visible = true
				cmdInput:CaptureFocus()
			end)

			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(55, 55, 85)
				btn.TextColor3 = Color3.fromRGB(100, 200, 255)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
				btn.TextColor3 = Color3.fromRGB(220, 220, 240)
			end)
		end
		dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #matches * math.floor(26 * scale))
	else
		dropdown.Visible = false
		cmdScroll.Visible = true
	end
end

cmdInput:GetPropertyChangedSignal("Text"):Connect(function()
	updateDropdown(cmdInput.Text)
end)


-- Click outside to close dropdown and panel (FIXED: Don't close when clicking inside dropdown)
UserInputService.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if not cmdBarFrame then return end
		local mousePos = UserInputService:GetMouseLocation()
		local barPos = cmdBarFrame.AbsolutePosition
		local barSize = cmdBarFrame.AbsoluteSize

		-- Check if click is inside dropdown
		local inDropdown = false
		if dropdown.Visible then
			local ddPos = dropdown.AbsolutePosition
			local ddSize = dropdown.AbsoluteSize
			inDropdown = mousePos.X >= ddPos.X and mousePos.X <= ddPos.X + ddSize.X and
						mousePos.Y >= ddPos.Y and mousePos.Y <= ddPos.Y + ddSize.Y
		end

		local inBar = mousePos.X >= barPos.X and mousePos.X <= barPos.X + barSize.X and
					  mousePos.Y >= barPos.Y and mousePos.Y <= barPos.Y + barSize.Y

		local panelPos = cmdListPanel.AbsolutePosition
		local panelSize = cmdListPanel.AbsoluteSize
		local inPanel = cmdListPanel.Visible and
			mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
			mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y

		if not inBar and not inDropdown then
			dropdown.Visible = false
			cmdScroll.Visible = true
		end
		if not inPanel and not inBar then cmdListPanel.Visible = false end
	end
end)
-- Scroll Frame
cmdScroll = Instance.new("ScrollingFrame", cmdFrame)
cmdScroll.Size = UDim2.new(1, 0, 1, math.floor(-48 * scale))
cmdScroll.Position = UDim2.new(0, 0, 0, math.floor(48 * scale))
cmdScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
cmdScroll.BorderSizePixel = 0
cmdScroll.ScrollBarThickness = math.floor(6 * scale)
cmdScroll.ScrollBarImageColor3 = currentTheme.accent
cmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cmdScroll.ZIndex = 2147483647
Instance.new("UICorner", cmdScroll).CornerRadius = UDim.new(0, 6)

cmdList = Instance.new("UIListLayout", cmdScroll)
cmdList.Padding = UDim.new(0, math.floor(6 * scale))
cmdList.SortOrder = Enum.SortOrder.LayoutOrder

local cmdDesc = {
	["!aimbot"] = "Opens aimbot control panel",
	["!antilag"] = "antilag",
	["!bang [user] [speed]"] = "Rape someone lol",
	["!boombox"] = "Enables client sided boombox",
	["!camlock [player]"] = "Lock camera on a player",
	["!clicktp"] = "Click to teleport",
	["!cmdbar"] = "Toggle command bar",
	["!console"] = "Opens dev console",
	["!copychat [player]"] = "Copy everything a player says",
	["!crosshair"] = "Loads custom crosshair",
	["!disablefalldamage"] = "WIP",
	["!enable inventory"] = "Toggle backpack",
	["!enable playerlist"] = "Toggle player list",
	["!esp all"] = "Enable esp on player or all",
	["!explode [plr]"] = "Explodes player(visual)",
	["!fire [plr]"] = "Sets player on fire(visual)",
	["!firstp"] = "First person mode",
	["!fling"] = "Opens fling GUI",
	["!flashlight"] = "Turns on flashlight",
	["!fly"] = "Opens fly panel",
	["!flyspeed [num]"] = "Set fly speed",
	["!fov [1-120]"] = "Set camera FOV",
	["!freecam"] = "Free camera mode",
	["!freeze"] = "Freezes player",
	["!gravity [num]"] = "Set gravity",
	["!infjump"] = "Infinite jump toggle",
	["!jerk"] = "Gives jerk off tool",
	["!joinlogs"] = "Show join/leave logs",
	["!jump [power]"] = "Set jump power",
	["!kick"] = "Kick yourself",
	["!kill"] = "Kill self",
	["!lay"] = "Makes character lay down",
	["!leave"] = "Leave game",
	["!logs"] = "Open chat logs",
	["!loopgoto [player] [delay]"] = "Repeatedly teleport to a player",
	["!mm2"] = "Enables mm2 esp by lunar",
	["!noclip"] = "Walk through walls",
	["!orbit [player] [speed]"] = "Orbit around a player like a moon",
	["!ping"] = "Show ping",
	["!ragdoll"] = "Ragdoll character(Broken?)",
	["!rejoin"] = "Rejoin server",
	["!removewaypoint"] = "Remove last waypoint",
	["!resetgravity"] = "Reset gravity to normal",
	["!resetspeed"] = "Reset walkspeed",
	["!resettime"] = "Reset time of day",
	["!serverhop"] = "(Broken)",
	["!sit"] = "Makes character sit",
	["!speed [plr] [num]"] = "Set walkspeed",
	["!spin [speed]"] = "Spin character",
	["!stopwatch"] = "Open stopwatch",
	["!sunglare"] = "Enable sun glare effect",
	["!superjump [power]"] = "Mega jump",
	["!thirdp"] = "Third person mode",
	["!timeset [0-24]"] = "Change time of day",
	["!to [plr]"] = "Teleport to player",
	["!tpwalk [speed]"] = "Teleport walk — move by teleporting",
	["!trip [plr]"] = "Makes player trip",
	["!tracers"] = "Show player tracers",
	["!unantilag"] = "unantilag",
	["!unbang"] = "unRape someone lol",
	["!uncamlock"] = "Unlock camera",
	["!uncopychat"] = "Stop copying chat",
	["!uncrosshair"] = "Remove crosshair",
	["!unesp [plr/all]"] = "Disable esp on player or all",
	["!unfire"] = "Extinguish player(visual)",
	["!unfling"] = "Close fling GUI",
	["!unflashlight"] = "Turns off flashlight",
	["!unfly"] = "Stop flying",
	["!unfreecam"] = "Disable freecam",
	["!unfreeze"] = "Unfreeze player",
	["!uninfjump"] = "Disable infinite jump",
	["!unjerk"] = "Removes jerk off tool",
	["!unloopgoto"] = "Stop loop teleport",
	["!unnoclip"] = "Disable noclip",
	["!unorbit"] = "Stop orbiting",
	["!unragdoll"] = "Stop ragdoll",
	["!unsunglare"] = "Disable sun glare effect",
	["!unsuperjump"] = "Disable super jump",
	["!unspin"] = "Stop spinning",
	["!untpwalk"] = "Disable teleport walk",
	["!untracers"] = "Hide tracers",
	["!unvehiclefly"] = "unFly in cars!",
	["!unview"] = "Stop spectating",
	["!unwalkonwater"] = "Disable walk on water",
	["!unxray"] = "Disable xray",
	["!unzoom"] = "Reset zoom",
	["!vehiclefly"] = "Fly in cars!",
	["!view [plr]"] = "Spectate player",
	["!volume"] = "Set game volume (0-10)",
	["!walkonwater"] = "Walk on any water surface",
	["!waypoint"] = "Create waypoint",
	["!xray"] = "See through walls",
	["!zoom [distance] [key]"] = "Custom zoom distance (PC only)",
	["!unlockmouse"] = "Toggle mouse lock"
}

cmds = {
"!aimbot", "!antilag", "!bang [user] [speed]", "!boombox", "!camlock [player]", "!clicktp", "!cmdbar", "!console", "!copychat [player]", "!crosshair",
	"!unload", "!disablefalldamage", "!enable inventory", "!enable playerlist",
	"!esp all", "!explode [plr]", "!fire [plr]", "!firstp", "!fling", "!flashlight", "!fly",
	"!flyspeed [num]", "!freecam", "!freeze", "!gravity [num]", "!infjump", "!joinlogs", "!jerk", "!unjerk", "!jump [power]",
	"!kill", "!lay", "!leave", "!logs", "!loopgoto [player] [delay]", "!noclip", "!mm2", "!orbit [player] [speed]", "!ping", "!ragdoll",
	"!rejoin", "!removewaypoint", "!resetgravity", "!resetspeed", "!tpwalk [speed]", "!untpwalk", "!resettime", "!sit", "!speed [plr] [num]", "!serverhop",
	"!spin [speed]", "!stopwatch", "!sunglare", "!superjump [power]", "!thirdp", "!timeset [0-24]", "!to [plr]", "!trip", "!tracers",
	"!unantilag", "!unbang", "!uncamlock", "!uncopychat", "!uncrosshair", "!unesp all", "!unfire [plr]", "!unfling", "!unflashlight", "!unfly",
	"!unfreecam", "!unfreeze", "!uninfjump", "!unnoclip", "!unloopgoto", "!unorbit", "!unragdoll",
	"!unsunglare", "!unsuperjump", "!unspin", "!untracers", "!unview", "!unvehiclefly", "!unwalkonwater", "!unxray", "!unzoom", 
	"!view [plr]", "!vehiclefly", "!volume", "!waypoint",
	"!walkonwater", "!xray", "!zoom [distance] [key]", "!fov [1-120]", "!kick", "!unlockmouse"
}

-- PC-only tooltip (follows mouse) — sharp corners, no border, like the screenshot
tooltip = nil
if not isMobile then
	tooltip = Instance.new("Frame")
	tooltip.Name = "CmdTooltip"
	tooltip.Size = UDim2.new(0, math.floor(260 * scale), 0, math.floor(60 * scale))
	tooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	tooltip.BorderSizePixel = 0
	tooltip.ZIndex = 2147483647
	tooltip.Visible = false
	tooltip.Parent = lunarGui

	a = Instance.new("TextLabel", tooltip)
	a.Name = "TipText"
	a.Size = UDim2.new(1, math.floor(-16 * scale), 1, math.floor(-12 * scale))
	a.Position = UDim2.new(0, math.floor(8 * scale), 0, math.floor(6 * scale))
	a.BackgroundTransparency = 1
	a.Text = ""
	a.Font = Enum.Font.Code
	a.TextSize = math.floor(13 * fontScale)
	a.TextColor3 = globalConfig.textColor
	a.TextWrapped = true
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.TextYAlignment = Enum.TextYAlignment.Top
	a.ZIndex = 2147483647

	local RunService = game:GetService("RunService")
	local mouseConn = nil
	function followMouse()
		if not tooltip or not tooltip.Visible then return end
		local mousePos = UserInputService:GetMouseLocation()
		local x = mousePos.X + math.floor(16 * scale)
		local y = mousePos.Y + math.floor(16 * scale)
		local vp = workspace.CurrentCamera.ViewportSize
		local tw, th = tooltip.AbsoluteSize.X, tooltip.AbsoluteSize.Y
		if x + tw > vp.X then x = mousePos.X - tw - math.floor(8 * scale) end
		if y + th > vp.Y then y = mousePos.Y - th - math.floor(8 * scale) end
		tooltip.Position = UDim2.new(0, x, 0, y)
	end
	mouseConn = RunService.RenderStepped:Connect(followMouse)
end

for i, cmdStr in ipairs(cmds) do
	a = Instance.new("TextButton")
	a.Size = UDim2.new(1, math.floor(-10 * scale), 0, math.floor(42 * scale))
	a.BackgroundColor3 = currentTheme.list or Color3.fromRGB(40, 40, 48)
	a.Text = "  " .. cmdStr
	a.Font = Enum.Font.Code
	a.TextSize = math.floor(14 * fontScale)
	a.TextColor3 = globalConfig.textColor
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.TextStrokeTransparency = 0.5
	a.TextStrokeColor3 = Color3.new(0,0,0)
	a.BorderSizePixel = 0
	a.Parent = cmdScroll
	a.LayoutOrder = i
	a.ZIndex = 2147483647
	Instance.new("UICorner", a).CornerRadius = UDim.new(0, 6)

	local desc = cmdDesc[cmdStr]
	if desc then
		a.MouseEnter:Connect(function()
			a.BackgroundColor3 = currentTheme.btn or Color3.fromRGB(50, 50, 60)
			a.TextColor3 = currentTheme.accent
			if tooltip and not isMobile then
				tooltip.Visible = true
				tooltip:FindFirstChild("TipText").Text = desc
				local textService = game:GetService("TextService")
				local textSize = textService:GetTextSize(desc, math.floor(13 * fontScale), Enum.Font.Code, Vector2.new(math.floor(244 * scale), 9999))
				tooltip.Size = UDim2.new(0, math.floor(260 * scale), 0, math.max(math.floor(44 * scale), textSize.Y + math.floor(20 * scale)))
			end
		end)
		a.MouseLeave:Connect(function()
			a.BackgroundColor3 = currentTheme.list or Color3.fromRGB(40, 40, 48)
			a.TextColor3 = globalConfig.textColor
			if tooltip and not isMobile then
				tooltip.Visible = false
			end
		end)
	end

	a.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(cmdStr)
			notify("Copied: " .. cmdStr, Color3.fromRGB(100, 255, 100))
		end
	end)
end

-- ========== SETTINGS TAB ==========
setFrame = Instance.new("Frame", contentFrame)
setFrame.Name = "SetFrame"
setFrame.Size = UDim2.new(1, 0, 1, 0)
setFrame.BackgroundTransparency = 1
setFrame.Visible = false
setFrame.ZIndex = 2147483647

setScroll = Instance.new("ScrollingFrame", setFrame)
setScroll.Size = UDim2.new(1, 0, 1, 0)
setScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
setScroll.BorderSizePixel = 0
setScroll.ScrollBarThickness = math.floor(6 * scale)
setScroll.ScrollBarImageColor3 = currentTheme.accent
setScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
setScroll.ZIndex = 2147483647
Instance.new("UICorner", setScroll).CornerRadius = UDim.new(0, 6)

setList = Instance.new("UIListLayout", setScroll)
setList.Padding = UDim.new(0, math.floor(12 * scale))
setList.SortOrder = Enum.SortOrder.LayoutOrder

-- Section creator
function makeSection(parent, titleText, h)
	local s = Instance.new("Frame", parent)
	s.Size = UDim2.new(1, math.floor(-16 * scale), 0, math.floor(h * scale))
	s.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	s.BorderSizePixel = 0
	s.LayoutOrder = #parent:GetChildren()
	s.ZIndex = 2147483647
	Instance.new("UICorner", s).CornerRadius = UDim.new(0, 8)

	local t = Instance.new("TextLabel", s)
	t.Size = UDim2.new(1, math.floor(-20 * scale), 0, math.floor(28 * scale))
	t.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(8 * scale))
	t.BackgroundTransparency = 1
	t.Text = titleText
	t.Font = Enum.Font.Code
	t.TextSize = math.floor(16 * fontScale)
	t.TextColor3 = currentTheme.accent
	t.TextStrokeTransparency = 0.5
	t.TextStrokeColor3 = Color3.new(0,0,0)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.ZIndex = 2147483647

	return s
end

-- Text Color Section
cSection = makeSection(setScroll, "TEXT COLOR", 170)

cDisplay = Instance.new("TextLabel", cSection)
cDisplay.Size = UDim2.new(0.8, 0, 0, math.floor(32 * scale))
cDisplay.Position = UDim2.new(0.1, 0, 0, math.floor(38 * scale))
cDisplay.BackgroundColor3 = globalConfig.textColor
cDisplay.Text = "Preview"
cDisplay.Font = Enum.Font.Code
cDisplay.TextSize = math.floor(15 * fontScale)
cDisplay.TextColor3 = Color3.new(0,0,0)
cDisplay.ZIndex = 2147483647
Instance.new("UICorner", cDisplay).CornerRadius = UDim.new(0, 6)

-- FIXED SLIDER SYSTEM
sliders = {}
activeSliderComp = nil

function makeSlider(parent, y, color, label, comp)
	local cont = Instance.new("Frame", parent)
	cont.Size = UDim2.new(0.8, 0, 0, math.floor(24 * scale))
	cont.Position = UDim2.new(0.1, 0, 0, math.floor(y * scale))
	cont.BackgroundTransparency = 1
	cont.ZIndex = 2147483647

	local lab = Instance.new("TextLabel", cont)
	lab.Size = UDim2.new(0, math.floor(30 * scale), 1, 0)
	lab.BackgroundTransparency = 1
	lab.Text = label
	lab.Font = Enum.Font.Code
	lab.TextSize = math.floor(12 * fontScale)
	lab.TextColor3 = color
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.ZIndex = 2147483647

	local track = Instance.new("Frame", cont)
	track.Size = UDim2.new(1, math.floor(-40 * scale), 0, math.floor(8 * scale))
	track.Position = UDim2.new(0, math.floor(35 * scale), 0.5, math.floor(-4 * scale))
	track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	track.BorderSizePixel = 0
	track.ZIndex = 2147483647
	Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)

	local fill = Instance.new("Frame", track)
	local val = comp == "R" and globalConfig.textColor.R or comp == "G" and globalConfig.textColor.G or globalConfig.textColor.B
	fill.Size = UDim2.new(val, 0, 1, 0)
	fill.BackgroundColor3 = color
	fill.BorderSizePixel = 0
	fill.ZIndex = 2147483647
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

	local knob = Instance.new("Frame", track)
	knob.Size = UDim2.new(0, math.floor(14 * scale), 0, math.floor(14 * scale))
	knob.Position = UDim2.new(val, math.floor(-7 * scale), 0.5, math.floor(-7 * scale))
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 2147483647
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	sliders[comp] = {
		track = track,
		fill = fill,
		knob = knob
	}

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			activeSliderComp = comp
			local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(pos, 0, 1, 0)
			knob.Position = UDim2.new(pos, math.floor(-7 * scale), 0.5, math.floor(-7 * scale))
			updateAllColors()
		end
	end)
end

function updateAllColors()
	local r = sliders.R and sliders.R.fill.Size.X.Scale or globalConfig.textColor.R
	local g = sliders.G and sliders.G.fill.Size.X.Scale or globalConfig.textColor.G
	local b = sliders.B and sliders.B.fill.Size.X.Scale or globalConfig.textColor.B

	local newC = Color3.new(r, g, b)
	globalConfig.textColor = newC
	cDisplay.BackgroundColor3 = newC

	if lunarGui then
		for _, obj in ipairs(lunarGui:GetDescendants()) do
			if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj.TextColor3 ~= currentTheme.accent then
				obj.TextColor3 = newC
			end
		end
	end
end

makeSlider(cSection, 78, Color3.fromRGB(255, 80, 80), "R", "R")
makeSlider(cSection, 106, Color3.fromRGB(80, 255, 80), "G", "G")
makeSlider(cSection, 134, Color3.fromRGB(80, 140, 255), "B", "B")

-- Global slider input handlers
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		activeSliderComp = nil
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not activeSliderComp then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

	local s = sliders[activeSliderComp]
	if not s then return end

	local pos = math.clamp((input.Position.X - s.track.AbsolutePosition.X) / s.track.AbsoluteSize.X, 0, 1)
	s.fill.Size = UDim2.new(pos, 0, 1, 0)
	s.knob.Position = UDim2.new(pos, math.floor(-7 * scale), 0.5, math.floor(-7 * scale))
	updateAllColors()
end)

-- UI Transparency Section
tSection = makeSection(setScroll, "UI TRANSPARENCY", 110)

tLabel = Instance.new("TextLabel", tSection)
tLabel.Size = UDim2.new(1, 0, 0, math.floor(22 * scale))
tLabel.Position = UDim2.new(0, 0, 0, math.floor(36 * scale))
tLabel.BackgroundTransparency = 1
tLabel.Text = "Transparency: " .. math.round(globalConfig.uiTransparency * 100) .. "%"
tLabel.Font = Enum.Font.Code
tLabel.TextSize = math.floor(14 * fontScale)
tLabel.TextColor3 = globalConfig.textColor
tLabel.ZIndex = 2147483647

tTrack = Instance.new("Frame", tSection)
tTrack.Size = UDim2.new(0.8, 0, 0, math.floor(10 * scale))
tTrack.Position = UDim2.new(0.1, 0, 0, math.floor(68 * scale))
tTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
tTrack.BorderSizePixel = 0
tTrack.ZIndex = 2147483647
Instance.new("UICorner", tTrack).CornerRadius = UDim.new(0, 5)

tFill = Instance.new("Frame", tTrack)
tFill.Size = UDim2.new(globalConfig.uiTransparency, 0, 1, 0)
tFill.BackgroundColor3 = currentTheme.accent
tFill.BorderSizePixel = 0
tFill.ZIndex = 2147483647
Instance.new("UICorner", tFill).CornerRadius = UDim.new(0, 5)

tKnob = Instance.new("Frame", tTrack)
tKnob.Size = UDim2.new(0, math.floor(16 * scale), 0, math.floor(16 * scale))
tKnob.Position = UDim2.new(globalConfig.uiTransparency, math.floor(-8 * scale), 0.5, math.floor(-8 * scale))
tKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tKnob.BorderSizePixel = 0
tKnob.ZIndex = 2147483647
Instance.new("UICorner", tKnob).CornerRadius = UDim.new(1, 0)

local tDragging = false

function updateTrans(x)
	local pos = math.clamp((x - tTrack.AbsolutePosition.X) / tTrack.AbsoluteSize.X, 0, 1)
	tFill.Size = UDim2.new(pos, 0, 1, 0)
	tKnob.Position = UDim2.new(pos, math.floor(-8 * scale), 0.5, math.floor(-8 * scale))
	globalConfig.uiTransparency = pos
	tLabel.Text = "Transparency: " .. math.round(pos * 100) .. "%"
	if mainFrame then
		mainFrame.BackgroundTransparency = pos
	end
end

tTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = true
		updateTrans(input.Position.X)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateTrans(input.Position.X)
	end
end)

-- ========== SOUND SETTINGS SECTION ==========
do
	local mSection = makeSection(setScroll, "SOUND SETTINGS", 320)

	_G.uiSoundVol = 1
	_G.notifSoundVol = 0.55
	_G.customNotifId = "rbxassetid://97643101798871"

	local activeSlider = nil

	local function mkSlider(parent, y, lbl, def, key)
		local c = Instance.new("Frame", parent)
		c.Size = UDim2.new(0.9, 0, 0, math.floor(50*scale))
		c.Position = UDim2.new(0.05, 0, 0, math.floor(y*scale))
		c.BackgroundTransparency = 1
		c.ZIndex = 2147483647

		local lab = Instance.new("TextLabel", c)
		lab.Size = UDim2.new(1, 0, 0, math.floor(18*scale))
		lab.BackgroundTransparency = 1
		lab.Text = lbl..": "..math.round(def*100).."%"
		lab.Font = Enum.Font.Code
		lab.TextSize = math.floor(13*fontScale)
		lab.TextColor3 = globalConfig.textColor
		lab.TextXAlignment = Enum.TextXAlignment.Left
		lab.ZIndex = 2147483647

		local track = Instance.new("Frame", c)
		track.Size = UDim2.new(1, 0, 0, math.floor(10*scale))
		track.Position = UDim2.new(0, 0, 0, math.floor(26*scale))
		track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		track.BorderSizePixel = 0
		track.ZIndex = 2147483647
		Instance.new("UICorner", track).CornerRadius = UDim.new(0, 5)

		local fill = Instance.new("Frame", track)
		fill.Size = UDim2.new(def, 0, 1, 0)
		fill.BackgroundColor3 = currentTheme.accent
		fill.BorderSizePixel = 0
		fill.ZIndex = 2147483647
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

		local knob = Instance.new("Frame", track)
		knob.Size = UDim2.new(0, math.floor(16*scale), 0, math.floor(16*scale))
		knob.Position = UDim2.new(def, math.floor(-8*scale), 0.5, math.floor(-8*scale))
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		knob.ZIndex = 2147483647
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

		local function setVol(x)
			local v = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(v, 0, 1, 0)
			knob.Position = UDim2.new(v, math.floor(-8*scale), 0.5, math.floor(-8*scale))
			lab.Text = lbl..": "..math.round(v*100).."%"
			_G[key] = v
		end

		track.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				activeSlider = key
				setVol(inp.Position.X)
			end
		end)

		track.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if activeSlider == key then activeSlider = nil end
			end
		end)

		return setVol
	end

	local uiSetVol = mkSlider(mSection, 38, "UI Vol", 1, "uiSoundVol")
	local nfSetVol = mkSlider(mSection, 96, "Notif Vol", 0.55, "notifSoundVol")

	UserInputService.InputChanged:Connect(function(inp)
		if not activeSlider then return end
		if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
		if activeSlider == "uiSoundVol" then
			uiSetVol(inp.Position.X)
		else
			nfSetVol(inp.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			activeSlider = nil
		end
	end)

	local c = Instance.new("Frame", mSection)
	c.Size = UDim2.new(0.9, 0, 0, math.floor(70*scale))
	c.Position = UDim2.new(0.05, 0, 0, math.floor(154*scale))
	c.BackgroundTransparency = 1
	c.ZIndex = 2147483647

	local l = Instance.new("TextLabel", c)
	l.Size = UDim2.new(1, 0, 0, math.floor(18*scale))
	l.BackgroundTransparency = 1
	l.Text = "Custom Notif Sound ID"
	l.Font = Enum.Font.Code
	l.TextSize = math.floor(13*fontScale)
	l.TextColor3 = globalConfig.textColor
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 2147483647

	local b = Instance.new("TextBox", c)
	b.Size = UDim2.new(1, math.floor(-70*scale), 0, math.floor(36*scale))
	b.Position = UDim2.new(0, 0, 0, math.floor(24*scale))
	b.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	b.BorderSizePixel = 0
	b.Text = "rbxassetid://97643101798871"
	b.PlaceholderText = "rbxassetid://..."
	b.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
	b.Font = Enum.Font.Code
	b.TextSize = math.floor(13*fontScale)
	b.TextColor3 = globalConfig.textColor
	b.ClearTextOnFocus = false
	b.ZIndex = 2147483647
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	b.TextEditable = true
	b.ClearTextOnFocus = false

	local btn = Instance.new("TextButton", c)
	btn.Size = UDim2.new(0, math.floor(60*scale), 0, math.floor(28*scale))
	btn.Position = UDim2.new(1, math.floor(-65*scale), 0, math.floor(28*scale))
	btn.BackgroundColor3 = currentTheme.accent
	btn.Text = "Set"
	btn.Font = Enum.Font.Code
	btn.TextSize = math.floor(12*fontScale)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.BorderSizePixel = 0
	btn.ZIndex = 2147483647
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

	btn.MouseButton1Click:Connect(function()
		local t = b.Text:gsub("%s+", "")
		if t ~= "" then
			if not t:find("rbxassetid://") and tonumber(t) then t = "rbxassetid://"..t end
			_G.customNotifId = t
			notify("Sound ID set!", Color3.fromRGB(100, 255, 100))
		end
	end)

	b.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local t = b.Text:gsub("%s+", "")
			if t ~= "" then
				if not t:find("rbxassetid://") and tonumber(t) then t = "rbxassetid://"..t end
				_G.customNotifId = t
				notify("Sound ID set!", Color3.fromRGB(100, 255, 100))
			end
		end
	end)

	local test = Instance.new("TextButton", mSection)
	test.Size = UDim2.new(0.9, 0, 0, math.floor(32*scale))
	test.Position = UDim2.new(0.05, 0, 0, math.floor(232*scale))
	test.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	test.Text = "▶ Test Sound"
	test.Font = Enum.Font.Code
	test.TextSize = math.floor(13*fontScale)
	test.TextColor3 = Color3.new(1, 1, 1)
	test.BorderSizePixel = 0
	test.ZIndex = 2147483647
	Instance.new("UICorner", test).CornerRadius = UDim.new(0, 6)

	test.MouseButton1Click:Connect(function()
		if notifSoundMuted then notify("Notif sounds muted!", Color3.fromRGB(255, 100, 100)); return end
		local s = Instance.new("Sound"); s.SoundId = _G.customNotifId; s.Volume = _G.notifSoundVol
		s.Parent = SoundService; s:Play(); Debris:AddItem(s, 4)
	end)

	local mc = Instance.new("Frame", mSection)
	mc.Size = UDim2.new(0.9, 0, 0, math.floor(36*scale))
	mc.Position = UDim2.new(0.05, 0, 0, math.floor(272*scale))
	mc.BackgroundTransparency = 1
	mc.ZIndex = 2147483647

	local function mkMute(parent, x, w, st, on, off, isUi)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(w, 0, 1, 0)
		btn.Position = UDim2.new(x, 0, 0, 0)
		btn.BackgroundColor3 = st and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 180, 80)
		btn.Text = st and off or on
		btn.Font = Enum.Font.Code
		btn.TextSize = math.floor(13*fontScale)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BorderSizePixel = 0
		btn.ZIndex = 2147483647
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			if isUi then
				soundMuted = not soundMuted
				btn.BackgroundColor3 = soundMuted and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 180, 80)
				btn.Text = soundMuted and off or on
				if soundMuted then notify("UI sounds muted", Color3.fromRGB(255, 100, 100))
				else
					notify("UI sounds enabled", Color3.fromRGB(100, 255, 100))
					local s = Instance.new("Sound"); s.SoundId = "rbxassetid://109439703653606"; s.Volume = _G.uiSoundVol*0.3
					s.Parent = SoundService; s:Play(); Debris:AddItem(s, 1)
				end
			else
				notifSoundMuted = not notifSoundMuted
				btn.BackgroundColor3 = notifSoundMuted and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 180, 80)
				btn.Text = notifSoundMuted and off or on
				notify(notifSoundMuted and "Notif sounds muted" or "Notif sounds enabled", notifSoundMuted and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100))
			end
		end)
	end

	mkMute(mc, 0, 0.48, soundMuted, "🔊 UI", "🔇 UI", true)
	mkMute(mc, 0.52, 0.48, notifSoundMuted, "🔊 Notif", "🔇 Notif", false)
end

-- ========== THEME SELECTOR SECTION ==========
thSection = makeSection(setScroll, "THEME SELECTOR", 0)

thCont = Instance.new("Frame", thSection)
thCont.Size = UDim2.new(1, math.floor(-20 * scale), 1, math.floor(-40 * scale))
thCont.Position = UDim2.new(0, math.floor(10 * scale), 0, math.floor(36 * scale))
thCont.BackgroundTransparency = 1
thCont.ZIndex = 2147483647

local sortedThemes = {}
for name in pairs(themes) do
	table.insert(sortedThemes, name)
end
table.sort(sortedThemes)

local thCount = #sortedThemes
local cols = 2
local rows = math.ceil(thCount / cols)

local sectionHeight = math.floor(36 * scale) + math.floor(rows * 55 * scale) + math.floor(10 * scale)
thSection.Size = UDim2.new(1, math.floor(-16 * scale), 0, sectionHeight)

thGrid = Instance.new("UIGridLayout", thCont)
thGrid.CellSize = UDim2.new(0.48, 0, 0, math.floor(45 * scale))
thGrid.CellPadding = UDim2.new(0, math.floor(10 * scale), 0, math.floor(10 * scale))
thGrid.SortOrder = Enum.SortOrder.LayoutOrder
thGrid.FillDirection = Enum.FillDirection.Horizontal
thGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
thGrid.VerticalAlignment = Enum.VerticalAlignment.Top

for i, name in ipairs(sortedThemes) do
	local th = themes[name]
	local themeBtn = Instance.new("TextButton", thCont)
	themeBtn.Name = name .. "ThemeBtn"
	themeBtn.BackgroundColor3 = th.accent
	themeBtn.Text = name
	themeBtn.Font = Enum.Font.Code
	themeBtn.TextSize = math.floor(13 * fontScale)
	themeBtn.TextColor3 = th.text
	themeBtn.TextScaled = false
	themeBtn.TextWrapped = true
	themeBtn.TextTruncate = Enum.TextTruncate.AtEnd
	themeBtn.BorderSizePixel = 0
	themeBtn.LayoutOrder = i
	themeBtn.ZIndex = 2147483647
	Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 6)

	local btnStroke = Instance.new("UIStroke", themeBtn)
	btnStroke.Color = Color3.fromRGB(255, 255, 255)
	btnStroke.Transparency = 0.85
	btnStroke.Thickness = 1

	themeBtn.MouseButton1Click:Connect(function()
		local oldTheme = currentTheme
		currentTheme = th

		mainFrame.BackgroundColor3 = th.glass
		if topBar then topBar.BackgroundColor3 = th.glass end

		titleLabel.TextColor3 = th.accent

		cmdTab.BackgroundColor3 = th.accent
		cmdTab.TextColor3 = th.text
		setTab.BackgroundColor3 = th.btn
		setTab.TextColor3 = globalConfig.textColor

		cmdBarFrame.BackgroundColor3 = th.list

		if cmdScroll then cmdScroll.BackgroundColor3 = th.glass end
		if setScroll then setScroll.BackgroundColor3 = th.glass end

		for _, obj in ipairs(lunarGui:GetDescendants()) do
			if obj:IsDescendantOf(thCont) then continue end

			if obj:IsA("TextButton") then
				if obj.BackgroundColor3 == oldTheme.accent then obj.BackgroundColor3 = th.accent end
				if obj.BackgroundColor3 == oldTheme.btn then obj.BackgroundColor3 = th.btn end
				if obj.BackgroundColor3 == oldTheme.glass then obj.BackgroundColor3 = th.glass end
				if obj.BackgroundColor3 == oldTheme.list then obj.BackgroundColor3 = th.list end
				if obj.TextColor3 == oldTheme.accent then obj.TextColor3 = th.accent end
				if obj.TextColor3 == oldTheme.text then obj.TextColor3 = th.text end
			end
			if obj:IsA("TextLabel") then
				if obj.TextColor3 == oldTheme.accent then obj.TextColor3 = th.accent end
				if obj.TextColor3 == oldTheme.text then obj.TextColor3 = th.text end
			end
			if obj:IsA("Frame") then
				if obj.BackgroundColor3 == oldTheme.glass then obj.BackgroundColor3 = th.glass end
				if obj.BackgroundColor3 == oldTheme.list then obj.BackgroundColor3 = th.list end
				if obj.BackgroundColor3 == oldTheme.btn then obj.BackgroundColor3 = th.btn end
			end
		end

		for _, s in pairs(sliders) do
			if s and s.fill and s.fill.BackgroundColor3 == oldTheme.accent then
				s.fill.BackgroundColor3 = th.accent
			end
		end
		if tFill and tFill.BackgroundColor3 == oldTheme.accent then
			tFill.BackgroundColor3 = th.accent
		end

		for _, obj in ipairs(cmdScroll:GetChildren()) do
			if obj:IsA("TextButton") then
				if obj.BackgroundColor3 == Color3.fromRGB(40, 40, 48) or obj.BackgroundColor3 == (oldTheme.list or Color3.fromRGB(40, 40, 48)) then
					obj.BackgroundColor3 = th.list or Color3.fromRGB(40, 40, 48)
				end
				if obj.BackgroundColor3 == Color3.fromRGB(50, 50, 60) or obj.BackgroundColor3 == (oldTheme.btn or Color3.fromRGB(50, 50, 60)) then
					obj.BackgroundColor3 = th.btn or Color3.fromRGB(50, 50, 60)
				end
			end
		end

		cDisplay.BackgroundColor3 = globalConfig.textColor
		notify("Theme changed to " .. name, th.accent)
	end)
end

-- Discord Section
dSection = makeSection(setScroll, "COMMUNITY", 90)
dSection.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

dBtn = Instance.new("TextButton", dSection)
dBtn.Size = UDim2.new(0.9, 0, 0, math.floor(40 * scale))
dBtn.Position = UDim2.new(0.05, 0, 0, math.floor(38 * scale))
dBtn.BackgroundColor3 = Color3.fromRGB(120, 130, 255)
dBtn.Text = "Join Discord Server"
dBtn.Font = Enum.Font.Code
dBtn.TextSize = math.floor(16 * fontScale)
dBtn.TextColor3 = Color3.new(1,1,1)
dBtn.ZIndex = 2147483647
Instance.new("UICorner", dBtn).CornerRadius = UDim.new(0, 6)

dBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/ydNKRbFmUd")
		notify("Discord link copied to clipboard!", Color3.fromRGB(88,101,242))
	else
		notify("Clipboard not supported in this executor", Color3.fromRGB(255,100,100))
	end
end)

-- ========== UNIVERSAL TAB ==========
uniFrame = Instance.new("Frame", contentFrame)
uniFrame.Name = "UniFrame"
uniFrame.Size = UDim2.new(1, 0, 1, 0)
uniFrame.BackgroundTransparency = 1
uniFrame.Visible = false
uniFrame.ZIndex = 2147483647

uniScroll = Instance.new("ScrollingFrame", uniFrame)
uniScroll.Size = UDim2.new(1, 0, 1, 0)
uniScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
uniScroll.BorderSizePixel = 0
uniScroll.ScrollBarThickness = math.floor(4 * scale)
uniScroll.ScrollBarImageColor3 = currentTheme.accent
uniScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
uniScroll.ZIndex = 2147483647
Instance.new("UICorner", uniScroll).CornerRadius = UDim.new(0, 6)

uniList = Instance.new("UIListLayout", uniScroll)
uniList.Padding = UDim.new(0, math.floor(8 * scale))
uniList.SortOrder = Enum.SortOrder.LayoutOrder

-- Reusable element reference
local el

-- TPWalk Section
el = makeSection(uniScroll, "TPWALK", 100)

el = Instance.new("TextBox", el)
el.Name = "TPWalkInput"
el.Size = UDim2.new(0.5, 0, 0, math.floor(28 * scale))
el.Position = UDim2.new(0.05, 0, 0, math.floor(36 * scale))
el.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
el.BorderSizePixel = 0
el.Text = "5"
el.PlaceholderText = "Speed..."
el.PlaceholderColor3 = Color3.fromRGB(80, 80, 90)
el.Font = Enum.Font.Code
el.TextSize = math.floor(12 * fontScale)
el.TextColor3 = globalConfig.textColor
el.ZIndex = 2147483647
Instance.new("UICorner", el).CornerRadius = UDim.new(0, 5)
local tpwalkInput = el

el = Instance.new("TextButton", tpwalkInput.Parent)
el.Size = UDim2.new(0.35, 0, 0, math.floor(28 * scale))
el.Position = UDim2.new(0.6, 0, 0, math.floor(36 * scale))
el.BackgroundColor3 = Color3.fromRGB(45, 100, 70)
el.Text = "Start"
el.Font = Enum.Font.Code
el.TextSize = math.floor(11 * fontScale)
el.TextColor3 = Color3.fromRGB(220, 255, 220)
el.BorderSizePixel = 0
el.ZIndex = 2147483647
Instance.new("UICorner", el).CornerRadius = UDim.new(0, 5)
el.MouseButton1Click:Connect(function()
	local spd = tonumber(tpwalkInput.Text) or 5
	_G.EnableTPWalk({tostring(spd)})
end)

el = Instance.new("TextButton", tpwalkInput.Parent)
el.Size = UDim2.new(0.9, 0, 0, math.floor(24 * scale))
el.Position = UDim2.new(0.05, 0, 0, math.floor(68 * scale))
el.BackgroundColor3 = Color3.fromRGB(80, 45, 45)
el.Text = "Reset / Stop"
el.Font = Enum.Font.Code
el.TextSize = math.floor(11 * fontScale)
el.TextColor3 = Color3.fromRGB(255, 180, 180)
el.BorderSizePixel = 0
el.ZIndex = 2147483647
Instance.new("UICorner", el).CornerRadius = UDim.new(0, 5)
el.MouseButton1Click:Connect(function()
	_G.DisableTPWalk()
end)

-- Quick Actions Section
el = makeSection(uniScroll, "QUICK ACTIONS", 0)

-- Modern muted colors
local btnColors = {
	fly = Color3.fromRGB(55, 75, 110),
	fling = Color3.fromRGB(110, 55, 55),
	aimbot = Color3.fromRGB(110, 70, 40),
	crosshair = Color3.fromRGB(55, 110, 55),
	sit = Color3.fromRGB(75, 55, 110),
	noclip = Color3.fromRGB(90, 80, 40),
	rejoin = Color3.fromRGB(55, 85, 110),
	serverhop = Color3.fromRGB(110, 80, 45),
	firstp = Color3.fromRGB(60, 60, 70),
	thirdp = Color3.fromRGB(60, 60, 70)
}

local btnTextColors = {
	fly = Color3.fromRGB(180, 200, 255),
	fling = Color3.fromRGB(255, 180, 180),
	aimbot = Color3.fromRGB(255, 200, 160),
	crosshair = Color3.fromRGB(180, 255, 180),
	sit = Color3.fromRGB(200, 180, 255),
	noclip = Color3.fromRGB(255, 240, 180),
	rejoin = Color3.fromRGB(180, 210, 255),
	serverhop = Color3.fromRGB(255, 210, 160),
	firstp = Color3.fromRGB(200, 200, 210),
	thirdp = Color3.fromRGB(200, 200, 210)
}

local bH = math.floor(38 * scale)
local bP = math.floor(6 * scale)
el.Size = UDim2.new(1, math.floor(-16 * scale), 0, math.floor(32 * scale) + (5 * bH) + (6 * bP))

local grid = Instance.new("UIGridLayout", el)
grid.CellSize = UDim2.new(0.48, 0, 0, bH)
grid.CellPadding = UDim2.new(0, bP, 0, bP)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.FillDirection = Enum.FillDirection.Horizontal
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper to make a quick button (no new locals per button)
local function qBtn(parent, name, label, colorKey, callback)
	local b = Instance.new("TextButton", parent)
	b.Name = name
	b.BackgroundColor3 = btnColors[colorKey]
	b.Text = label
	b.Font = Enum.Font.Code
	b.TextSize = math.floor(11 * fontScale)
	b.TextColor3 = btnTextColors[colorKey]
	b.BorderSizePixel = 0
	b.ZIndex = 2147483647
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	b.MouseButton1Click:Connect(callback)
	return b
end

qBtn(el, "FlyBtn", "Fly", "fly", function()
	if fly then fly(client, nil) end
end)

qBtn(el, "FlingBtn", "Fling", "fling", function()
	if TouchFling and TouchFling.CreateGUI then
		TouchFling:CreateGUI()
		StarterGui:SetCore("SendNotification", {Title = "Touch Fling", Text = "GUI Opened", Duration = 3})
	end
end)

qBtn(el, "AimbotBtn", "Aimbot", "aimbot", function()
	if createAimbotPanel then createAimbotPanel() end
end)

qBtn(el, "CrosshairBtn", "Crosshair", "crosshair", function()
	if LoadLunarCrosshair then LoadLunarCrosshair() end
end)

qBtn(el, "SitBtn", "Sit", "sit", function()
	if sit then sit(client) end
end)

-- Noclip toggle (needs state tracking)
local ncBtn = qBtn(el, "NoclipBtn", "Noclip: OFF", "noclip", function() end)
local ncOn = false
ncBtn.MouseButton1Click:Connect(function()
	ncOn = not ncOn
	if ncOn then
		ncBtn.Text = "Noclip: ON"
		ncBtn.BackgroundColor3 = Color3.fromRGB(55, 90, 55)
		if noclip then noclip(client) end
	else
		ncBtn.Text = "Noclip: OFF"
		ncBtn.BackgroundColor3 = btnColors.noclip
		if unnoclip then unnoclip(client) end
	end
end)

qBtn(el, "RejoinBtn", "Rejoin", "rejoin", function()
	if rejoin then rejoin(LocalPlayer, {}) end
end)

qBtn(el, "ServerhopBtn", "Serverhop", "serverhop", function()
	if serverhop then serverhop(client, {}) end
end)

qBtn(el, "FirstPBtn", "First Person", "firstp", function()
	if firstp then firstp() end
end)

qBtn(el, "ThirdPBtn", "Third Person", "thirdp", function()
	if thirdp then thirdp() end
end)

-- Universal Tab Button
uniTab = Instance.new("TextButton", tabBar)
uniTab.Name = "UniTab"
uniTab.Size = UDim2.new(0.333, -5, 1, 0)
uniTab.Position = UDim2.new(0.667, 5, 0, 0)
uniTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
uniTab.Text = "Universal"
uniTab.Font = Enum.Font.Code
uniTab.TextSize = math.floor(16 * fontScale)
uniTab.TextColor3 = globalConfig.textColor
uniTab.BorderSizePixel = 0
uniTab.ZIndex = 2147483647
Instance.new("UICorner", uniTab).CornerRadius = UDim.new(0, 6)

-- Tab switching
cmdTab.MouseButton1Click:Connect(function()
	cmdFrame.Visible = true
	setFrame.Visible = false
	uniFrame.Visible = false
	cmdTab.BackgroundColor3 = currentTheme.accent
	cmdTab.TextColor3 = Color3.new(0,0,0)
	setTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	setTab.TextColor3 = globalConfig.textColor
	uniTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	uniTab.TextColor3 = globalConfig.textColor
end)

setTab.MouseButton1Click:Connect(function()
	cmdFrame.Visible = false
	setFrame.Visible = true
	uniFrame.Visible = false
	setTab.BackgroundColor3 = currentTheme.accent
	setTab.TextColor3 = Color3.new(0,0,0)
	cmdTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	cmdTab.TextColor3 = globalConfig.textColor
	uniTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	uniTab.TextColor3 = globalConfig.textColor
end)

uniTab.MouseButton1Click:Connect(function()
	cmdFrame.Visible = false
	setFrame.Visible = false
	uniFrame.Visible = true
	uniTab.BackgroundColor3 = currentTheme.accent
	uniTab.TextColor3 = Color3.new(0,0,0)
	cmdTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	cmdTab.TextColor3 = globalConfig.textColor
	setTab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	setTab.TextColor3 = globalConfig.textColor
end)

-- =============================================================
-- STARTUP
-- =============================================================
lunarGui.Enabled = true
playOpen()
notify("Lunar Admin loaded • Enjoy :3", Color3.fromRGB(120,220,255))

setupButtonSounds()

task.spawn(function()
	task.wait(0.8)
	local wm = Instance.new("ScreenGui")
	wm.ResetOnSpawn = false
	wm.DisplayOrder = 999999
	wm.Parent = client.PlayerGui
	local label = Instance.new("TextLabel", wm)
	label.Size = UDim2.new(0, 320, 0, 40)
	label.Position = UDim2.new(0.5, -160, 0.94, 0)
	label.BackgroundTransparency = 1
	label.Text = "Created By @lun4_y • lunar_rbx discord"
	label.Font = Enum.Font.Code
	label.TextSize = 24
	label.TextColor3 = globalConfig.textColor
	label.TextTransparency = 0
	label.TextStrokeTransparency = 0.5
	label.TextStrokeColor3 = Color3.new(0,0,0)
	TweenService:Create(label, TweenInfo.new(1.8, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	task.wait(5.5)
	TweenService:Create(label, TweenInfo.new(1.6), {TextTransparency = 1}):Play()
	task.delay(2, function() wm:Destroy() end)
end)

-- Keybind handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		if lunarGui then
			lunarGui.Enabled = not lunarGui.Enabled
			if lunarGui.Enabled then
				playOpen()
			else
				playClose()
			end
		end
	end
end)
--- =============================================================
-- overhead UI REMOVED CHECK DC FOR IT AGAIN
-- =============================================================
------------------------------------------------------------------------------
----------------- END OF IT LOL ----------------------------------------------
------------------------------------------------------------------------------

-- Chat handler
client.Chatted:Connect(processCmd)

-- lol 4/19/26
