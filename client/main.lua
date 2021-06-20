local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  ESX						= nil
  local CurrentAction		= nil
  local isReparing 		= false
  local IsMechanicOnline	= false
  local PlayerData		= {}
  
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
  end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
	  PlayerData = xPlayer
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
  end)
  
  RegisterNetEvent('jobonline:set')
  AddEventHandler('jobonline:set', function(jobs_online)
  
	  jobs = jobs_online
  
	  if jobs_online['mechanic'] > 0 and Config.IfMechanicIsOnline then
		  IsMechanicOnline = true
	  else 
		  IsMechanicOnline = false
	  end
  end)
  
  
  Citizen.CreateThread(function()
	  while true do
		  TriggerServerEvent('jobonline:get')
  
		  Wait(10000)
	  end
  end)
  
  RegisterNetEvent('esx_repairkit:onUse')
  AddEventHandler('esx_repairkit:onUse', function()
	  local playerPed		= GetPlayerPed(-1)
	  local coords		= GetEntityCoords(playerPed)
	  local coordsE = GetWorldPositionOfEntityBone(vehicle, engine)
  
	  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		  local vehicle = nil
		  if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			  ESX.ShowNotification(_U('no_vehicle_nearby'))
		  elseif GetVehicleEngineHealth(vehicle) == 0 then
			  ESX.ShowNotification(_U('car_dead'))
		  end
  
		  if IsPedInAnyVehicle(playerPed, false) then
			  vehicle = GetVehiclePedIsIn(playerPed, false)
		  else
			  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		  end
  
		  if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) and IsPedOnFoot(playerPed) and GetVehicleEngineHealth(vehicle) ~= 0 and not IsMechanicOnline then
			  local engine = GetEntityBoneIndexByName(vehicle, 'engine')
			  if engine ~= -1 and Config.IgnoreAbort then
				  if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordsE, true) <= 3.0 then 
						SetVehicleDoorOpen(vehicle, 4, false, false)
					  	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
				  end
			  end
			  Citizen.CreateThread(function()
				  ThreadID = GetIdOfThisThread()
				  CurrentAction = 'repair'
				  isReparing = not isReparing
				  SetTextComponentFormat('STRING')
				  AddTextComponentString(_U('abort_hint'))
				  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				  if Config.EnableProgressBar then
				  exports['progressBars']:startUI(Config.RepairTime * 1000, _U('ReparingEngine'))
				  else				
				  Citizen.Wait(Config.RepairTime * 1000)
				  end
				  local destroychance = math.random(1, Config.DestroyChance)
				  if CurrentAction ~= nil then
					Citizen.Wait(Config.RepairTime * 1000)
					  SetVehicleDoorShut(vehicle, 4, false)
					  SetVehicleEngineOn(vehicle,false,false,false)
					  ClearPedTasksImmediately(playerPed)
					  TriggerServerEvent('esx_repairkit:removeKit')
				  end
				  if Config.RealisticVehicleFailure then
					  SetVehicleUndriveable(vehicle,false)
					  SetVehicleFixed(vehicle)
					  healthEngineLast=600.0
					  SetVehicleEngineOn(vehicle,false,false,false)
				  else
					  SetVehicleUndriveable(vehicle,false)
					  SetVehicleFixed(vehicle)
					  healthEngineLast=600.0
					  SetVehicleEngineOn(vehicle,false,false,false)
				  end
				  if isReparing then
					  isReparing = not isReparing
				  end
				  if destroychance == 1 and Config.DestroyOnFailedRepair then
					  ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
					  PlaySoundFromCoord(-1, "Jet_Explosions", coordsE.x, coordsE.y, coordsE.z, "exile_1", 0, 0, 0)
					  ESX.ShowNotification(_U('car_destroy'))
					  ClearPedTasksImmediately(playerPed)
					  SetVehicleEngineHealth(vehicle, 0)
					  Wait(4000)
				  else
					  ESX.ShowNotification(_U('finished_repair'))
				  end
  
				  CurrentAction = nil
				  TerminateThisThread()
			  end)
  
			  Citizen.CreateThread(function()
				  while true do
				  Citizen.Wait(0)
					  if IsControlJustPressed(0, Keys["X"]) and isReparing then
						  destroychance = 2
						  ClearPedTasksImmediately(playerPed)
						  SetVehicleDoorShut(vehicle, 4,0,0)
						  TerminateThread(ThreadID)
						  if Config.EnableProgressBar then
						  exports['progressBars']:startUI(300, _U('Cancelling'))
						  else
						  end
						  ESX.ShowNotification(_U('aborted_repair'))
						  isReparing = not isReparing
						  CurrentAction = nil
						  if Config.IgnoreAbort then
							  TriggerServerEvent('esx_repairkit:removeKit')
						  end
					  end
				  end
			  end)
		  end
	  end
  end)
  
  function GetClosestVehicleTire(vehicle)
	  local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	  local tireIndex = {["wheel_lf"] = 0, ["wheel_rf"] = 1, ["wheel_lm1"] = 2, ["wheel_rm1"] = 3, ["wheel_lm2"] = 45,["wheel_rm2"] = 47, ["wheel_lm3"] = 46, ["wheel_rm3"] = 48, ["wheel_lr"] = 4, ["wheel_rr"] = 5,}
	  local player = PlayerId()
	  local plyPed = GetPlayerPed(player)
	  local plyPos = GetEntityCoords(plyPed, false)
	  local minDistance = 1.0
	  local closestTire = nil
	  
	  for a = 1, #tireBones do
		  local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		  local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)
  
		  if closestTire == nil then
			  if distance <= minDistance then
				  closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			  end
		  else
			  if distance < closestTire.boneDist then
				  closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			  end
		  end
	  end
  
	  return closestTire
  end
  
  
  RegisterNetEvent('tyrekit:onUse')
  AddEventHandler('tyrekit:onUse', function()
	  local playerPed		= GetPlayerPed(-1)
	  local coords		= GetEntityCoords(playerPed)
	  local closestTire 	= GetClosestVehicleTire(vehicle)
	  
	  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) and closestTire == nil then
		  local vehicle = nil
			  ESX.ShowNotification(_U('not_near_tyre'))
		  elseif IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		  else
			  ESX.ShowNotification(_U('no_vehicle_nearby'))
		  end	
  
		  if IsPedInAnyVehicle(playerPed, false) then
			  vehicle = GetVehiclePedIsIn(playerPed, false)
		  else
			  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		  end
  
		  if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle, -1) and IsPedOnFoot(playerPed) and closestTire ~= nil and not IsMechanicOnline 
		  then
			  TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
  
			  Citizen.CreateThread(function()
				  ThreadID2 = GetIdOfThisThread()
				  CurrentAction = 'repair'
				  isReparing = not isReparing
				  SetTextComponentFormat('STRING')
				  AddTextComponentString(_U('abort_hint'))
				  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				  if Config.EnableProgressBar then
				  exports['progressBars']:startUI(Config.TyreKitTime * 1000, _U('ReparingTyre'))
				  else
				  end
				  Citizen.Wait(Config.TyreKitTime * 1000)
				  
				  if CurrentAction ~= nil then
					  SetVehicleTyreFixed(vehicle, closestTire.tireIndex)
					  SetVehicleWheelHealth(vehicle, closestTire.tireIndex, 100)
					  ClearPedTasks(playerPed)
					  TriggerServerEvent('esx_repairkit:removeTyreKit')
					  ESX.ShowNotification(_U('finished_tyre_repair'))
				  if isReparing then
					  isReparing = not isReparing
				  end
  
				  CurrentAction = nil
				  TerminateThisThread()
			  end
		  end)
  
		  Citizen.CreateThread(function()
			  while true do
			  Citizen.Wait(0)
			  if IsControlJustPressed(0, Keys["X"]) and isReparing then
				  ClearPedTasksImmediately(playerPed)
				  TerminateThread(ThreadID2)
				  if Config.EnableProgressBar then
				  exports['progressBars']:startUI(300, _U('Cancelling'))
				  else
				  end
				  ESX.ShowNotification(_U('aborted_tyre_repair'))
				  isReparing = not isReparing
				  CurrentAction = nil
				  if Config.IgnoreTyreAbort then
					  TriggerServerEvent('esx_repairkit:removeTyreKit')
				  end
			  end
		  end
	  end)
  end
  end)