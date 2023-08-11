local cachedPed = nil
local cachedComponents = nil

local function loadPed(model)
    if type(model) ~= "number" then
        model = GetHashKey(model)
    end
    if not IsModelValid(model) then
        return false
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end

    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(PlayerPedId())
    ClearAllPedProps(PlayerPedId())
    ClearPedDecorations(PlayerPedId())
    ClearPedFacialDecorations(PlayerPedId())
    SetModelAsNoLongerNeeded(PlayerPedId())
    return true
end

local function loadVisualization(components)
    for _, component in pairs(components) do
        local componentId = component.componentId and tonumber(component.componentId) or 0
        local drawableId = component.drawableId and tonumber(component.drawableId) or 0
        local textureId = component.textureId and tonumber(component.textureId) or 0
        local paletteId = component.paletteId and tonumber(component.paletteId) or 0
        SetPedComponentVariation(PlayerPedId(), componentId, drawableId, textureId, paletteId)
    end
end

RegisterNetEvent('maku_pedmenu:sync', function(ped)
    local playerPed = PlayerPedId()
    if ped == nil then
        print('^1[sync]^0 ped is nil, maybe removed by administrator?')
        loadPed('mp_m_freemode_01')
        return
    end
    local model = ped.model
    local components = ped.components

    cachedPed = model
    cachedComponents = ped.components

    if GetEntityModel(playerPed) ~= GetHashKey(model) then
        print('^3[sync]^0 player has different ped, loading correct ped')
        local success = loadPed(model)
        if not success then
            print('^1[sync]^0 failed to load ped')
            return
        end
    end
    print('^3[sync]^0 loading visualization')
    loadVisualization(components)
end)

RegisterCommand('refresh', function(source, args, raw)
    local success = loadPed(cachedPed)
    if not success then
        print('^1[sync]^0 failed to load ped')
        return
    end
    print('^3[sync]^0 loading visualization')
    loadVisualization(cachedComponents)
end)
