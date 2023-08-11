ESX = exports.es_extended:getSharedObject()

MySQL.ready(function()
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `pedmenu` (
            `identifier` VARCHAR(52) NOT NULL,
            `model` VARCHAR(52) NOT NULL,
            `components` LONGTEXT DEFAULT NULL,

            PRIMARY KEY (`identifier`)
        )
    ]])
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    for _, playerId in ipairs(GetPlayers()) do
        playerId = tonumber(playerId)
        local player = ESX.GetPlayerFromId(playerId)
        if player == nil then
            print('^1[error]^0 player ', playerId, 'can not be synced (1)')
            return
        end
        local ped = db.getPlayerPed(player.identifier)
        if ped == nil then
            return
        end
        ped.identifier = nil
        TriggerClientEvent('maku_pedmenu:sync', playerId, ped)
    end
end)
