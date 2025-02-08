--[[
    This script is not intended to be modified.

    Interface Owner: _lugia.
    Bundling Tool: Latte Softworks & Kotera

    .gg/w-azure
--]]

-- // Completely isolate this one with the rest of the script :chonlay:
task.spawn(function()
    getgenv().is_stop = false
    getgenv().send_frequency = getgenv().send_frequency or 10

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")

    local function isGameActive()
        return pcall(function()
            return LocalPlayer and CoreGui:FindFirstChild("RobloxPromptGui")
        end)
    end

    CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(v)
        if v.Name == "ErrorPrompt" and v:FindFirstChild("MessageArea") and v.MessageArea:FindFirstChild("ErrorFrame") then
            getgenv().is_stop = true
            print("[ Rokid Manager ] - Error Prompt Detected")
        end
    end)

    while not getgenv().is_stop do
        if not Players.LocalPlayer or not Players.LocalPlayer:FindFirstChild("PlayerScripts") or not isGameActive() then
            print("[ Rokid Manager ] - Game is no longer active, stopping data transmission.")
            game:Shutdown()
            break
        end

        local userId = tostring(LocalPlayer.UserId)
        print("[ Rokid Manager ] - Sending data to API for user ID:", userId)

        local success, response = pcall(function()
            return request({
                Url = "http://localhost:5000/api/loaded",
                Method = "POST",
                Headers = { ["content-type"] = "application/json" },
                Body = HttpService:JSONEncode({ id = userId })
            })
        end)

        print(success and "[ Rokid Manager ] - Data sent successfully:" or "[ Rokid Manager ] - Failed to send data:", response)
        
        pcall(function()
            writefile(userId .. ".main", tostring(os.time()))
        end)

        task.wait(tonumber(getgenv().send_frequency) or 10)
    end
end)

local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function(...) return ... end
setidentity(8)
-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        "ModuleScript",
        {
            "MainModule"
        },
        {
            {
                2,
                "ModuleScript",
                {
                    "Creator"
                }
            }
        }
    }
}

