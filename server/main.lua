ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Update Checker
local CurrentVersion = '3.5' -- Do Not Change This Value

PerformHttpRequest('https://raw.githubusercontent.com/X00LA/esx_repairkit/master/version', function(Error, NewestVersion, Header)
		print('\n')
		print('########################')
		print('## RepairKit Resource')
		print('##')
		print('## Current Version: ' .. CurrentVersion)
		print('## Newest Version: ' .. NewestVersion)
		print('##')
		if CurrentVersion == NewestVersion then
			print('## Up to date!')
			print('########################')
		else
			print('## Outdated')
			print('## Please check the GitHub and download the last update')
			print('## https://github.com/clementinise/esx_repairkit/releases/latest')
			print('########################')
		end
		print('\n')
end)

-- Make the kit usable!
ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if Config.AllowMecano then
		TriggerClientEvent('esx_repairkit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mecano' then
			TriggerClientEvent('esx_repairkit:onUse', _source)
		end
	end
end)

ESX.RegisterUsableItem('tyrekit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if Config.AllowMecano then
		TriggerClientEvent('tyrekit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mecano' then
			TriggerClientEvent('tyrekit:onUse', _source)
		end
	end
end)

RegisterNetEvent('esx_repairkit:removeTyreKit')
AddEventHandler('esx_repairkit:removeTyreKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not Config.InfiniteRepairsTyreKit then
		xPlayer.removeInventoryItem('tyrekit', 1)
		TriggerClientEvent(_U('used_tyrekit'))
	end
end)

RegisterNetEvent('esx_repairkit:removeKit')
AddEventHandler('esx_repairkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not Config.InfiniteRepairs then
		xPlayer.removeInventoryItem('repairkit', 1)
		TriggerClientEvent(_U('used_kit'))
	end
end)

function MecanoOnline()

	local xPlayers = ESX.GetPlayers()

	MechanicConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'mecano' then
			MechanicConnected = MechanicConnected + 1
		end
	end

	SetTimeout(10000, MecanoOnline)

end

MecanoOnline()

RegisterServerEvent('jobonline:get')
AddEventHandler('jobonline:get', function()
	local counted = {}

	counted['mecano'] = MechanicConnected

	TriggerClientEvent('jobonline:set', source, counted)
end)
