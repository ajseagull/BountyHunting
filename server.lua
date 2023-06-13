local QBCore = exports['qb-core']:GetCoreObject()

local BountyEnabled = false

RegisterNetEvent("cvt-bounty:GetRandomBounty", function()
    local src = source
        local response = MySQL.Sync.fetchAll('SELECT cid FROM qbcoreframework_397fb5.mdt_convictions WHERE warrant = 1 AND processed = 0 ORDER BY RAND() LIMIT 1')
        if response then
            for i = 1, #response do
                local Player = QBCore.Functions.GetPlayerByCitizenId(tostring(response[i].cid))
                if Player then
                    local target = Player.PlayerData.source
                    local coords = GetEntityCoords(GetPlayerPed(target))
                    TriggerClientEvent("cvt-bounty:GetLocation", target, src)
                    TriggerClientEvent("cvt-bounty:ShowInfo", src, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
                else
                    TriggerClientEvent("cvt-bounty:PlayerOffline", src)
                end
            end
        end
end)

RegisterNetEvent("cvt-bounty:GetTracker", function(coords, requester)
    TriggerClientEvent("cvt-bounty:location", requester, coords)
end)