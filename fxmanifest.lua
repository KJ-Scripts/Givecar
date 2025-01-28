author "KJ Scripts"
description "/givecar command"

fx_version "cerulean"
lua54 'yes'
game "gta5"
client_scripts {
    "client/*.lua"
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "config/sv_config.lua",
    "server/*.lua"
}
