local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
local Server, Next = nil, nil
local function ListServers(cursor)
    local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
    return HttpService:JSONDecode(Raw)
end

repeat
    local Servers = ListServers(Next)
    Server = Servers.data[math.random(1, (#Servers.data / 3))]
    Next = Servers.nextPageCursor
until Server

if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
    TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
end
