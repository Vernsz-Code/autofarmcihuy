-- LocalScript / AutoExecute Executor
-- Evade Auto Farm & Auto Chat Hub (UI CihuyKimak Edition - Fast & Responsive Multi-Safezone)

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Guard Clause: Mencegah duplikasi UI saat respawn
if PlayerGui:FindFirstChild("CihuyKimak") then
	return
end

--[[
	==> SERVICES & SERVICES SETUP
]]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local CAS = game:GetService("ContextActionService")

local player = Players.LocalPlayer

--[[
	==> CONFIG & VARIABLES
]]
local DANGER_RADIUS = 35          -- Jarak Nextbot ke Player yang dianggap berbahaya (Responsif)
local TICKET_SAFE_RADIUS = 40     -- Jarak Nextbot ke Tiket agar tiket aman diambil
local TP_INTERVAL = 0.5           -- Cooldown perpindahan antar tiket saat kondisi aman (detik)
local SAFE_TOLERANCE = 25         -- Toleransi area Safe Zone (Radius Horizontal)

-- 4 Koordinat Safe Zone
local SAFE_POSITIONS = {
	Vector3.new(-400, 550, -200),
	Vector3.new(300, 500, -200),
	Vector3.new(100, 500, 300),
	Vector3.new(-500, 500, 300)
}

local activeSafeZone = SAFE_POSITIONS[1]

local isEnabled = false           -- Toggle Auto Farm
local isAutoChatEnabled = false   -- Toggle Auto Chat

local character, hrp
local lastTPTime = 0
local heartbeat = nil
local bodyVelocity = nil

local triggerCount = 0
local chatCooldown = false
local watching = false

