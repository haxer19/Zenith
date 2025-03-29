local RejoinServer = {}

function RejoinServer.RejoinLess()
    local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < game.Players.NumPlayers and server.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
            break
        end
    end
end

return RejoinServer