Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays:Papyrus

Actor Player

;/ Bugs
	Loading doors causes the menu to uload itself, and not reload until after equipping again.
	Bitmaps are still not rendered correctly sometimes, affected by tinting.
/;

;/ Path Conversion
	; Male/Female world models
	; OMOD variants
/;

; Events
;---------------------------------------------

Event OnInit()
	Player = Game.GetPlayer()
EndEvent


Event OnQuestInit()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	GiveTestItems()
EndEvent


Event OnQuestShutdown()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForRemoteEvent(Player, "OnItemUnequipped")
	GotoState(EmptyState)
EndEvent


Event Actor.OnItemEquipped(Actor sender, Form akBaseObject, ObjectReference akReference)
	If (akBaseObject == Armor_Synth_Helmet_Closed)
		GotoState(EquippedState)
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	If (akBaseObject == Armor_Synth_Helmet_Closed)
		GotoState(EmptyState)
	EndIf
EndEvent



; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string asOldState)
		WriteLine(self, ToString()+" equipped.")
		RegisterForCameraState()
		OverlayMenu.Open()
		OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent

	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent

	Event OnEndState(string asNewState)
		WriteLine(self, ToString()+" unequipped.")
		UnregisterForCameraState()
		OverlayMenu.Close()
	EndEvent
EndState


; Functions
;---------------------------------------------

string Function ToString()
	{The string representation of this type.}
	return GetState()
EndFunction


Function GiveTestItems() DebugOnly
	Player.AddItem(Armor_Synth_Helmet_Closed)
	WriteLine(self, ToString()+" added "+Armor_Synth_Helmet_Closed+" for testing.")
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Overlays:Menu Property OverlayMenu Auto Const Mandatory
EndGroup

Group States
	string Property EmptyState = "" AutoReadOnly
	string Property EquippedState = "Equipped" AutoReadOnly
EndGroup

Group Camera
	int Property CameraFirstPerson = 0 AutoReadOnly

	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

Group Debugging
	Armor Property Armor_Synth_Helmet_Closed Auto Const Mandatory
	;/
		World Model: Armor\Synth\HelmetHeavyGO.nif @Meshes
	/;
EndGroup
