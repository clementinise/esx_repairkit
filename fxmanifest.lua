fx_version 'cerulean'
games { 'gta5' }

author 'jonteohr'
description 'ESX Repairkit'
version '3.6'

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua',
	'locales/*.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'server/main.lua',
	'locales/*.lua',
	'config.lua'
}
