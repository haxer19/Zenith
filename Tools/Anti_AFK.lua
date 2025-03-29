local AFK = {}

AFK.Enabled = false

function AFK:Start()
    if not self.Enabled then
        self.Enabled = true
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            if self.Enabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new()) 
            end
        end)
    end
end

function AFK:Stop()
    if self.Enabled then
        self.Enabled = false
    end
end

return AFK