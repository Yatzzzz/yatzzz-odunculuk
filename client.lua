ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end
end)

local sleep = 5000
local isInMarker2 = false
local aracalindi = false
local sa = false

local blips = {
	{title="Odunculuk Yeri", colour=9, id=253, x = -510.34, y = -1001.65, z = 23.55}
}

local aktifblipler = {}
local blip = false

local blipac = {
    {title="Odun Toplama", colour=9, id=253, x = -554.18, y = 5372.5, z = 70.20},
    {title="Odun Kesim", colour=9, id=253, x = -533.13, y = 5292.09, z = 74.17},
    {title="Odun Paketleme", colour=9, id=253, x = -516.44, y = 5257.09, z = 80.65},
    {title="Satış Yeri", colour=9, id=253, x = -513.07, y = -1019.11, z = 22.50},
    {title="Araç Geri Verme", colour=5, id=67, x = -494.96, y = -992.11, z = 23.55}
}

-- MENÜLER

function OpenMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'yatzzz_menu',
        {
            title    = 'Menü',
            elements = {
				{label = 'Blipleri Aç', value = 'blipOn'},
				{label = 'Blipleri Kapat', value = 'blipOff'},
				{label = 'Araç Çıkart', value = 'AracCikart'},
				{label = 'Menüyü Kapat', value = 'menuOff'},
            }
        },
        function(data, menu)
            if data.current.value == 'menuOff' then
                menu.close()
            elseif data.current.value == 'blipOn' then
                blipOn()
            elseif data.current.value == 'blipOff' then
                blipOff()
            elseif data.current.value == 'AracCikart' then
                AracCikart()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end


function OpenSatisMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'emir_menu',
        {
            title    = 'Satış Menüsü',
            elements = {
                {label = 'Meşe Ağacı Sat 350$', value = 'mesesat'},
                {label = 'Çınar Ağacı Sat 400$', value = 'cinarsat'},
                {label = 'Palamut Ağacı Sat 600$', value = 'palamutsat'},
				{label = 'Menüyü Kapat', value = 'menuOff'},
            }
        },
        function(data, menu)
            if data.current.value == 'menuOff' then
                menu.close()
            elseif data.current.value == 'mesesat' then
                mesesat()
            elseif data.current.value == 'cinarsat' then
                cinarsat()
            elseif data.current.value == 'palamutsat' then
                palamutsat()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

-- FONKSİYONLAR
 
function blipOn()
    local player = PlayerPedId()
    TriggerEvent("ytzdev:blipAcKapa")

end

function blipOff()
    local player = PlayerPedId()
    TriggerEvent("ytzdev:blipAcKapa")

end

function mesesat()
    local player = PlayerPedId()

    TriggerServerEvent('ytzdev:mesesat')
end

function cinarsat()
    local player = PlayerPedId()

    TriggerServerEvent('ytzdev:cinarsat')
end

function palamutsat()
    local player = PlayerPedId()

    TriggerServerEvent('ytzdev:palamutsat')
end

-- ODUN TOPLAMA, KESME VE PAKETLEME PROGBARLARI VE ANİMASYONLARI

RegisterNetEvent('ytzdev:oduntopla')
AddEventHandler('ytzdev:oduntopla', function()

    ESX.TriggerServerCallback("ytz-checkitem", function(output)
        if output then
            TriggerEvent('mythic_progbar:client:progress', {
                name = 'jilet',
                duration = Config.zaman,
                label = 'Odun Toplanıyor...',
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
                    anim = "coke_cut_v1_coccutter",
                },
            }, function(status)
                if not status then
                    TriggerServerEvent('ytzdev:oduntopla')
                end
            end)
        elseif not output then 
            exports['mythic_notify']:DoHudText('error', 'Odun Kesmek İçin Üstünde Yeterli Yer Yok Veya Balta\'ya Sahip Değilsin', 3000)
        end
    end, "balta")
end)
    
RegisterNetEvent('ytzdev:odunkesme')
AddEventHandler('ytzdev:odunkesme', function()

    ESX.TriggerServerCallback("ytz-checkitem", function(output)
        if output then
            TriggerEvent('mythic_progbar:client:progress', {
                name = 'jilet',
                duration = Config.zaman2,
                label = 'Odun kesiliyor...',
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
                    anim = "coke_cut_v1_coccutter",
                },
            }, function(status)
                if not status then
                    TriggerServerEvent('ytzdev:odunkes')
                end
            end)
        elseif not output then 
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "'Odun'a Sahip Değilsin"})
        end
    end, "odun")
end)

RegisterNetEvent('ytzdev:odunpaketle')
AddEventHandler('ytzdev:odunpaketle', function()

    ESX.TriggerServerCallback("ytz-checkitem", function(output)
        if output then
            TriggerEvent('mythic_progbar:client:progress', {
                name = 'jilet',
                duration = Config.zaman3,
                label = 'Odun Paketleniyor...',
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "anim@amb@business@coc@coc_unpack_cut_left@",
                    anim = "coke_cut_v1_coccutter",
                },
            }, function(status)
                if not status then
                    TriggerServerEvent('ytzdev:odunpaket')
                end
            end)
        elseif not output then 
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "Kesik Odun'a Sahip Değilsin"})
        end
    end, "kesikodun")
end)

