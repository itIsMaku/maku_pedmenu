db = {}

function db.getPlayerPed(identifier)
    local retval = MySQL.Sync.fetchAll('SELECT * FROM pedmenu WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    if retval == nil or #retval < 1 then
        return nil
    end
    retval[1].components = json.decode(retval[1].components)
    return retval[1]
end

function db.savePlayerPed(identifier, model, components)
    if components == nil then
        components = {}
    end
    components = json.encode(components)
    local retval = MySQL.Sync.fetchAll('SELECT * FROM pedmenu WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    if retval == nil or #retval < 1 then
        MySQL.Async.execute(
            'INSERT INTO pedmenu (identifier, model, components) VALUES (@identifier, @model, @components)', {
                ['@identifier'] = identifier,
                ['@model'] = model,
                ['@components'] = components
            })
    else
        MySQL.Async.execute('UPDATE pedmenu SET model = @model, components = @components WHERE identifier = @identifier',
            {
                ['@identifier'] = identifier,
                ['@model'] = model,
                ['@components'] = components
            })
    end
end

function db.deletePlayerPed(identifier)
    MySQL.Async.execute('DELETE FROM pedmenu WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
end
