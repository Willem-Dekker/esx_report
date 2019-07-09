local ESX = nil
local payloadFormat = "{ \"username\" : \"%s\", \"avatar_url\" : \"%s\", \"embeds\": [{ \"title\": \"%s\", \"type\": \"rich\", \"description\": \"%s\", \"color\": %d, \"footer\": {\"text\": \"esx_report | Willemde20#0001\"} }]}"

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterCommand('reply', function(source, args, rawCommand)
	local cm = stringsplit(rawCommand, ' ')
	CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ''
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. ' ' .. tostring(cm[i]))
				end
			end
			local xPlayer = ESX.GetPlayerFromId(source)
		    if xPlayer.getGroup() ~= Config.defaultUserGroup then
			    TriggerClientEvent('esx_report:textmsg', tPID, source, textmsg, names2, names3)
				TriggerClientEvent('esx_report:sendReply', -1, source, textmsg, names2, names3)
				if Config.useDiscord then
					local username = names3 .. ' ['.. source ..']'
					SendWebhookMessage(Config.webhookurl, username , "Reply", '-> ' .. names2  .. ' ['.. tPID ..'] '..':  ' .. textmsg )
				end
		    else
			    TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insuficient Premissions!')
			end
		end
end, false)

RegisterCommand('report', function(source, args, rawCommand)
	local cm = stringsplit(rawCommand, ' ')
	CancelEvent()
		if tablelength(cm) > 1 then
			local names1 = GetPlayerName(source)
			local textmsg = ''
			for i=1, #cm do
				if i ~= 1 then
					textmsg = (textmsg .. ' ' .. tostring(cm[i]))
				end
			end
			TriggerClientEvent('esx_report:sendReport', -1, source, names1, textmsg)
			if Config.useDiscord then
				local username = names1 .. ' ['.. source ..']'
				SendWebhookMessage(Config.webhookurl, username , 'Report', '' .. textmsg .. '')
			end		
		end
end, false)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, '([^'..sep..']+)') do
        t[i] = str
        i = i + 1
    end
    return t
end


ESX.RegisterServerCallback('esx_report:fetchUserRank', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb('user')
        end
    else
        cb('user')
    end
end)

Citizen.CreateThread(function()
	function SendWebhookMessage(webhook, Username, typeofmessage ,message)
		if webhook ~= 'none' then
			local embed = {title = typeofmessage, type = "rich", description = message , color = Config.color[typeofmessage]}
			local colorname = string.lower(typeofmessage)
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', string.format(payloadFormat, Username, Config.imgurl, typeofmessage, message, Config.color[colorname]), { ['Content-Type'] = 'application/json' })
		end
	end
end)

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