--[[
	==> HELPER FUNCTIONS FOR SAFEZONE
]]
local function switchSafeZone()
	local newZone = SAFE_POSITIONS[math.random(1, #SAFE_POSITIONS)]
	if #SAFE_POSITIONS > 1 then
		while newZone == activeSafeZone do
			newZone = SAFE_POSITIONS[math.random(1, #SAFE_POSITIONS)]
		end
	end
	activeSafeZone = newZone
	return activeSafeZone
end

--[[
	==> UI STYLES
]]
local UnActiveButtonToggle = {
	TextColor3 = Color3.fromRGB(25, 25, 25),
	BackgroundColor3 = Color3.fromRGB(77, 77, 77)
}
local ActiveButtonToggle = {
	TextColor3 = Color3.fromRGB(25, 25, 25),
	BackgroundColor3 = Color3.fromRGB(200, 200, 200)
}

--[[
	==> UI MAKER
]]
local CihuyKimak = Instance.new("ScreenGui")
local MainContainer = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Main = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding_3 = Instance.new("UIPadding")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
local Menu = Instance.new("ScrollingFrame")
local UIPadding_4 = Instance.new("UIPadding")
local UIListLayout_2 = Instance.new("UIListLayout")
local UIAspectRatioConstraint_6 = Instance.new("UIAspectRatioConstraint")
local Frame = Instance.new("Frame")
local UIAspectRatioConstraint_7 = Instance.new("UIAspectRatioConstraint")
local Top = Instance.new("Frame")
local CloseBtn = Instance.new("ImageButton")
local UICorner_6 = Instance.new("UICorner")
local UIAspectRatioConstraint_8 = Instance.new("UIAspectRatioConstraint")
local LabelHUB = Instance.new("TextLabel")
local UIPadding_5 = Instance.new("UIPadding")
local UIAspectRatioConstraint_9 = Instance.new("UIAspectRatioConstraint")
local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
local UIAspectRatioConstraint_10 = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_11 = Instance.new("UIAspectRatioConstraint")

-- Properties:
CihuyKimak.Name = "CihuyKimak"
CihuyKimak.Parent = PlayerGui
CihuyKimak.ResetOnSpawn = false
CihuyKimak.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainContainer.Name = "MainContainer"
MainContainer.Parent = CihuyKimak
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
MainContainer.BackgroundTransparency = 0.200
MainContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainContainer.BorderSizePixel = 0
MainContainer.Position = UDim2.new(0.5, 0, 0.499054819, 0)
MainContainer.Size = UDim2.new(0.575263679, 0, 0.567107737, 0)

UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = MainContainer

Main.Name = "Main"
Main.Parent = MainContainer
Main.Active = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Main.BackgroundTransparency = 0.450
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.668020844, 0, 0.574999988, 0)
Main.Size = UDim2.new(0.661666691, 0, 0.850000024, 0)
Main.ScrollBarThickness = 8

UIListLayout.Parent = Main
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

UIPadding_3.Parent = Main
UIPadding_3.PaddingLeft = UDim.new(0, 8)
UIPadding_3.PaddingTop = UDim.new(0, 8)

UIAspectRatioConstraint_4.Parent = Main
UIAspectRatioConstraint_4.AspectRatio = 1.557

Menu.Name = "Menu"
Menu.Parent = MainContainer
Menu.Active = true
Menu.AnchorPoint = Vector2.new(0.5, 0.5)
Menu.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
Menu.BackgroundTransparency = 1.000
Menu.BorderColor3 = Color3.fromRGB(0, 0, 0)
Menu.BorderSizePixel = 0
Menu.Position = UDim2.new(0.168125004, 0, 0.574999988, 0)
Menu.Size = UDim2.new(0.336666673, 0, 0.850000024, 0)
Menu.CanvasSize = UDim2.new(0, 0, 1, 0)
Menu.ScrollBarThickness = 8

UIPadding_4.Parent = Menu
UIPadding_4.PaddingBottom = UDim.new(0, 5)
UIPadding_4.PaddingLeft = UDim.new(0, 5)
UIPadding_4.PaddingRight = UDim.new(0, 10)
UIPadding_4.PaddingTop = UDim.new(0, 5)

UIListLayout_2.Parent = Menu
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

UIAspectRatioConstraint_6.Parent = Menu
UIAspectRatioConstraint_6.AspectRatio = 0.792

Frame.Parent = MainContainer
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(218, 218, 218)
Frame.BackgroundTransparency = 0.450
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.144999996, 0)
Frame.Size = UDim2.new(1, 0, 0.00666666683, 0)

UIAspectRatioConstraint_7.Parent = Frame
UIAspectRatioConstraint_7.AspectRatio = 300.000

Top.Name = "Top"
Top.Parent = MainContainer
Top.AnchorPoint = Vector2.new(0.5, 0.5)
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BackgroundTransparency = 1.000
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0.5, 0, 0.0700000003, 0)
Top.Size = UDim2.new(1, 0, 0.140000001, 0)

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = Top
CloseBtn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
CloseBtn.BackgroundTransparency = 0.450
CloseBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(0.964999974, 0, 0.5, 0)
CloseBtn.Size = UDim2.new(0.0549999997, 0, 0.800000072, 0)
CloseBtn.Image = "rbxassetid://132261474823036"

UICorner_6.CornerRadius = UDim.new(0, 3)
UICorner_6.Parent = CloseBtn

UIAspectRatioConstraint_8.Parent = CloseBtn
UIAspectRatioConstraint_8.AspectRatio = 0.982

LabelHUB.Name = "LabelHUB"
LabelHUB.Parent = Top
LabelHUB.AnchorPoint = Vector2.new(0.5, 0.5)
LabelHUB.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
LabelHUB.BackgroundTransparency = 1.000
LabelHUB.BorderColor3 = Color3.fromRGB(0, 0, 0)
LabelHUB.BorderSizePixel = 0
LabelHUB.Position = UDim2.new(0.300000012, 0, 0.5, 0)
LabelHUB.Size = UDim2.new(0.600000024, 0, 1, 0)
LabelHUB.Font = Enum.Font.Unknown
LabelHUB.Text = "vernsz Hub.lua | Evade"
LabelHUB.TextColor3 = Color3.fromRGB(255, 255, 255)
LabelHUB.TextScaled = true
LabelHUB.TextSize = 14.000
LabelHUB.TextWrapped = true
LabelHUB.TextXAlignment = Enum.TextXAlignment.Left

UIPadding_5.Parent = LabelHUB
UIPadding_5.PaddingLeft = UDim.new(0, 10)

UIAspectRatioConstraint_9.Parent = LabelHUB
UIAspectRatioConstraint_9.AspectRatio = 8.571

UITextSizeConstraint_4.Parent = LabelHUB
UITextSizeConstraint_4.MaxTextSize = 14

UIAspectRatioConstraint_10.Parent = Top
UIAspectRatioConstraint_10.AspectRatio = 14.286

UIAspectRatioConstraint_11.Parent = MainContainer
UIAspectRatioConstraint_11.AspectRatio = 2.000

--[[
	==> TEMPLATE UI METHODS
]]
local UI = {}

function UI:AddMenuButton(btnText, callback)
	local TemplateButtonMenu = Instance.new("TextButton")
	local UICorner_5 = Instance.new("UICorner")
	local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")
	local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

	TemplateButtonMenu.Name = "TemplateButtonMenu"
	TemplateButtonMenu.Parent = Menu
	TemplateButtonMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	TemplateButtonMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TemplateButtonMenu.BorderSizePixel = 0
	TemplateButtonMenu.Size = UDim2.new(1, 0, 0, 40)
	TemplateButtonMenu.Font = Enum.Font.Arcade
	TemplateButtonMenu.Text = btnText or "Menu"
	TemplateButtonMenu.TextColor3 = Color3.fromRGB(239, 239, 239)
	TemplateButtonMenu.TextScaled = true
	TemplateButtonMenu.TextSize = 18.000
	TemplateButtonMenu.TextWrapped = true

	UICorner_5.CornerRadius = UDim.new(0, 3)
	UICorner_5.Parent = TemplateButtonMenu

	UIAspectRatioConstraint_5.Parent = TemplateButtonMenu
	UIAspectRatioConstraint_5.AspectRatio = 4.675

	UITextSizeConstraint_3.Parent = TemplateButtonMenu
	UITextSizeConstraint_3.MaxTextSize = 18

	if callback then
		TemplateButtonMenu.MouseButton1Click:Connect(callback)
	end

	return TemplateButtonMenu
end

function UI:AddToggle(labelText, defaultState, callback)
	local toggled = defaultState or false

	local TemplateToggleButton = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIPadding = Instance.new("UIPadding")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
	local UICorner_3 = Instance.new("UICorner")
	local UIPadding_2 = Instance.new("UIPadding")
	local TextButton = Instance.new("TextButton")
	local UICorner_4 = Instance.new("UICorner")
	local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
	local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
	local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")

	TemplateToggleButton.Name = "TemplateToggleButton"
	TemplateToggleButton.Parent = Main
	TemplateToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TemplateToggleButton.BackgroundTransparency = 0.800
	TemplateToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TemplateToggleButton.BorderSizePixel = 0
	TemplateToggleButton.Position = UDim2.new(-0.0160857905, 0, 0, 0)
	TemplateToggleButton.Size = UDim2.new(1, 0, 0, 40)

	TextLabel.Parent = TemplateToggleButton
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.268096507, 0, 0.5, 0)
	TextLabel.Size = UDim2.new(0.514138818, 0, 1, 0)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.Text = labelText or "Toggle Title"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 20.000
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = TextLabel

	UIPadding.Parent = TextLabel
	UIPadding.PaddingLeft = UDim.new(0, 10)
	UIPadding.PaddingRight = UDim.new(0, 10)

	UIAspectRatioConstraint.Parent = TextLabel
	UIAspectRatioConstraint.AspectRatio = 5.000

	UITextSizeConstraint.Parent = TextLabel
	UITextSizeConstraint.MaxTextSize = 20

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = TemplateToggleButton

	UIPadding_2.Parent = TemplateToggleButton
	UIPadding_2.PaddingLeft = UDim.new(0, 10)

	TextButton.Parent = TemplateToggleButton
	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BorderSizePixel = 0
	TextButton.Position = UDim2.new(0.817981541, 0, 0.5, 0)
	TextButton.Size = UDim2.new(0.257069409, 0, 0.699999988, 0)
	TextButton.Font = Enum.Font.SourceSansBold
	TextButton.TextScaled = true
	TextButton.TextSize = 14.000
	TextButton.TextWrapped = true

	UICorner_4.CornerRadius = UDim.new(0, 3)
	UICorner_4.Parent = TextButton

	UIAspectRatioConstraint_2.Parent = TextButton
	UIAspectRatioConstraint_2.AspectRatio = 3.571

	UITextSizeConstraint_2.Parent = TextButton
	UITextSizeConstraint_2.MaxTextSize = 14

	UIAspectRatioConstraint_3.Parent = TemplateToggleButton
	UIAspectRatioConstraint_3.AspectRatio = 9.725

	local function UpdateVisual()
		if toggled then
			TextButton.Text = "ON"
			TextButton.BackgroundColor3 = ActiveButtonToggle.BackgroundColor3
			TextButton.TextColor3 = ActiveButtonToggle.TextColor3
		else
			TextButton.Text = "OFF"
			TextButton.BackgroundColor3 = UnActiveButtonToggle.BackgroundColor3
			TextButton.TextColor3 = UnActiveButtonToggle.TextColor3
		end
	end

	UpdateVisual()

	TextButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		UpdateVisual()
		if callback then
			task.spawn(callback, toggled)
		end
	end)

	return TemplateToggleButton
