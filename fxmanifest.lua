fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RPX Radial Menu System'
author 'Sinatra#0101'
version '0.0.1'

dependency 'ox_lib'

client_scripts {
    '@ox_lib/init.lua',
    'client/config.lua',
    'client/main.lua',
}

lua54 'yes'