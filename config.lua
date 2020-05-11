Config								= {}
Config.InfiniteRepairs				= false 	-- Should one repairkit last forever?
Config.InfiniteRepairsTyreKit		= false		-- Should one tyrekit last forever?
Config.IfMecaIsOnline				= false		-- Set to true if you don't want your players to use the RepairKit and TireKit if a mechanic is online
Config.RepairTime					= 15 		-- In seconds, how long should a repair take?
Config.TyreKitTime					= 20 		-- In seconds, how long does it took to replace the tyre?
Config.IgnoreAbort					= true 		-- Remove repairkit from inventory even if user aborts repairs?
Config.IgnoreTyreAbort				= false 	-- Remove repairkit from inventory even if user aborts repairs?
Config.AllowMecano					= true	 	-- Allow mechanics to use this repairkit? (If you want this to work set "Config.IfMecaIsOnline" to false, it's a known bug that will be fixed as soon as possible)
Config.RealisticVehicleFailure		= true 		-- Set to true if you are using the resource "RealisticVehicleFailure"
Config.ExplosionOnFailedRepair		= true		-- Set to true if you wan't to use "Config.ExplosionChance"
Config.ExplosionChance				= 100		-- The lower it is, the more it has a chance to make the engine fail and the car explode. (1 = 100%, 2 = 50%, 4 = 25%, 10 = 10%, 100 = 1%, etc)
Config.EnableProgressBar			= true		-- If you don't want a progress bar when your player use the item or you don't want to use the resource "progressBars" then set it to false

Config.Locale						= 'tr'