-- Holds direct closure data
local ClosureBindings = {
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(1)repeat task.wait(0.5) until game:IsLoaded()

local getgenv = getgenv or function()
	return shared
end

local function formatTimeElapsed(startTime)
	local elapsed = os.time() - startTime -- Time elapsed in seconds

	local hours = math.floor(elapsed / 3600)
	local minutes = math.floor((elapsed % 3600) / 60)
	local seconds = elapsed % 60

	return string.format("%02d%s, %02dmins, %02dsec", hours, hours > 1 and "hs" or "h", minutes, seconds)
end

local function censorUsername(username)
	local length = #username -- Get username length
	if length <= 6 then
		return string.rep("*", length) -- Fully censor short usernames
	end

	local firstPart = string.sub(username, 1, 1) -- First character
	local lastPart = string.sub(username, -3)   -- Last 3 characters
	local censoredPart = string.rep("*", length - 4) -- Fill with *

	return firstPart .. censoredPart .. lastPart
end

local TweenService = game:GetService("TweenService")

local function tweenGroupTransparency(target, transparency, duration)
	if not target then return end

	-- Create TweenInfo (linear, no repeat, no delay)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	-- Create Tween for GroupTransparency
	local tween = TweenService:Create(target, tweenInfo, {GroupTransparency = transparency})
	tween:Play()

	-- Find the first UIStroke inside the target and tween its Transparency
	local stroke = target:FindFirstChildOfClass("UIStroke")
	if stroke then
		local strokeTween = TweenService:Create(stroke, tweenInfo, {Transparency = transparency})
		strokeTween:Play()
	end
end

local Creator = require(script.Creator)

local New = Creator.New

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local LPName = LocalPlayer.Name

local lastTime = tick()
local lastDisplayed, lastDisplayed2 = tick(), tick()
local fps = 0

RunService.RenderStepped:Connect(function()
	local currentTime = tick()
	fps = math.floor(1 / (currentTime - lastTime)) -- Calculate FPS
	lastTime = currentTime
end)

local GUI = New("ScreenGui", {
	Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 9e5,
	ScreenInsets = Enum.ScreenInsets.None
})

local Library = {}

function Library:CreateScreen(Config) 
	local Screen = {}
	
	local startTime = os.time()
	local censoredUsername = censorUsername(LPName)
	
	local Show = true
	local OnCooldown = false
	local MinThreshold = 0.25
	local function ToggleUI()
		Show = not Show
		OnCooldown = true
		tweenGroupTransparency(Screen.Frame, Show and 0 or 1, 0.25)

		task.delay(MinThreshold, function()
			OnCooldown = false
		end)
	end
	
	Screen.Watermark = New("CanvasGroup", {
		Parent = GUI,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(11, 11, 15),
		BackgroundTransparency = 0.5,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0, 6),
		Size = UDim2.fromScale(0.094, 0.125),
		ZIndex = 10,
		OnClick = function()
			if OnCooldown then
				return
			end
			
			ToggleUI()
		end,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0.01, 5),
		}),

		New("UIStroke", {
			Color = Color3.fromRGB(84, 84, 87),
			Transparency = 0.6,
		}),

		New("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=127037580711111",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.8, 0.8),
		}),

		New("UIAspectRatioConstraint"),
	})
	
	Screen.Frame = New("CanvasGroup", {
		Parent = GUI,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.3,
		GroupTransparency = 1,
	}, {
		New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.36),
		}, {
			New("TextLabel", {
				FontFace = Font.new(
					"rbxasset://fonts/families/FredokaOne.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "Rokid Manager",
				TextColor3 = Color3.fromRGB(235, 111, 146),
				TextSize = 62,
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, 68),
			}, {
				New("UIStroke", {
					Thickness = 3,
				}),
			}),

			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(336, 24),
			}, {
				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = "time elapsed:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Right,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.56),
					Size = UDim2.fromOffset(100, 22),
				}),

				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					ItemLineAlignment = Enum.ItemLineAlignment.Center
				}),

				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = "0 hs, 30 mins, 0 sec",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.553, 0.458),
					Size = UDim2.fromOffset(230, 22),
					OnHeartbeat = function(Object)
						local timeElapsed = formatTimeElapsed(startTime)
						Object.Text = timeElapsed
						
						task.wait(1)
					end,
				}),
			}),

			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(336, 24),
			}, {
				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = "logged in as:",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Right,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.56),
					Size = UDim2.fromOffset(100, 22),
				}),

				New("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					ItemLineAlignment = Enum.ItemLineAlignment.Center
				}),

				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = censoredUsername,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.553, 0.458),
					Size = UDim2.fromOffset(230, 22),
				}),
			}),
		}),

		New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0.36, 150),
			Size = UDim2.new(0, 0, 0, 92),
		}, {
			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(11, 11, 15),
				BackgroundTransparency = 0.5,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(0.45, 1),
			}, {
				New("UIStroke", {
					Color = Color3.fromRGB(84, 84, 87),
					Transparency = 0.6,
				}),

				New("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),

				New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(12, 12),
					Size = UDim2.fromScale(1, 0),
				}, {
					New("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=127299419935629",
						ImageTransparency = 0.4,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.fromOffset(26, 26),
					}),

					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
					}),

					New("TextLabel", {
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						RichText = true,
						Text = "FPS",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 22,
						TextTransparency = 0.4,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AnchorPoint = Vector2.new(0.5, 0.5),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.553, 0.458),
						Size = UDim2.fromOffset(0, 22),
					}),
				}),

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 8),
				}),

				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
				}),

				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = fps,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 38,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.553, 0.458),
					Size = UDim2.fromOffset(0, 22),
					OnHeartbeat = function(Object)
						if tick() - lastDisplayed <= 0.5 then
							return
						end
						
						Object.Text = fps
						lastDisplayed = tick()
					end,
				}),
			}),

			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			New("Frame", {
				BackgroundColor3 = Color3.fromRGB(11, 11, 15),
				BackgroundTransparency = 0.5,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(0.45, 1),
			}, {
				New("UIStroke", {
					Color = Color3.fromRGB(84, 84, 87),
					Transparency = 0.6,
				}),

				New("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),

				New("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(12, 12),
					Size = UDim2.fromScale(1, 0),
				}, {
					New("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=111670308548285",
						ImageTransparency = 0.4,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.fromOffset(18, 18),
					}),

					New("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
					}),

					New("TextLabel", {
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						RichText = true,
						Text = "Ping",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 22,
						TextTransparency = 0.4,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AnchorPoint = Vector2.new(0.5, 0.5),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.553, 0.458),
						Size = UDim2.fromOffset(0, 22),
					}),
				}),

				New("UIPadding", {
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12),
					PaddingTop = UDim.new(0, 10),
				}),

				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
				}),

				New("TextLabel", {
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					RichText = true,
					Text = "1",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 38,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.553, 0.458),
					Size = UDim2.fromOffset(0, 22),
					OnHeartbeat = function(Object)
						if tick() - lastDisplayed2 <= 0.5 or RunService:IsStudio() then
							return
						end 
						
						Object.Text = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
						lastDisplayed2 = tick()
					end,
				}),
			}),
		}),

		New("TextLabel", {
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "JobID: " .. tostring(RunService:IsStudio() and "STUDIO DETECTED" or game.JobId),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14,
			TextTransparency = 0.5,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 1, -2),
			Size = UDim2.new(1, 0, 0, 20),
		})
	})
	
	tweenGroupTransparency(Screen.Frame, 0, 0.25)
	
	return Screen	
