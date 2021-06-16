# esx_repairkit [![Release](https://img.shields.io/badge/Release-V%203.5-blue)](https://github.com/X00LA/esx_repairkit/releases/latest)

RepairKit script for FiveM ESX servers - https://forum.cfx.re/t/fork-esx-esx-repairkit-repairkit-item-for-car/1133523  
  
Original Author: https://github.com/jonteohr/esx_repairkit  
Forked from: https://github.com/clementinise/esx_repairkit  
  
## FEATURES
* Repair Kit Item & Tyre Kit Item
* Update Checker on resource start
* More realistic since it needs you to be ~~next to the engine~~ or near the tyre to actually repair
* ~~It does not repair the visual aspect of the car, only the engine~~ (Bugged at the moment)
* Player can abort the repair by pressing "X"
* Message if players attempt to repair the car and are not in front of the tyre ~~or engine~~
* French, English, Swedish and german language included
## RepairKit & TyreKit easily configurable: 
* **Config.InfiniteRepairs & Config.InfiniteRepairsTyreKit** 
Toggle Infinite RepairKit & TyreKit (One Kit last forever)
* **Config.RepairTime & Config.TyreKitTime**
Set in seconds, how long should a repair take
* **Config.IfMecaIsOnline** 
Toggle If Mechanic is online then players can't use the kit and need to call the Mechanic to fix it
* **Config.IgnoreAbort & Config.IgnoreTyreAbort** 
Toggle Remove RepairKit & TyreKit if players abort the repair
* **Config.AllowMecano** 
Toggle if Mechanic can use the RepairKit & TyreKit
* **Config.RealisticVehicleFailure**
 If you're using [Realistic Vehicle Failure](https://forum.cfx.re/t/release-realistic-vehicle-failure/57801) then you can set it to true (Since “RealisticVehicleFailure” change how cars work, this config option allow to set the engine repair value lower than usual so the repaired vehicle is not indestructible)
* **Config.DestroyChance**
The lower it is, the more it has a chance to make the engine fail and the car explode. (1 = 100%, 2 = 50%, 4 = 25%, 10 = 10%, 100 = 1%, etc)
*If you don't want this feature, set **Config.DestroyOnFailedRepair** to false*
* **Config.EnableProgressBar**
If you don't want a progress bar when your player use the item or you don't want to use any dependencies ([progressBar](https://forum.cfx.re/t/release-progress-bars-1-0-standalone/526287)) then set it to **false**


~~Some new features will be added soon:  t̶i̶r̶e̶ ̶k̶i̶t̶,̶ ̶%̶ ̶f̶a̶i̶l̶u̶r̶e̶,  can't be used again after X times, change key for cancelling the repair in config file, etc~~
Since I'm renamed the TyreKit to Spre Wheel this feature will not come in my fork.

**KNOWN BUG :** 
* If **"Config.IfMecaIsOnline"** is set to true then **"Config.AllowMecano"** won't work

**Preview:** [Coming Soon]()

### Requirements
* [es_extended](https://github.com/ESX-Org/es_extended)
### Optional but recommended
* [progressBar](https://forum.cfx.re/t/release-progress-bars-1-0-standalone/526287)
(Don't forget to rename this resource "progressBar" or it will not work)

### Installation
Download the [latest release](https://github.com/X00LA/esx_repairkit/releases/latest) and rename the folder to esx_repairkit.

Import `esx_repairkit.sql` to your database (Take a look into the localization folders for more langauges)
Drag the folder into your `<server-data>/resources/[esx]` folder and add this to your server.cfg
```
ensure esx_repairkit
```
