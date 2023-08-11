pendingRequests = {}

_RegisterCommand = RegisterCommand

RegisterCommand = function(commandName, handler, restricted)
    return _RegisterCommand(commandName, function(source, args, raw)
        local allowedGroups = Commands[commandName]
        if allowedGroups ~= nil then
            local player = ESX.GetPlayerFromId(source)
            if player == nil then
                player.showNotification('Nepovedlo se získat instanci tvého hráče.', 'error')
                return
            end
            if not allowedGroups[player.getGroup()] then
                player.showNotification('Nemáš oprávnění k použití tohoto příkazu.', 'error')
                return
            end
        end

        if handler ~= nil then
            handler(source, args, raw)
        end
    end, restricted)
end

RegisterCommand('addped', function(source, args, raw)
    local player = ESX.GetPlayerFromId(source)
    if player == nil then
        player.showNotification('Nepovedlo se získat instanci tvého hráče.', 'error')
        return
    end
    local target = args[1]
    local ped = args[2]
    -- todo: components
    if target == nil or ped == nil then
        player.showNotification('Musíš zadat ID hráče a model peda.', 'error')
        return
    end

    target = tonumber(target)
    local targetPlayer = ESX.GetPlayerFromId(target)
    if targetPlayer == nil then
        player.showNotification('Hráč s tímto ID neexistuje.', 'error')
        return
    end

    pendingRequests[source] = {
        target = target,
        identifier = targetPlayer.identifier,
        ped = ped
    }

    TriggerClientEvent('maku_pedmenu:showComponentsSelection', source, ped)
end)

RegisterNetEvent('maku_pedmenu:selectComponents', function(components)
    local source = source
    local request = pendingRequests[source]
    if request == nil then
        return
    end
    local target = request.target
    local identifier = request.identifier
    local ped = request.ped
    db.savePlayerPed(identifier, ped, components)
    pendingRequests[source] = nil

    local player = ESX.GetPlayerFromId(source)
    if player ~= nil then
        player.showNotification('Ped byl úspěšně přidán hráči.')
    end

    TriggerClientEvent('maku_pedmenu:sync', target, {
        model = ped,
        components = components
    })
end)

RegisterCommand('deleteped', function(source, args, raw)
    local player = ESX.GetPlayerFromId(source)
    if player == nil then
        player.showNotification('Nepovedlo se získat instanci tvého hráče.', 'error')
        return
    end
    local target = args[1]
    if target == nil then
        player.showNotification('Musíš zadat ID hráče.', 'error')
        return
    end

    target = tonumber(target)
    local targetPlayer = ESX.GetPlayerFromId(target)
    if targetPlayer == nil then
        player.showNotification('Hráč s tímto ID neexistuje.', 'error')
        return
    end

    db.deletePlayerPed(targetPlayer.identifier)
    player.showNotification('Ped byl úspěšně odebrán hráči.')
    TriggerClientEvent('maku_pedmenu:sync', target, nil)
end)
