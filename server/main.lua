ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CheckPermission(id)
    if id == 0 then return true end
    local xPlayer = ESX.GetPlayerFromId(id)
    local xGroup = xPlayer.getGroup()
    for _, group in pairs(Config.AllowedGroups) do
        if group == xGroup then return true end
    end
    TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Je hebt geen perms om voertuigen aan spelers te geven!')
    return false
end

RegisterCommand(Config.Command, function (source, args)
    local id = source
    local target = args[1]
    local vehicle = args[2]
    local plate = args[3]
    local hasPerms = CheckPermission(id)
    if hasPerms then
        if GetPlayerName(target) ~= nil and vehicle ~= nil and plate ~= nil then
            TriggerClientEvent(GetCurrentResourceName()..":spawn", target, vehicle, plate)
        elseif GetPlayerName(id) ~= nil then
            TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Zet wel het kenteken erachter!')
        else
            print("/givecar (id) (vehicleModel) (kenteken)")
        end
    end
end)

RegisterNetEvent(GetCurrentResourceName()..":getToken", function ()
    TriggerClientEvent(GetCurrentResourceName()..":getToken", source, Config.SecurityToken)
end)

RegisterNetEvent(GetCurrentResourceName() .. ":set", function(props, token)
    if token ~= Config.SecurityToken then
        Config.CustomBanFunction(source, "Error!")
        return
    end
    local id = source
    local xPlayer = ESX.GetPlayerFromId(id)

    exports['oxmysql']:query('SELECT * FROM `owned_vehicles` WHERE `plate` = ?', { props.plate }, function(result)
        if #result > 0 then
            TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'error', 'Je bezit al een voertuig met dit kenteken.')
        else
            exports['oxmysql']:query('INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)',
                { xPlayer.identifier, props.plate, json.encode(props), 0, 'car' }, function(id)
                print("Added Vehicle with ID " .. id .. " to the Database")
                TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'success', 'Voertuig succesvol toegevoegd.')
            end)
        end
    end)
end)
