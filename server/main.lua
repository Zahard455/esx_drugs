ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "WeedFarm" then
			local itemQuantity = xPlayer.getInventoryItem('weed').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('weed', 1)
					Harvest(source, zone)
				end)
			end
		end

		if zone == "OpiumFarm" then
			local itemQuantity = xPlayer.getInventoryItem('opium').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('opium', 1)
					Harvest(source, zone)
				end)
			end
		end

		if zone == "CokeFarm" then
			local itemQuantity = xPlayer.getInventoryItem('coke').count
			print(itemQuantity)
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('coke', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_drugs:startFarm')
AddEventHandler('esx_drugs:startFarm', function(zone)
	local _source = source
	PlayersHarvesting[_source] = true
	Harvest(_source,zone)
	TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
  	
	--if PlayersHarvesting[_source] == false then
	--	TriggerClientEvent('esx:showNotification', _source, '~r~Cuidado!!~w~')
	--	PlayersHarvesting[_source]=false
	--else
	--	PlayersHarvesting[_source] = true
	--	TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
	--	Harvest(_source,zone)
	--end
end)

RegisterServerEvent('esx_drugs:stopFarm')
AddEventHandler('esx_drugs:stopFarm', function()
	local _source = source
	PlayersHarvesting[_source] = false
	TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
	
	--if PlayersHarvesting[_source] == true then
	--	PlayersHarvesting[_source] = false
	--	TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
	--else
	--	TriggerClientEvent('esx:showNotification', _source, 'Podes voltar a ~g~colher')
	--	PlayersHarvesting[_source]=true
	--end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "WeedProcess" then
			local itemQuantity = xPlayer.getInventoryItem('weed').count
			local itemBag = xPlayer.getInventoryItem('plastic_bag').count

			print(itemBag)

			if itemQuantity <= 0 or itemBag <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('weed', 1)
					xPlayer.removeInventoryItem('plastic_bag', 1)
					xPlayer.addInventoryItem('weed_pooch', 1)
				
					Transform(source, zone)
				end)
			end
		end

		if zone == "OpiumProcess" then
			local itemQuantity = xPlayer.getInventoryItem('opium').count
			local itemBag = xPlayer.getInventoryItem('plastic_bag').count
			
			if itemQuantity <= 0 and itemBag <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('opium', 1)
					xPlayer.removeInventoryItem('plastic_bag', 1)
					xPlayer.addInventoryItem('opium_pooch', 1)
				
					Transform(source, zone)
				end)
			end
		end

		if zone == "CokeProcess" then
			local itemQuantity = xPlayer.getInventoryItem('coke').count
			local itemBag = xPlayer.getInventoryItem('plastic_bag').count

			if itemQuantity <= 0 and itemBag <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('coke', 1)
					xPlayer.removeInventoryItem('plastic_bag', 1)
					xPlayer.addInventoryItem('coke_pooch', 1)
				
					Transform(source, zone)
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_drugs:startTransform')
AddEventHandler('esx_drugs:startTransform', function(zone)
	local _source = source
	PlayersTransforming[_source] = true
	Transform(_source,zone)
	TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 

	--if PlayersTransforming[_source] == false then
		--TriggerClientEvent('esx:showNotification', _source, '~r~Cuidado!!~w~')
		--PlayersTransforming[_source]=false
	--else
	--	PlayersTransforming[_source]=true
	--	TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
	--	Transform(_source,zone)
	--end
end)

RegisterServerEvent('esx_drugs:stopTransform')
AddEventHandler('esx_drugs:stopTransform', function()
	local _source = source
	PlayersTransforming[_source] = false
	TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
	
	--if PlayersTransforming[_source] == true then
		--PlayersTransforming[_source] = false
		--TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
		
	--else
	--	TriggerClientEvent('esx:showNotification', _source, 'Estás a ~g~empacotar o material')
	--	PlayersTransforming[_source]=true
	--end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'WeedSell' then
			if xPlayer.getInventoryItem('weed_pooch').count <= 0 then
				weed = 0
			else
				weed = 1
			end
		
			if weed == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('no_product_sale'))
				return
			else
				SetTimeout(1100, function()
					local money = math.random(30,35)
					xPlayer.removeInventoryItem('weed_pooch', 1)
					xPlayer.addAccountMoney('black_money', money)
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Recebeu '..money..'$')
					Sell(source,zone)
				end)
			end
		elseif zone == "OpiumSell" then
			if xPlayer.getInventoryItem('opium_pooch').count <= 0 then
				opium = 0
			else
				opium = 1
			end

			if opium == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('no_product_sale'))
				return
			else
				SetTimeout(1100, function()
					local money = math.random(30,35)
					xPlayer.removeInventoryItem('opium_pooch', 1)
					xPlayer.addAccountMoney('black_money', money)
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Recebeu '..money..'$')
					Sell(source,zone)
				end)
			end
		elseif zone == "CokeSell" then
			if xPlayer.getInventoryItem('coke_pooch').count <= 0 then
				coke = 0
			else
				coke = 1
			end

			if coke == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('no_product_sale'))
				return
			else
				SetTimeout(1100, function()
					local money = math.random(30,35)
					xPlayer.removeInventoryItem('coke_pooch', 1)
					xPlayer.addAccountMoney('black_money', money)
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Recebeu '..money..'$')
					Sell(source,zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_drugs:startSell')
AddEventHandler('esx_drugs:startSell', function(zone)
	local _source = source
	PlayersSelling[_source] = true
	Sell(_source, zone)
	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	--if PlayersSelling[_source] == false then
	--	TriggerClientEvent('esx:showNotification', _source, '~r~Cuidado!!~w~')
	--	PlayersSelling[_source]=false
	--else
	--	PlayersSelling[_source]=true
	--	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
	--	Sell(_source, zone)
	--end
end)

RegisterServerEvent('esx_drugs:stopSell')
AddEventHandler('esx_drugs:stopSell', function()
	local _source = source
	PlayersSelling[_source] = false
	TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
	
	--if PlayersSelling[_source] == true then
	--	PlayersSelling[_source]=false
	--	TriggerClientEvent('esx:showNotification', _source, 'Saiste da ~r~zona')
		
	--else
	--	TriggerClientEvent('esx:showNotification', _source, 'Já podes ~g~vender')
	--	PlayersSelling[_source]=true
	--end
end)

-- Usable Items

ESX.RegisterUsableItem('jus_raisin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jus_raisin', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_jus'))
end)

ESX.RegisterUsableItem('grand_cru', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('grand_cru', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_grand_cru'))
end)
