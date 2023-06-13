fx_version 'cerulean'
games { 'gta5' }

author 'Coevect'
description 'Bounty Hunting'
version '1.0.0'
lua54 'yes'

-- What to run
client_script 'client.lua'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}