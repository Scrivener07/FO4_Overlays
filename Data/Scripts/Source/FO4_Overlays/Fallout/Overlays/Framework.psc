Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

Actor Player


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
	WriteLine(self, "Actor.OnItemEquipped, akBaseObject: "+akBaseObject)

	; Armor equipped = akBaseObject as Armor
	; If (equipped)
	; 	WriteLine(self, "equipped: "+equipped)
	; Else
	; 	WriteUnexpectedValue(self, "Actor.OnItemEquipped", "equipped", "akBaseObject failed to cast to an Armor type.")
	; EndIf

	; Armor item = GetWorn()
	; If (item)
	; 	WriteLine(self, "item: "+item)
	; Else
	; 	WriteUnexpectedValue(self, "Actor.OnItemEquipped", "item", "GetWorn failed to return an Armor item.")
	; EndIf

	; string modelPath = akBaseObject.GetWorldModelPath()
	; If (!StringIsNoneOrEmpty(modelPath))
	; 	WriteLine(self, "modelPath: "+modelPath)
	; Else
	; 	WriteUnexpectedValue(self, "Actor.OnItemEquipped", "modelPath", "Is none or empty.")
	; EndIf

	OverlayMenu.Open()
	OverlayMenu.SetOverlay("Armor\\Synth\\HelmetHeavyGO.png") ; testing!
	OverlayMenu.SetVisible(IsFirstPerson)

	GotoState(EquippedState)

	; Armor worn = GetWorn()
	; If (worn)
	; Else
	; 	WriteUnexpectedValue(self, "Actor.OnItemEquipped", "worn", "Is none or empty.")
	; EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	; If (GetWorn() == none)
	; 	GotoState(EmptyState)
	; EndIf
EndEvent


; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string asOldState)
		WriteLine(self, ToString()+" OnBeginState.")
		RegisterForCameraState()
		; OverlayMenu.Open()
		; OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent


	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		; This might be called too much?
		OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(self, ToString()+" OnEndState.")
		UnregisterForCameraState()
		OverlayMenu.Close()
	EndEvent
EndState


; Methods
;---------------------------------------------

Armor Function GetWorn()
	{Returns the worn item at the players "eyes" slot index.}
	int EyesIndex = 17 const
	Actor:WornItem worn = Player.GetWornItem(EyesIndex)
	If (worn)
		WriteLine(self, "Worn is "+worn)
		return worn.Item as Armor
	Else
		WriteUnexpectedValue(self, "GetWorn", "worn", "Structure is none.")
		return none
	EndIf
EndFunction


; Functions
;---------------------------------------------

string Function ToString()
	{The string representation of this type.}
	return "Framework "+GetState()
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

Group Equipped
	int Property BipedEyes = 47 AutoReadOnly
EndGroup

Group Camera
	int Property CameraFirstPerson = 0 AutoReadOnly

	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup


Armor Property Armor_Synth_Helmet_Closed Auto Const Mandatory
{Debug Only}
