local PlayerData, GUI, CurrentActionData, JobBlips = {}, {}, {}, {}
local HasAlreadyEnteredMarker, publicBlip = false, false
local LastZone, CurrentAction, CurrentActionMsg
ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
	if zone == 'WeedFarm' then
		CurrentAction     = 'weed_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'WeedProcess' then
		CurrentAction     = 'weed_process'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone= zone}
	--end		
	elseif zone == 'WeedSell' then
		CurrentAction     = 'weed_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'OpiumFarm' then
		CurrentAction     = 'opium_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'OpiumProcess' then
		CurrentAction     = 'opium_process'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'OpiumSell' then
		CurrentAction     = 'opium_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	--end	
	elseif zone == 'CokeFarm' then
		CurrentAction     = 'coke_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'CokeProcess' then
		CurrentAction     = 'coke_process'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	--end
	elseif zone == 'CokeSell' then
		CurrentAction     = 'coke_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('esx_drugs:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	if (zone == 'WeedFarm' or zone == 'OpiumFarm' or zone == 'CokeFarm') then
		TriggerServerEvent('esx_drugs:stopFarm')
	elseif (zone == 'WeedProcess' or zone == 'OpiumProcess' or zone == 'CokeProcess') then
		TriggerServerEvent('esx_drugs:stopTransform')
	elseif (zone == 'WeedSell' or zone == 'OpiumSell' or zone == 'CokeSell') then
		TriggerServerEvent('esx_drugs:stopSell')
	end
	CurrentAction = nil
end)

-- Create Blips
--function blips()
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones)do
		if v.Type == 1 then

			local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

			SetBlipSprite (blip2, v.Sprite)
			SetBlipDisplay(blip2, 4)
			SetBlipScale  (blip2, 0.7)
			SetBlipColour (blip2, v.Cor)
			SetBlipAsShortRange(blip2, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip2)
			table.insert(JobBlips, blip2)

		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_drugs:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_drugs:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'weed_farm' or CurrentAction == 'opium_farm' or CurrentAction == 'coke_farm' then
					TriggerServerEvent('esx_drugs:startFarm', CurrentActionData.zone)
				end
				if CurrentAction == 'weed_process' or CurrentAction == 'opium_process' or CurrentAction == 'coke_process' then
					TriggerServerEvent('esx_drugs:startTransform', CurrentActionData.zone)
				end
				if CurrentAction == 'weed_sell' or CurrentAction == 'opium_sell' or CurrentAction == 'coke_sell' then
					TriggerServerEvent('esx_drugs:startSell', CurrentActionData.zone)
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)