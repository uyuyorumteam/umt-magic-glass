function getPedModel(playerPed)
    local model = GetEntityModel(playerPed)
    if model == `mp_m_freemode_01` then 
        return config.clothes['naked'].m
    elseif model == `mp_f_freemode_01` then
        return config.clothes['naked'].f
    else
        return Debug('Unknown model [' .. model .. ']', 'error')
    end
end

function checkGlasses()
    local glassesIndex = GetPedPropIndex(cache.ped, 1)
    if glassesIndex ~= -1 then
       return true 
    end
    return config.notify({title = config.lang.title, desc = config.lang.have, color='#FF0000'})
end