end

Library:CreateScreen()

return Library end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(2)local RunService = game:GetService("RunService")
local Root = script.Parent

local Creator = {
	Registry = {},
	ImageRegistry = {},
	Signals = {},
	TransparencyMotors = {},
	HeartbeatSignals = {},
	LinearMotors = {},
	DefaultProperties = {
		UICorner = {
			CornerRadius = UDim.new(0, 6)
		},
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			--SizeConstraint = Enum.SizeConstraint.RelativeXX
		},
	},
}

local function ApplyCustomProps(Object, Props)
	return
end

local function CompareColor3(Color_1: Color3, Color_2: Color3) : boolean
	if typeof(Color_1) == "number" then
		return Color_1 == Color_2	
	end

	local R1, G1, B1 = Color_1.R, Color_1.G, Color_1.B
	local R2, G2, B2 = Color_2.R, Color_2.G, Color_2.B
	local R, G, B = math.abs(R1 * 255 - R2 * 255), math.abs(G1 * 255 - G2 * 255), math.abs(B1 * 255 - B2 * 255)

	return R <= 5 and B <= 5 and G <= 5
end

function Creator.AddSignal(Signal, Function)
	if typeof(Signal) == "table" then
		for _, signal in pairs(Signal) do
			table.insert(Creator.Signals, signal:Connect(Function))
		end
	else
		table.insert(Creator.Signals, Signal:Connect(Function))
	end
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)
		Connection:Disconnect()
	end
end

function Creator.UpdateTheme(Tag)
	for Instance, Object in next, Creator.Registry do
		-- Shit code modded for W-Azure
		if typeof(Instance) == "function" then
			local Color = Creator.GetThemeProperty(Object["Properties"]["Properties"])

			if typeof(Color) ~= "Color3" then
				if Color ~= Instance() then
					return Instance(Color)
				end
			end

			if typeof(Color) == "Color3" and not CompareColor3(Color, Instance()) then
				Instance(Color)	
			end			
		else
			for Property, ColorIdx in next, Object.Properties do
				if Tag and Property ~= Tag then else
					Instance[Property] = Creator.GetThemeProperty(ColorIdx)
				end
			end
		end
	end
end

function Creator.AddThemeObject(Object, Properties, NoUpdate)
	local Idx = #Creator.Registry + 1
	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Idx,
	}

	Creator.Registry[Object] = Data

	if NoUpdate then
		return Object
	end

	Creator.UpdateTheme()
	return Object
