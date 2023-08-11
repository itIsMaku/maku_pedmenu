fx_version 'cerulean'
games { 'gta5' }
version '1.0'
author 'maku#5434'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'configs/sh-config.lua'
}

client_scripts {
    'client/cl-main.lua',
    'client/cl-admin.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/sv-config.lua',
    'server/sv-main.lua',
    'server/sv-database.lua',
    'server/sv-admin.lua'
}

dependency {
    'oxmysql'
}

ox_libs {
    'interface'
}
