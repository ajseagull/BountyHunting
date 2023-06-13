

local inDist = false
local npcSpawned = false
local npc = nil

local BountyActive = false

local function GetDistance()
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    local npcCoords = vector3(Config.Ped.X, Config.Ped.Y, Config.Ped.Z)
    local dist = #(playerCoords - npcCoords)
    if dist < 15 then
        inDist = true
        print("Within Range")
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local npcCoords = vector3(Config.Ped.X, Config.Ped.Y, Config.Ped.Z)
        local dist = #(playerCoords - npcCoords)
        local hash = GetHashKey(Config.Ped.Model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        if not npcSpawned and dist < 15 then
            npc = CreatePed(0, hash, vector3(Config.Ped.X, Config.Ped.Y, Config.Ped.Z - 1), Config.Ped.Heading, false, true)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            npcSpawned = true
        elseif npcSpawned and dist > 15 then
            print(npc)
            DeleteEntity(npc)
            npcSpawned = false
        end
        if npcSpawned and dist < 2.5 then
            local getBounty = lib.showTextUI('[E] - Get Random Bounty')
            if IsControlPressed(0, 51) then
                print('1')
                TriggerServerEvent("cvt-bounty:GetRandomBounty")
            end
        elseif npcSpawned and dist > 2.5 then
            lib.hideTextUI(getBounty)
        end
    end
end)

RegisterNetEvent("cvt-bounty:ShowInfo", function(firstname, lastname)
    if not BountyActive then
        lib.notify({
            title = 'Bounty Grabbed!',
            description = 'First Name: ' .. firstname .. ' Last Name: ' .. lastname .. '!',
            type = 'success'
        })
    end
end)

RegisterNetEvent("cvt-bounty:PlayerOffline", function()
    lib.notify({
        title = 'Bounty Not Available!',
        description = 'This person is not awake. Try again!',
        type = 'error'
    })
end)

RegisterNetEvent("cvt-bounty:GetLocation", function(request)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("cvt-bounty:GetTracker", coords, request)
end)

RegisterNetEvent("cvt-bounty:location", function(coords)
    if not BountyActive then
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 501)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bounty Location")
        EndTextCommandSetBlipName(blip)
            
        SetNewWaypoint(coords.x, coords.y)
        BountyActive = true
    end

    SetTimeout(600000, function()
        BountyActive = false
        RemoveBlip(blip)
    end)
end)