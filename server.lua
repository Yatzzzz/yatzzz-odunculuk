ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("ytzdev:oduntopla")
AddEventHandler("ytzdev:oduntopla", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local oduntopla = xPlayer.getInventoryItem('balta').count
    if oduntopla > 0 then
        xPlayer.addInventoryItem('odun', Config.Yatzzz)
        dclog(xPlayer, 'Odun - ' ..Config.Yatzzz..' Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Balta Mevcut Değil Veya Üstün Dolu'})
    end
end)

RegisterServerEvent("ytzdev:odunkes")
AddEventHandler("ytzdev:odunkes", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local odunkes = xPlayer.getInventoryItem('odun').count

    if odunkes > 0 then
        xPlayer.removeInventoryItem('odun', Config.Yatzzz)
        xPlayer.addInventoryItem('kesikodun', Config.Yatzzz)
        dclog(xPlayer, 'Kesik Odun - ' ..Config.Yatzzz..' Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Yeterli Odun Yok'})
    end
end)

RegisterServerEvent("ytzdev:odunpaket")
AddEventHandler("ytzdev:odunpaket", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local odunpaket = xPlayer.getInventoryItem('odun').count
    if odunpaket > 0 then
        xPlayer.removeInventoryItem('kesikodun', Config.Yatzzz)
        xPlayer.addInventoryItem(RandomItem(), Config.Yatzzz)
        dclog(xPlayer, '1 Adet Bu Ağaçtan - ' ..RandomItem()..' Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Yeterli Kesik Odun Yok'})
    end
end)

RegisterServerEvent("ytzdev:mesesat")
AddEventHandler("ytzdev:mesesat", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local mese = xPlayer.getInventoryItem('Mese').count
    if mese > 0 then
        xPlayer.removeInventoryItem('Mese', Config.Yatzzz)
        xPlayer.addInventoryItem('cash', Config.MeseSat)
        dclog(xPlayer, '1 Adet Mese Agacı Karşılıgında - ' ..Config.MeseSat..' $ Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Yeterli Miktarda Meşe Yok'})
    end
end)

RegisterServerEvent("ytzdev:cinarsat")
AddEventHandler("ytzdev:cinarsat", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cinar = xPlayer.getInventoryItem('Cınar').count
    if cinar > 0 then
        xPlayer.removeInventoryItem('Cınar', Config.Yatzzz)
        xPlayer.addInventoryItem('cash', Config.CinarSat)
        dclog(xPlayer, '1 Adet Cınar Agacı Karşılıgında - ' ..Config.CinarSat..' $ Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Yeterli Miktarda Çınar Yok'})
    end
end)

RegisterServerEvent("ytzdev:palamutsat")
AddEventHandler("ytzdev:palamutsat", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local palamut = xPlayer.getInventoryItem('Palamut').count
    if palamut > 0 then
        xPlayer.removeInventoryItem('Palamut', Config.Yatzzz)
        xPlayer.addInventoryItem('cash', Config.PalamutSat)
        dclog(xPlayer, '1 Adet Palamut Agacı Karşılıgında - ' ..Config.PalamutSat..' $ Aldı')
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Üzerinde Yeterli Miktarda Palamut Yok'})
    end
end)

Items = {
    'Mese',
    'Cınar',
    'Palamut'
}

function RandomItem()
    return Items[math.random(#Items)]
end

ESX.RegisterServerCallback('ytz-checkitem', function(source, cb, item, output)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local items = xPlayer.getInventoryItem(item)
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
    
    local discord_webhook = GetConvar('discord_webhook', Config.webhook)
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = 'Yatzzz Odunculuk Log',
      ["avatar_url"] = '',
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName .. ' - ' .. xPlayer.identifier
        },
        ["color"] = 15158332,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end