end

function Creator.AddImageObject(Object, Properties)
	local Idx = #Creator.Registry + 1
	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Idx,
	}

	Creator.ImageRegistry[Object] = Data
	Creator.UpdateTheme()
	return Object
end


function Creator.OverrideTag(Object, Properties)
	Creator.Registry[Object].Properties = Properties
	Creator.UpdateTheme()
end

local CustomEvents = { "OnClick", "OnHover", "OnLeave", "OnHeartbeat", "OnTextChange", "CreateLinearMotor" }
local CustomProps = { "ThemeTag", "ImageThemeTag" }
function Creator.New(Name, Properties, Children)
	Properties = Properties or {}
	Children = Children or {}

	local Object = Instance.new(Name)

	-- Default properties
	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	-- Properties
	for Name, Value in next, Properties or {} do
		-- Handle input-related properties
		if table.find(CustomEvents, Name) then
			local LinearMotor, Setter
			if typeof(Value) ~= "function" then
				warn(Name .. " must be a function")
				continue
			end

			local function Callback()
				return task.spawn(Value, Object)
			end

			if Name == "OnClick" then
				Creator.AddSignal(Object.InputBegan, function(input: InputObject, gameProcessedEvent)
					if gameProcessedEvent then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 
						or input.UserInputType == Enum.UserInputType.Touch then
						Callback()
					end
				end)
			elseif Name == "OnHover" then
				Creator.AddSignal(Object.MouseEnter, function()
					Callback()
				end)
			elseif Name == "OnLeave" then
				Creator.AddSignal(Object.MouseLeave, function()
					Callback()
				end)
			elseif Name == "OnHeartbeat" then
				table.insert(Creator.HeartbeatSignals, function()  Callback() end)
			elseif Name == "OnTextChange" then
				Creator.AddSignal(Object:GetPropertyChangedSignal("Text"), function()
					Callback()
				end)
			end

			continue
		end

		if not table.find(CustomProps, Name) then
			Object[Name] = Value
		end
	end

	-- Children
	for _, Child in next, Children or {} do
		Child.Parent = Object
	end

	ApplyCustomProps(Object, Properties)
	return Object
end

Creator.AddSignal(RunService.Heartbeat, function()
	for _, func in ipairs(Creator.HeartbeatSignals) do
		task.spawn(func)
	end
end)

return Creator
 end
} -- [RefId] = Closure

