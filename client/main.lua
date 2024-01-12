local toggle = false 

local playersOldOutifts = {}

local clothesCategory = {
    arms = 3,
    pants = 4,
    shoes = 6,
    tshirt = 8,
    armor = 9,
    jacket = 11
}

local function setClothesTable(playerPed)
    if playersOldOutifts[playerPed] then
        Debug('Outfit already saved for [' .. playerPed .. ']')
        return
    end
    
    local outfit = {}

    for category, value in pairs(clothesCategory) do
        if GetPedDrawableVariation(playerPed, value) ~= 0 then
            local drawableVariation = GetPedDrawableVariation(playerPed, value)
            local textureVariation = GetPedTextureVariation(playerPed, value)
            Debug('Category Found [' .. category .. ']' .. ' Drawable [' .. drawableVariation .. ']' .. ' Texture [' .. textureVariation .. ']')
            outfit[category] = {
                componentId = value,
                drawableId  = drawableVariation,
                textureId  = textureVariation
            }
        end
    end

    playersOldOutifts[playerPed] = outfit

    Debug('Outfit saved for [' .. playerPed .. ']')
end

local function revertPlayerClothes(playerPed)
    if playersOldOutifts[playerPed] then
        for category, details in pairs(playersOldOutifts[playerPed]) do
            if details.componentId and details.drawableId and details.textureId then
                SetPedComponentVariation(playerPed, details.componentId, details.drawableId, details.textureId, 0)
            end
        end
    end
end

local function setPlayerClothesToConfig(playerPed, config)
    for category, value in pairs(config) do
        local componentId = clothesCategory[category]
        if componentId then
            SetPedComponentVariation(playerPed, componentId, value, 0, 0)
        end
    end
end

local function allDefaultBack()
    SetTimecycleModifier('default')
    SetFollowPedCamViewMode(1)
    for ped, _ in pairs(playersOldOutifts) do
        Debug('Reverting clothes for [' .. ped .. ']')
        revertPlayerClothes(ped)
    end
    playersOldOutifts = {}
    
    config.notify({title = config.lang.title, desc = config.lang.stopped, color = '#FF0000'})
end


local function startMagicGlass()
    if not checkGlasses() then return end

    toggle = not toggle
    
    if not toggle then 
        allDefaultBack()
        return
    end

    config.notify({title = config.lang.title, desc = config.lang.scanning, color = '#008000'})
    
    SetTimecycleModifier('scanline_cam_cheap')

    while toggle do 
        local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 10, false)
        if next(players) then
            for i = 1, #players, 1 do
                local ped = players[i].ped
                setClothesTable(ped)
                setPlayerClothesToConfig(ped, getPedModel(ped))
            end
        else
            Debug('No nearby players', 'info')
        end

        SetFollowPedCamViewMode(4)

        Wait(1000)
    end

end

RegisterCommand(config.command, function()
    startMagicGlass()
end)
