config = {}

config.debug = true -- Debug mode

config.command = 'magicglass' -- Command to open 

config.clothes = { 
    ['naked'] = {
        m = {
            tshirt = 15,
            jacket = 15,
            arms = 15,
            pants = 61,
            shoes = 34,
            armor = 0,
        },
        f = {
            tshirt = 2,
            jacket = 18,
            arms = 15,
            pants = 15,
            shoes = 35,
        }
    }
}

config.notify = function(data)
    lib.notify({
        title = data.title,
        description = data.desc,
        position = 'top-right',
        icon = 'glasses',
        iconColor = data.color or '#ffffff',
    })
end

config.lang = {
    title = 'Magic Glass',
    stopped = 'Glasses stopped scanning people around you',
    have = 'You must have a pair of glasses',
    scanning = 'Glasses started scanning people around you',
}