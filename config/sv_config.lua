Config = {}

Config.SecurityToken = "KJ Scripts" -- NIKS MEE DOEN

Config.AllowedGroups = { -- Groepen die de command mogen uitvoeren dus: mod, admin, superadmin
    "admin"
}

Config.Command = "givecar" -- De command

Config.PlateFormat = "5L " ..math.random(1, 99999) -- Niet aanzitten

Config.CustomBanFunction = function (id, reason) -- Niet aanzitten
    print("Kicked Player due to Exploit! Name: " ..GetPlayerName(id).. "(" ..id.. ")")
    DropPlayer(id, reason)
end