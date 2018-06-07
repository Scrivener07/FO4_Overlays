Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

Actor Player
string URI

int BipedEyes = 17 const
bool ThirdPerson = false const

string EquippedState = "Equipped" const


; Events
;---------------------------------------------

Event OnInit()
	Player = Game.GetPlayer()
EndEvent


Event OnQuestInit()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


Event OnQuestShutdown()
	ClearState(self)
	UnregisterForAllEvents()
EndEvent


; Events
;---------------------------------------------

Event Actor.OnItemEquipped(Actor sender, Form akBaseObject, ObjectReference akReference)
	string value = GetURI()
	If (StringIsNoneOrEmpty(value) != true) ; do not allow a change to none/empty
		If (TryChange(value))
			ChangeState(self, EquippedState)
		EndIf
	Else
		WriteUnexpectedValue(self, "Actor.OnItemEquipped", "value", "The value cannot be none or empty.")
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent


; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string asOldState)
		WriteLine(self, "Equipped.OnBeginState")
		RegisterForCameraState()
		RegisterForMenuOpenCloseEvent(OverlayMenu.Name)
		RegisterForGameReload(self)
		OverlayMenu.Open()
	EndEvent

	;---------------------------------------------

	Event OnGameReload()
		OverlayMenu.Open()
	EndEvent

	Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
		WriteLine(self, "Equipped.OnMenuOpenCloseEvent(asMenuName="+asMenuName+", abOpening="+abOpening+")")
		If (asMenuName == OverlayMenu.Name)
			If (abOpening)
				OverlayMenu.SetURI(URI)
				OverlayMenu.SetVisible(IsFirstPerson)
			Else
				OverlayMenu.Open()
			EndIf
		EndIf
	EndEvent

	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		WriteLine(self, "Equipped.OnPlayerCameraState(aiOldState="+aiOldState+", aiNewState="+aiNewState+")")
		OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent

	;---------------------------------------------

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		WriteLine(self, "Equipped.Actor.OnItemEquipped(akBaseObject="+akBaseObject+", akReference="+akReference+")")
		Equipment()
	EndEvent

	Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		WriteLine(self, "Equipped.Actor.OnItemEquipped(akBaseObject="+akBaseObject+", akReference="+akReference+")")
		Equipment()
	EndEvent

	Function Equipment()
		string value = GetURI()
		If (TryChange(value)) ; ALLOW a change to none/empty
			If (StringIsNoneOrEmpty(value))
				ClearState(self)
			Else
				OverlayMenu.SetURI(URI)
			EndIf
		EndIf
	EndFunction

	;---------------------------------------------

	Event OnEndState(string asNewState)
		WriteLine(self, "Equipped.OnEndState")
		UnregisterForCameraState()
		UnregisterForAllMenuOpenCloseEvents()
		UnregisterForGameReload(self)
		OverlayMenu.Close()
	EndEvent
EndState


Function Equipment()
	{EMPTY}
	WriteNotImplemented(self, "Equipment", "This should only be called in the "+EquippedState+" state.")
EndFunction


; Methods
;---------------------------------------------

bool Function TryChange(string value)
	If (value != URI)
		WriteChangedValue(self, "URI", URI, value)
		URI = value
		return true
	Else
		WriteUnexpectedValue(self, "TryChange", "value", "The URI already equals '"+value+"'")
		return false
	EndIf
EndFunction


string Function GetURI()
	return Player.GetWornItem(BipedEyes, ThirdPerson).ModelName
EndFunction


; Properties
;---------------------------------------------

Group Overlay
	Overlays:Menu Property OverlayMenu Auto Const Mandatory
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

Group Equipped
	bool Property HasEquipped Hidden
		bool Function Get()
			return StringIsNoneOrEmpty(URI) != true
		EndFunction
	EndProperty
EndGroup
