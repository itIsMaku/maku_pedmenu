RegisterNetEvent('maku_pedmenu:showComponentsSelection', function(ped)
    local visualization = Visualizations[ped]
    local components = {}
    if visualization then
        local options = {}
        for id, component in pairs(visualization.Components) do
            local suboptions = {}
            for id, texture in ipairs(component.Textures) do
                table.insert(suboptions, {
                    value = id - 1,
                    label = texture
                })
            end
            table.insert(options, {
                id = id,
                componentId = component.Id,
                type = 'select',
                label = component.Label,
                options = suboptions,
                required = true,
            })
        end
        local input = lib.inputDialog('Vyber komponenty pro peda', options)

        local i = 1
        for id, component in pairs(visualization.Components) do
            components[id] = {
                componentId = component.Id,
                textureId = input[i]
            }
            i = i + 1
        end
    end
    TriggerServerEvent('maku_pedmenu:selectComponents', components)
end)