end

--[[
	==> DRAGGABLE & VISIBILITY
]]
local dragging, dragInput, dragStart, startPos
MainContainer.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = MainContainer.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
MainContainer.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	CihuyKimak.Enabled = false
end)

local function ToggleVisibility(actionName, inputState)
	if actionName == "KForOpen" and inputState == Enum.UserInputState.Begin then
		CihuyKimak.Enabled = not CihuyKimak.Enabled
	end
end

CAS:BindAction("KForOpen", ToggleVisibility, true, Enum.KeyCode.V)

--[[
	==> CORE LOGIC (AUTO COMMAND & AUTO FARM)
]]

-- 1. Auto Command Logic
local function forceCommand(message)
	local success, textBox = pcall(function()
		return player.PlayerGui.Chat.Chat.ChatContainer.Chat.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
	end)

	if success and textBox then
		print("[AUTO CHAT] Command: " .. message)
		textBox:CaptureFocus()
		task.wait(0.1)
		textBox.Text = message
		task.wait(0.3)
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		textBox:ReleaseFocus()
	else
		warn("❌ [AUTO CHAT ERROR] Chat TextBox tidak ditemukan!")
	end
end

local function onRoundVisibleChanged(roundTimer)
	if not isAutoChatEnabled or not roundTimer then return end
	
	if roundTimer.Visible and not chatCooldown then
		chatCooldown = true
		triggerCount += 1

		task.wait(3)
		forceCommand("!specialround Plushie Hell")
		
		task.wait(2.5)
		forceCommand("!time 1")

		if triggerCount >= 3 then
			task.wait(2.5)
			forceCommand("!map Abstract")
			triggerCount = 0
		end

		task.wait(2)
		while roundTimer and roundTimer.Parent and roundTimer.Visible do 
			task.wait(1) 
		end
		
		task.wait(1)
		chatCooldown = false
	end
