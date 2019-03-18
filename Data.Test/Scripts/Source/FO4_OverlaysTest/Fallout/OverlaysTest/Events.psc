Scriptname Fallout:OverlaysTest:Events extends Fallout:Overlays:Type DebugOnly
import Fallout:Overlays:Papyrus

Actor Player

; Events
;---------------------------------------------

Event OnQuestInit()
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnSit")
	; RegisterForRemoteEvent(Player, "OnGetUp")
	RegisterForRemoteEvent(Player, "OnPlayerEnterVertibird")
	RegisterForRemoteEvent(Player, "OnRaceSwitchComplete")
	RegisterForRemoteEvent(Player, "OnPlayerUseWorkBench")
	RegisterForRemoteEvent(Player, "OnPlayerModArmorWeapon")
	WriteLine(self, "Registered for remote test events.")
EndEvent


Event Actor.OnSit(Actor akSender, ObjectReference akFurniture)
	WriteLine(self, "Actor.OnSit", "akSender:"+akSender+", akFurniture:"+akFurniture)
EndEvent


; Event Actor.OnGetUp(Actor akSender, ObjectReference akFurniture)
; 	WriteLine(self, "Actor.OnGetUp",  "akSender:"+akSender+", akFurniture:"+akFurniture)
; EndEvent


Event Actor.OnPlayerEnterVertibird(Actor akSender, ObjectReference akVertibird)
	WriteLine(self, "Actor.OnPlayerEnterVertibird",  "akSender:"+akSender+", akVertibird:"+akVertibird)
EndEvent


Event Actor.OnRaceSwitchComplete(Actor akSender)
	WriteLine(self, "Actor.OnRaceSwitchComplete",  "akSender:"+akSender)
EndEvent


Event Actor.OnPlayerUseWorkBench(Actor akSender, ObjectReference akWorkBench)
	WriteLine(self, "Actor.OnPlayerUseWorkBench",  "akSender:"+akSender+", akWorkBench:"+akWorkBench)
EndEvent


Event Actor.OnPlayerModArmorWeapon(Actor akSender, Form akBaseObject, ObjectMod akModBaseObject)
	WriteLine(self, "Actor.OnPlayerModArmorWeapon",  "akSender:"+akSender+", akBaseObject:"+akBaseObject+", akModBaseObject:"+akModBaseObject)
EndEvent
