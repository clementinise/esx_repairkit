ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Update Checker
local CurrentVersion = '3.6' -- Do Not Change This Value

PerformHttpRequest('https://raw.githubusercontent.com/X00LA/esx_repairkit/master/version', function(Error, NewestVersion, Header)
			print('\n')
			print('^8-------------------------------------------------------')
			print('^5ESX ^2RepairKit')
			print(' ')
			print('^5Current Version: ^0' .. CurrentVersion)
			print('^5Newest Version: ^0' .. NewestVersion)
			print('^5Changelog: ')
			print('^0- Fixed \'Not near engine\' error and make repairkit usable again.')
			print('^0- Updated sql for compatibility with ESX 1.2+.')
			print('^0- Added german language.')
			print('^0- Renamed Tyrekit to spare wheel. (makes more sense)')
			print('^0- Fixed outdated \'Mecano\' calls to actual \'Mechanic\'. (Doesnt fix problem with mechanics using repairkit.)')
			print(' ')
		if CurrentVersion == NewestVersion then
			print('^2 You are up to date!')
			print('^8-------------------------------------------------------')
		else
			print('^1 Your version of ^5ESX ^2Repairkit ^1is Outdated!')
			print('^0 Please check the GitHub and download the last update')
			print('^0 https://github.com/X00LA/esx_repairkit/releases/latest')
			print('^8-------------------------------------------------------')
		end
		print('\n')
end)

-- Make the kit usable!
ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if Config.AllowMechanic then
		TriggerClientEvent('esx_repairkit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mechanic' then
			TriggerClientEvent('esx_repairkit:onUse', _source)
		end
	end
end)

ESX.RegisterUsableItem('tyrekit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if Config.AllowMechanic then
		TriggerClientEvent('tyrekit:onUse', _source)
	else
		if xPlayer.job.name ~= 'mechanic' then
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

function MechanicOnline()

	local xPlayers = ESX.GetPlayers()

	MechanicConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'mechanic' then
			MechanicConnected = MechanicConnected + 1
		end
	end

	SetTimeout(10000, MechanicOnline)

end

MechanicOnline()

RegisterServerEvent('jobonline:get')
AddEventHandler('jobonline:get', function()
	local counted = {}

	counted['mechanic'] = MechanicConnected

	TriggerClientEvent('jobonline:set', source, counted)
end)