end

local function setupWatcher(sharedGui)
	if watching then return end
	watching = true
	task.spawn(function()
		while sharedGui and sharedGui.Parent do
			local success, roundTimer = pcall(function()
				return sharedGui:WaitForChild("HUD"):WaitForChild("Overlay"):WaitForChild("RoundOverlay"):WaitForChild("RoundTimer"):WaitForChild("RoundTimer")
			end)
			
			if success and roundTimer then
				roundTimer:GetPropertyChangedSignal("Visible"):Connect(function()
					if roundTimer.Visible then onRoundVisibleChanged(roundTimer) end
				end)
				
				task.spawn(function()
					while watching and roundTimer and roundTimer.Parent do
						if roundTimer.Visible and not chatCooldown then
							onRoundVisibleChanged(roundTimer)
						end
						task.wait(0.5)
					end
				end)
				
				if roundTimer.Visible then onRoundVisibleChanged(roundTimer) end
				break
			end
			task.wait(1)
		end
	end)
end

if PlayerGui:FindFirstChild("Game") then setupWatcher(PlayerGui.Game) end
PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "Game" then
		watching = false
		setupWatcher(child)
	end
end)

-- 2. Auto TP / Farm Logic (Ultra-Responsive & Multi-Safezone)
local function setFloat(state)
	if state and hrp then
		if not bodyVelocity or not bodyVelocity.Parent or bodyVelocity.Parent ~= hrp then
			if hrp:FindFirstChild("BodyVelocity") then hrp:FindFirstChild("BodyVelocity"):Destroy() end
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
			bodyVelocity.Parent = hrp
		end
	else
		if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
		if hrp and hrp:FindFirstChild("BodyVelocity") then hrp:FindFirstChild("BodyVelocity"):Destroy() end
	end
end

local function getActiveTicketsFolder()
	local effects = Workspace:FindFirstChild("Effects")
	return effects and effects:FindFirstChild("Tickets")
end

local function getTargetPart(obj)
	if not obj then return nil end
	if obj:IsA("BasePart") then return obj end
	return obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChild("Handle")
end

local function tpTo(pos, reason)
	if not hrp then return end
	hrp.CFrame = CFrame.new(pos)
end

local function getDistanceToClosestNextbot(targetPosition)
	local minDistance = math.huge
	local searchFolders = {
		Workspace:FindFirstChild("Players"),
		Workspace
	}

	for _, folder in ipairs(searchFolders) do
		if folder then
			for _, model in ipairs(folder:GetChildren()) do
				if model:IsA("Model") and model:GetAttribute("AI") ~= nil then
					local hitbox = model:FindFirstChild("Hitbox") 
						or model.PrimaryPart 
						or model:FindFirstChildWhichIsA("BasePart")
					
					if hitbox then
						local dist = (hitbox.Position - targetPosition).Magnitude
						if dist < minDistance then
							minDistance = dist
						end
					end
				end
			end
		end
	end

	return minDistance
