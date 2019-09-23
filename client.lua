
--template for message
local formatOfMessage = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 184, 77, 0.6); border-radius: 3px;"><i class="fas fa-commenting"></i> <b><font color=red>[{0}]:</b></font> {1}</div>'
local usergroup = 'user'

local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.TriggerServerCallback("esx_report:fetchUserRank", function(group)
        usergroup = group
    end)

    TriggerEvent('chat:addSuggestion', '/reply', _U('description_reply'), {
        { name="id", help= _U('help_text_id') },
        { name="msg", help= _U('help_text_messege_reply') }
    })

    TriggerEvent('chat:addSuggestion', '/report', _U('description_report'), {
        { name="msg", help= _U('help_text_messege_report') }
    })
end)

RegisterNetEvent("esx_report:textmsg")
AddEventHandler('esx_report:textmsg', function(source, textmsg, names2, names3 )
    local message = names3 .."  "..": " .. textmsg
    local name = "Reply"
    TriggerEvent('chat:addMessage', {
        template = formatOfMessage, 
        args = { name, message }
    })
end)


RegisterNetEvent('esx_report:sendReply')
AddEventHandler('esx_report:sendReply', function(source, textmsg, names2, names3 ) 
    if usergroup ~= Config.defaultUserGroup then
        local message = names3 .." -> " .. names2 ..":  " .. textmsg
        local name = "Reply"
        
        TriggerEvent('chat:addMessage', {
            template = formatOfMessage, 
            args = { name, message }
        })
        
    end
end)

RegisterNetEvent('esx_report:sendReport')
AddEventHandler('esx_report:sendReport', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    
    if pid == myId then
        local name = "Report"
        
        TriggerEvent('chat:addMessage', {
            template = formatOfMessage,
            args = { name, _U("send_to_admins") }
        })
    end
    
    if usergroup ~= 'user' then
        local message =  "[".. id .."]" .. name .."  "..": " .. message
        local name = "Report"
        
        TriggerEvent('chat:addMessage', {
            template = formatOfMessage,
            args = { name, message }
        })
        
    end
end)

