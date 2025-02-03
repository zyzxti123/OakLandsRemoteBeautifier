local Client = require(game.ReplicatedFirst.Client)
local Key = require(game.ReplicatedFirst.Client._Key)

local HashingKey: string = debug.getupvalues(Client.CreateKeyHash)[3]
local CachedDehashedRemotes: {[string]: string} = {}

for RemoteHashedName: string, RemoteInstanceName: string in pairs(Client.CachedRemotes) do
    local RemoteDehashedName: string = Key(`{RemoteHashedName}{HashingKey}`, HashingKey)
    RemoteDehashedName = RemoteDehashedName:split(HashingKey)[1]
  
    local RemoteInstance: (RemoteFunction | RemoteEvent) = game.ReplicatedStorage.REM:FindFirstChild(RemoteInstanceName)
    if RemoteInstance then
        RemoteInstance.Name = RemoteDehashedName
    end

    CachedDehashedRemotes[RemoteDehashedName] = RemoteDehashedName
end

Client.CachedRemotes = CachedDehashedRemotes

hookfunction(Client.CreateKeyHash, function(_, RemoteName: string): string
    return RemoteName:split(HashingKey)[1]
end)
