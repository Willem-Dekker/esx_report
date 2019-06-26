resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_report - By WillemSpoelstra'

version '1.0.0'

client_script {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'client.lua',
  'config.lua'

}

server_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'server.lua',
  'config.lua'

}