-- Set up from data
do
    -- Localizing certain libraries and built-ins for runtime efficiency
    local task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget= task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget

    local table_insert = table.insert
    local table_remove = table.remove

    -- lol
    local table_freeze = table.freeze or function(t) return t end

    -- If we're not running on Roblox or Lune runtime, we won't have a task library
    local Defer = task and task.defer or function(f, ...)
        local Thread = coroutine.create(f)
        coroutine.resume(Thread, ...)
        return Thread
    end

    -- `maui.Version` compat
    local Version = "0.0.0-venv"

    local RefBindings = {} -- [RefId] = RealObject

    local ScriptClosures = {}
    local StoredModuleValues = {}
    local ScriptsToRun = {}

    -- maui.Shared
    local SharedEnvironment = {}

    -- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
    -- It's meant to be as lazy as possible lol
    local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

    -- Implemented instance methods
    local InstanceMethods = {
        GetChildren = function(self)
            local Children = RefChildren[self]
            local ReturnArray = {}
    
            for Child in next, Children do
                table_insert(ReturnArray, Child)
            end
    
            return ReturnArray
        end,

        -- Not implementing `recursive` arg, as it isn't needed for us here
        FindFirstChild = function(self, name)
            if not name then
                error("Argument 1 missing or nil", 2)
            end

            for Child in next, RefChildren[self] do
                if Child.Name == name then
                    return Child
                end
            end

            return
        end,

        GetFullName = function(self)
            local Path = self.Name
            local ObjectPointer = self.Parent

            while ObjectPointer do
                Path = ObjectPointer.Name .. "." .. Path

                -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
                ObjectPointer = ObjectPointer.Parent
            end

            return "VirtualEnv." .. Path
        end,
    }

    -- "Proxies" to instance methods, with err checks etc
    local InstanceMethodProxies = {}
    for MethodName, Method in next, InstanceMethods do
        InstanceMethodProxies[MethodName] = function(self, ...)
            if not RefChildren[self] then
                error("Expected ':' not '.' calling member function " .. MethodName, 1)
            end

            return Method(self, ...)
        end
    end

    local function CreateRef(className, name, parent)
        -- `name` and `parent` can also be set later by the init script if they're absent

        -- Extras
        local StringValue_Value

        -- Will be set to RefChildren later aswell
        local Children = setmetatable({}, {__mode = "k"})

        -- Err funcs
        local function InvalidMember(member)
            error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 1)
        end

        local function ReadOnlyProperty(property)
            error("Unable to assign (virtual) property " .. property .. ". Property is read only", 1)
        end

        local Ref = newproxy(true)
        local RefMetatable = getmetatable(Ref)

        RefMetatable.__index = function(_, index)
            if index == "ClassName" then -- First check "properties"
                return className
            elseif index == "Name" then
                return name
            elseif index == "Parent" then
                return parent
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                return StringValue_Value
            else -- Lastly, check "methods"
                local InstanceMethod = InstanceMethodProxies[index]

                if InstanceMethod then
                    return InstanceMethod
                end
            end

            -- Next we'll look thru child refs
            for Child in next, Children do
                if Child.Name == index then
                    return Child
                end
            end

            -- At this point, no member was found; this is the same err format as Roblox
            InvalidMember(index)
        end

        RefMetatable.__newindex = function(_, index, value)
            -- __newindex is only for props fyi
            if index == "ClassName" then
                ReadOnlyProperty(index)
            elseif index == "Name" then
                name = value
            elseif index == "Parent" then
                -- We'll just ignore the process if it's trying to set itself
                if value == Ref then
                    return
                end

                if parent ~= nil then
                    -- Remove this ref from the CURRENT parent
                    RefChildren[parent][Ref] = nil
                end

                parent = value

                if value ~= nil then
                    -- And NOW we're setting the new parent
                    RefChildren[value][Ref] = true
                end
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                StringValue_Value = value
            else
                -- Same err as __index when no member is found
                InvalidMember(index)
            end
        end

        RefMetatable.__tostring = function()
            return name
        end

        RefChildren[Ref] = Children

        if parent ~= nil then
            RefChildren[parent][Ref] = true
        end

        return Ref
    end

    -- Create real ref DOM from object tree
    local function CreateRefFromObject(object, parent)
        local RefId = object[1]
        local ClassName = object[2]
        local Properties = object[3]
        local Children = object[4] -- Optional

        local Name = table_remove(Properties, 1)

        local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
        RefBindings[RefId] = Ref

        if Properties then
            for PropertyName, PropertyValue in next, Properties do
                Ref[PropertyName] = PropertyValue
            end
        end

        if Children then
            for _, ChildObject in next, Children do
                CreateRefFromObject(ChildObject, Ref)
            end
        end

        return Ref
    end

    local RealObjectRoot = {}
    for _, Object in next, ObjectTree do
        table_insert(RealObjectRoot, CreateRefFromObject(Object))
    end

    -- Now we'll set script closure refs and check if they should be ran as a BaseScript
    for RefId, Closure in next, ClosureBindings do
        local Ref = RefBindings[RefId]

        ScriptClosures[Ref] = Closure

        local ClassName = Ref.ClassName
        if ClassName == "LocalScript" or ClassName == "Script" then
            table_insert(ScriptsToRun, Ref)
        end
    end

    local function LoadScript(scriptRef)
        local ScriptClassName = scriptRef.ClassName

        -- First we'll check for a cached module value (packed into a tbl)
        local StoredModuleValue = StoredModuleValues[scriptRef]
        if StoredModuleValue and ScriptClassName == "ModuleScript" then
            return unpack(StoredModuleValue)
        end

        local Closure = ScriptClosures[scriptRef]
        if not Closure then
            return
        end

        -- If it's a BaseScript, we'll just run it directly!
        if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
            Closure()
            return
        else
            local ClosureReturn = {Closure()}
            StoredModuleValues[scriptRef] = ClosureReturn
            return unpack(ClosureReturn)
        end
    end

    -- We'll assign the actual func from the top of this output for flattening user globals at runtime
    -- Returns (in a tuple order): maui, script, require, getfenv, setfenv
    function ImportGlobals(refId)
        local ScriptRef = RefBindings[refId]

        local Closure = ScriptClosures[ScriptRef]
        if not Closure then
            return
        end

        -- This will be set right after the other global funcs, it's for handling proper behavior when
        -- getfenv/setfenv is called and safeenv needs to be disabled
        local EnvHasBeenSet = false
        local RealEnv
        local VirtualEnv
        local SetEnv

        local Global_maui = table_freeze({
            Version = Version,
            Script = script, -- The actual script object for the script this is running on, not a fake ref
            Shared = SharedEnvironment,

            -- For compatibility purposes..
            GetScript = function()
                return script
            end,
            GetShared = function()
                return SharedEnvironment
            end,
        })

        local Global_script = ScriptRef

        local function Global_require(module, ...)
            if RefChildren[module] and module.ClassName == "ModuleScript" and ScriptClosures[module] then
                return LoadScript(module)
            end

            return require(module, ...)
        end

        -- Calling these flattened getfenv/setfenv functions will disable safeenv for the WHOLE SCRIPT
        local function Global_getfenv(stackLevel, ...)
            -- Now we have to set the env for the other variables used here to be valid
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return VirtualEnv
                else
                    -- Offset by 1 for the actual env
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return VirtualEnv
                    end
                end
            end

            return getfenv(stackLevel, ...)
        end

        local function Global_setfenv(stackLevel, newEnv, ...)
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return setfenv(VirtualEnv, newEnv)
                else
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return setfenv(VirtualEnv, newEnv)
                    end
                end
            end

            return setfenv(stackLevel, newEnv, ...)
        end

        -- From earlier, will ONLY be set if needed
        function SetEnv()
            RealEnv = getfenv(0)

            local GlobalEnvOverride = {
                ["maui"] = Global_maui,
                ["script"] = Global_script,
                ["require"] = Global_require,
                ["getfenv"] = Global_getfenv,
                ["setfenv"] = Global_setfenv,
            }

            VirtualEnv = setmetatable({}, {
                __index = function(_, index)
                    local IndexInVirtualEnv = rawget(VirtualEnv, index)
                    if IndexInVirtualEnv ~= nil then
                        return IndexInVirtualEnv
                    end

                    local IndexInGlobalEnvOverride = GlobalEnvOverride[index]
                    if IndexInGlobalEnvOverride ~= nil then
                        return IndexInGlobalEnvOverride
                    end

                    return RealEnv[index]
                end
            })

            setfenv(Closure, VirtualEnv)
            EnvHasBeenSet = true
        end

        -- Now, return flattened globals ready for direct runtime exec
        return Global_maui, Global_script, Global_require, Global_getfenv, Global_setfenv
    end

    for _, ScriptRef in next, ScriptsToRun do
        Defer(LoadScript, ScriptRef)
    end

    -- If there's a "MainModule" top-level modulescript, we'll return it from the output's closure directly
    do
        local MainModule
        for _, Ref in next, RealObjectRoot do
            if Ref.ClassName == "ModuleScript" and Ref.Name == "MainModule" then
                MainModule = Ref
                break
            end
        end

        if MainModule then
            return LoadScript(MainModule)
        end
    end

    -- If any scripts are currently running now from task scheduler, the scope won't close until all running threads are closed
    -- (thanks for coming to my ted talk)
end