-- MARKERLAR VE E BASMA 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
		perform = false
		isInMarker = false

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Oduntoplama.x, Config.Oduntoplama.y, Config.Oduntoplama.z)

        if dist < 4.0 then
            perform = true
            DrawMarker(20, -554.18, 5372.5, 70.20, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.301, 1.3001, 1.3001, 205, 250, 200, 255, 0, 0, 0, 1, 0, 0, 0)
			isInMarker = true
            hintToDisplay('Odun Toplamak İçin ~INPUT_CONTEXT~ Tuşuna Basınız.')
            
            if IsControlJustPressed(0, 38) then
                TriggerEvent("ytzdev:oduntopla")
            end
            
            if perform then
                sleep = 10
            elseif not perform then
                sleep = 10000
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
		perform = false
		isInMarker = false

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z,  Config.Odunkesmeyeri.x,  Config.Odunkesmeyeri.y,  Config.Odunkesmeyeri.z)

        if dist < 4.0 then
            perform = true
            DrawMarker(20, -533.13, 5292.09, 74.17, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.301, 1.3001, 1.3001, 205, 250, 200, 255, 0, 0, 0, 1, 0, 0, 0)
			isInMarker = true
            hintToDisplay('Odun Kesmek İçin ~INPUT_CONTEXT~ Tuşuna Basınız.')
            
            if IsControlJustPressed(0, 38) then
                TriggerEvent("ytzdev:odunkesme")
            end
            
            if perform then
                sleep = 10
            elseif not perform then
                sleep = 10000
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
		perform = false
		isInMarker = false

        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z,  Config.Odunpaketleme.x,  Config.Odunpaketleme.y,  Config.Odunpaketleme.z)

        if dist < 4.0 then
            perform = true
			DrawMarker(20, -516.44, 5257.09, 80.65, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.301, 1.3001, 1.3001, 205, 250, 200, 255, 0, 0, 0, 1, 0, 0, 0)
			isInMarker = true
            hintToDisplay('Odun Paketlemek İçin ~INPUT_CONTEXT~ Tuşuna Basınız.')
            
            if IsControlJustPressed(0, 38) then
                TriggerEvent("ytzdev:odunpaketle")
            end
            
            if perform then
                sleep = 10
            elseif not perform then
                sleep = 10000
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Satis.x, Config.Satis.y, Config.Satis.z)
        Citizen.Wait(13)
        if dist <= 4.0 then
            hintToDisplay('Menüyü Açmak İçin ~INPUT_CONTEXT~ Tuşuna Basınız.')
            DrawMarker(23, Config.Satis.x, Config.Satis.y, Config.Satis.z, 0, 0, 0, 0, 0, 0, 1.301, 1.3001, 1.3001, 0, 205, 250, 200, 0, 0, 0, 0)
			if IsControlJustPressed(0, 38) then
				OpenSatisMenu()
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Menu.x, Config.Menu.y, Config.Menu.z)
        Citizen.Wait(13)
        if dist <= 4.0 then
            hintToDisplay('Menüyü Açmak İçin ~INPUT_CONTEXT~ Tuşuna Basınız.')
            DrawMarker(23, Config.Menu.x, Config.Menu.y, Config.Menu.z, 0, 0, 0, 0, 0, 0, 1.301, 1.3001, 1.3001, 0, 205, 250, 200, 0, 0, 0, 0)
			if IsControlJustPressed(0, 38) then
				OpenMenu()
			end
		end
    end
end)

-- ARAÇ SPAWNLAMA VE SİLME SİSTEMİ

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(sleep)
		perform = false
		isInMarker = false

		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local distance2 = GetDistanceBetweenCoords(playerCoords, -494.96, -992.99, 23.555, true)

		if (distance2 < 16) and aracalindi and IsPedInAnyVehicle(PlayerPedId(), false) then
			perform = true
			DrawMarker(2, -494.96, -992.99, 23.55, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            if distance2 < 3 then
                Citizen.Wait(8)
				isInMarker2 = true
				hintToDisplay('~g~E~s~ - Meslek Aracını Geri Ver')
			end
		end

		if IsControlJustReleased(0, 38) and isInMarker then
			AracCikart()
		elseif IsControlJustReleased(0, 38) and isInMarker2 then
			AracSil()
		end

		if perform then
			sleep = 10
		elseif not perform then
			sleep = 3000
		end

	end
end)

function AracCikart()
	local player = PlayerPedId()
	if not aracalindi then
		ESX.Game.SpawnVehicle('utillitruck3', vector3(-520.11, -1003.01, 23.39), 1.57, function(vehicle)
			local plate = 'YATZZZ' .. math.random(100, 900)
            TriggerEvent("keys:addNew", vehicle, plt)
            SetVehicleEngineOn(vehicle, true, true)
			aracalindi = true
			TaskWarpPedIntoVehicle(player, vehicle, -1)
		end)
	else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Zaten araç almışsınız!'})
	end
end

function AracSil()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local model = GetEntityModel(vehicle)
    if aracalindi and (player == driver) and model == 2132890591 then
            DeleteVehicle(vehicle)
            aracalindi = false
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Bu araç meslek aracı değil!'})
    end
end

-- MARKER VE BLİP SİSTEMİ

RegisterNetEvent("ytzdev:blipAcKapa")
AddEventHandler("ytzdev:blipAcKapa", function()
	if blip then
		pasifblip()
		blip = false
	else
		aktifblip()
		blip = true
	end
end)

function aktifblip()
	for _, info in pairs(blipac) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
		table.insert(aktifblipler, info.blip)
	end
end

function pasifblip()
	for i = 1, #aktifblipler do
		RemoveBlip(aktifblipler[i])
	end

	for i = 1, #aktifblipler do
		table.remove(aktifblipler)
	end
end

Citizen.CreateThread(function()

	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end