end

local function startFarm()
	if heartbeat then return end
	setFloat(true)
	activeSafeZone = SAFE_POSITIONS[1]

	heartbeat = RunService.Heartbeat:Connect(function()
		if not isEnabled or not character or not hrp then return end
		setFloat(true)

		local now = tick()
		local playerPos = hrp.Position

		local ticketsFolder = getActiveTicketsFolder()
		local allTickets = ticketsFolder and ticketsFolder:GetChildren() or {}

		local distNextbotToPlayer = getDistanceToClosestNextbot(playerPos)
		local isNextbotNearPlayer = distNextbotToPlayer <= DANGER_RADIUS

		-- Cari tiket terdekat yang AMAN dari Nextbot
		local safeTicketPart = nil
		for _, ticket in ipairs(allTickets) do
			local ticketPart = getTargetPart(ticket)
			if ticketPart then
				local distNextbotToTicket = getDistanceToClosestNextbot(ticketPart.Position)
				if distNextbotToTicket > TICKET_SAFE_RADIUS then
					safeTicketPart = ticketPart
					break
				end
			end
		end

		-- LOGIKA UTAMA (RESPON INSTAN + SAFEZONE DYNAMIC)
		if isNextbotNearPlayer then
			-- ADA BAHAYA! Bypassing TP_INTERVAL agar langsung merespon tanpa delay
			if safeTicketPart then
				-- Jika Nextbot mendekat tapi ada tiket yang aman -> Langsung kabur ke Tiket
				tpTo(safeTicketPart.Position + Vector3.new(0, 0.5, 0), "Bahaya! Evakuasi ke Tiket Aman")
				lastTPTime = now
			else
				-- Jika Nextbot mendekat & TIDAK ada tiket aman -> Pindah Safezone + Naik +150Y di udara
				switchSafeZone()
				local targetEvac = activeSafeZone + Vector3.new(0, 150, 0)
				tpTo(targetEvac, "Bahaya! Evakuasi Safe Zone +150Y")
				lastTPTime = now
			end
		else
			-- KONDISI AMAN (Nextbot jauh dari player)
			if safeTicketPart then
				-- Jika aman dan ada tiket -> Panen tiket secara bergantian sesuai TP_INTERVAL
				if now - lastTPTime >= TP_INTERVAL then
					tpTo(safeTicketPart.Position + Vector3.new(0, 0.5, 0), "Panen Tiket")
					lastTPTime = now
				end
			else
				-- Jika tidak ada tiket dan kondisi aman -> Turun/Standby ke Safezone
				local distToSafe = (playerPos - activeSafeZone).Magnitude
				if distToSafe > 10 or math.abs(playerPos.Y - activeSafeZone.Y) > 10 then
					if now - lastTPTime >= TP_INTERVAL then
						tpTo(activeSafeZone, "Standby Safe Zone Ground")
						lastTPTime = now
					end
				end
			end
		end

		-- Menstabilkan karakter agar melayang tanpa gravitasi saat melayang
		if hrp and hrp:FindFirstChild("BodyVelocity") then
			hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
		end
	end)
end

local function stopFarm()
	if heartbeat then heartbeat:Disconnect(); heartbeat = nil end
	setFloat(false)
	lastTPTime = 0
end

--[[
	==> UI MENU & TOGGLES SETUP
]]

-- Tab Navigation
UI:AddMenuButton("Main", function()
	print("Tab Main Active")
end)

-- 2 Tombol Toggle Utama
UI:AddToggle("Auto Farm", false, function(state)
	isEnabled = state
	if isEnabled then
		startFarm()
	else
		stopFarm()
	end
end)

UI:AddToggle("Auto Chat", false, function(state)
	isAutoChatEnabled = state
end)

--[[
	==> CHARACTER & ANTI-AFK HANDLERS
]]
local function onCharAdded(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart", 5)
	lastTPTime = 0
	if isEnabled then 
		task.wait(0.5)
		setFloat(true)
	end
end

player.CharacterAdded:Connect(onCharAdded)
if player.Character then onCharAdded(player.Character) end

player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("✅ vernsz Hub (UI CihuyKimak) loaded successfully! Press 'V' to toggle UI.")
