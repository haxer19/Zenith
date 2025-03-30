local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local vk = loadstring(game:HttpGet("https://raw.githubusercontent.com/haxer19/Zenith/main/Tools/voidkill"))()
local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/haxer19/hihihihi/main/ESPLibrary.lua"))()
local afk = loadstring(game:HttpGet("https://raw.githubusercontent.com/haxer19/Zenith/main/Tools/Anti_AFK.lua"))()

local config = {
    tools = {
        afk = false,
        vk = false,
    }
}

local Window = WindUI:CreateWindow({
    Title = "The Strongest Battlegrounds",
    Icon = "rbxassetid://128991800373681",
    Author = "Zenith",
    Folder = "TSBattles",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = false
})

Window:EditOpenButton({
    Title = "Toggle",
    Icon = "rbxassetid://128991800373681",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2,
    Color = ColorSequence.new({ 
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0F7B")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F89B29"))
    }),
    Draggable = false,
})

WindUI:Notify({
    Title = "Hi " .. game:GetService("Players").LocalPlayer.Name,
    Content = "Glad you used my script!",
    Duration = 5,
})

local Tabs = {
    Info = Window:Tab({ Title = "Info", Icon = "rbxassetid://7733964719", Desc = "Info" }),
    t1 = Window:Divider(),
    Home = Window:Tab({ Title = "Home", Icon = "rbxassetid://7733960981", Desc = "General" }),
    Players = Window:Tab({ Title = "Players", Icon = "rbxassetid://7743876054", Desc = "Player" }),
    t2 = Window:Divider(),
    Settings = Window:Tab({ Title = "Settings", Icon = "rbxassetid://7733960981", Desc = "Config" }),
}

Window:SelectTab(1)

Tabs.Info:Section({ Title = "Info" })
Tabs.Info:Paragraph({
    Title = "Latest update (V1.0.0)",
    Desc = "My journey in scripting for The Strongest Battlegrounds begins here.",
})

Tabs.Home:Section({ Title = "Player" })
Tabs.Home:Paragraph({
    Title = "Void Kill",
    Desc = "Equip garou for this to work, only move 1 and 2.",
})
Tabs.Home:Toggle({
    Title = "Auto Void Kill",
    Default = false,
    Callback = function(state)
        config.tools.vk = state
        if config.tools.vk then
            vk.toggle()
        else
            vk.toggle()
        end
    end
})

-- Teleport 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerList = {}

local function UpdatePlayerList()
    PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
end

UpdatePlayerList()

Tabs.Players:Section({ Title = "Teleport" })

local SelectedPlayer = ""

Tabs.Players:Dropdown({
    Title = "Player List",
    Values = PlayerList,
    Value = "",
    Callback = function(option)
        SelectedPlayer = option
    end
})

Tabs.Settings:Button({
    Title = "Refresh List",
    Callback = function()
        UpdatePlayerList()
    end
})

Tabs.Settings:Button({
    Title = "Teleport To Player",
    Callback = function()
        local TargetPlayer = Players:FindFirstChild(SelectedPlayer)
        if TargetPlayer and TargetPlayer.Character and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(TargetPlayer.Character.PrimaryPart.CFrame)
        end
    end
})

Tabs.Players:Section({ Title = "ESP" })
Tabs.Players:Dropdown({
    Title = "Aura Color",
    Values = { "White", "Green", "Blue", "Red", "Yellow", "Orange", "Purple" },
    Value = "White",
    Callback = function(option)
        esp:SetColor(option)
    end
})

Tabs.Players:Toggle({
    Title = "Enable ESP",
    Default = false,
    Callback = function(state)
        if state then
            esp:Enable()
        else
            esp:Disable()
        end
    end
})

Tabs.Settings:Section({ Title = "Feature" })
Tabs.Settings:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        config.tools.afk = state
        if config.tools.afk then
            afk:Start()
            WindUI:Notify({
                Title = "SynHaX",
                Content = "Anti AFK - Enabled",
                Duration = 5,
            })
        else
            afk:Stop()
            WindUI:Notify({
                Title = "SynHaX",
                Content = "Anti AFK - Disabled",
                Duration = 5,
            })
        end
    end
})

Tabs.Settings:Button({
    Title = "Rejoin Server",
    Desc = "Other servers have less players.",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/haxer19/Zenith/main/Tools/Rejoin.lua"))().RejoinLess()
    end
})

