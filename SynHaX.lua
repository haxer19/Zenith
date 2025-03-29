local places = {
    [10449761463] = {
        tn = "The Strongest Battlegrounds",
        url = "https://raw.githubusercontent.com/haxer19/Zenith/main/Map/TSBattles.lua"
    }
}

function loadMap()
    local placeId = game.PlaceId
    if places[placeId] then
        local mapInfo = places[placeId]
        local success, err = pcall(function()
            local script = loadstring(game:HttpGet(mapInfo.url))()
            print("Successfully loaded map: " .. mapInfo.tn)
        end)
        if not success then
            warn("Failed to load map " .. mapInfo.tn .. ": " .. err)
        end
    else
        warn("Not supported, contact discord @xub19 for more updates")
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = "Map Loader",
            Text = "No map available for this Place ID: " .. placeId,
            Duration = 5
        })
    end
end

loadMap()