Tabs.Settings:Button({
    Title = "Anti Lag",
    Desc = "FPS BOOST",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/haxer19/Zenith/main/antilag"))()
    end
})

local HttpService = game:GetService("HttpService")

local folderPath = "WindUI"
if not isfolder(folderPath) then
    makefolder(folderPath)
end

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
    return nil
end

local function ListFiles()
    local files = {}
    if isfolder(folderPath) then
        for _, file in ipairs(listfiles(folderPath)) do
            local fileName = file:match("([^/]+)%.json$")
            if fileName then
                table.insert(files, fileName)
            end
        end
    end
    return files
end

Tabs.Settings:Section({ Title = "Window" })

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.Settings:Dropdown({
    Title = "Select Theme",
    Multi = false,
    AllowNone = false,
    Value = "Dark",
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = Tabs.Settings:Toggle({
    Title = "Toggle Window Transparency",
    Default = true,
    Callback = function(e)
        Window:ToggleTransparency(e)
    end
})

Tabs.Settings:Section({ Title = "Save" })

local fileNameInput = ""
Tabs.Settings:Input({
    Title = "Write File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        fileNameInput = text
    end
})

Tabs.Settings:Button({
    Title = "Save File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { 
                Transparent = WindUI:GetTransparency(), 
                Theme = WindUI:GetCurrentTheme() 
            })
            WindUI:Notify({
                Title = "Success",
                Content = "File saved successfully",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a file name",
                Duration = 5,
            })
        end
    end
})

Tabs.Settings:Section({ Title = "Load" })

local filesDropdown
local files = ListFiles()

filesDropdown = Tabs.Settings:Dropdown({
    Title = "Select File",
    Multi = false,
    AllowNone = true,
    Values = files,
    Callback = function(selectedFile)
        fileNameInput = selectedFile or ""
    end
})

Tabs.Settings:Button({
    Title = "Load File",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                if data.Transparent ~= nil then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then 
                    WindUI:SetTheme(data.Theme)
                    themeDropdown:Select(data.Theme)
                end
                WindUI:Notify({
                    Title = "File Loaded",
                    Content = "Loaded data successfully",
                    Duration = 5,
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Failed to load file",
                    Duration = 5,
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a file",
                Duration = 5,
            })
        end
    end
})

Tabs.Settings:Button({
    Title = "Overwrite File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { 
                Transparent = WindUI:GetTransparency(), 
                Theme = WindUI:GetCurrentTheme() 
            })
            WindUI:Notify({
                Title = "Success",
                Content = "File overwritten successfully",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a file to overwrite",
                Duration = 5,
            })
        end
    end
})

Tabs.Settings:Button({
    Title = "Refresh List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].PlaceholderText

local function updateTheme()
    WindUI:AddTheme({
        Name = currentThemeName,
        Accent = ThemeAccent,
        Outline = ThemeOutline,
        Text = ThemeText,
        PlaceholderText = ThemePlaceholderText
    })
    WindUI:SetTheme(currentThemeName)
    themeDropdown:Select(currentThemeName)
end

Tabs.Settings:Input({
    Title = "Theme Name",
    Value = currentThemeName,
    Callback = function(name)
        currentThemeName = name
    end
})

Tabs.Settings:Colorpicker({
    Title = "Background Color",
    Default = Color3.fromRGB(themes[currentThemeName].Accent),
    Callback = function(color)
        ThemeAccent = color
        updateTheme()
    end
})

Tabs.Settings:Colorpicker({
    Title = "Outline Color",
    Default = Color3.fromRGB(themes[currentThemeName].Outline),
    Callback = function(color)
        ThemeOutline = color
        updateTheme()
    end
})

Tabs.Settings:Colorpicker({
    Title = "Text Color",
    Default = Color3.fromRGB(themes[currentThemeName].Text),
    Callback = function(color)
        ThemeText = color
        updateTheme()
    end
})

Tabs.Settings:Colorpicker({
    Title = "Placeholder Text Color",
    Default = Color3.fromRGB(themes[currentThemeName].PlaceholderText),
    Callback = function(color)
        ThemePlaceholderText = color
        updateTheme()
    end
})

Tabs.Settings:Button({
    Title = "Update Theme",
    Callback = function()
        updateTheme()
        WindUI:Notify({
            Title = "Success",
            Content = "Theme updated successfully",
            Duration = 5,
        })
    end
})