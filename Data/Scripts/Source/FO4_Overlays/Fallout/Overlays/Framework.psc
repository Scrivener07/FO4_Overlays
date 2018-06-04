Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

Actor Player

;/ Overlays /;
string URI
float AlphaLow = 0.50 const


;/ Equipped /;
string EquippedState = "Equipped" const

; Biped Slot
int BipedEyes = 17 const

; Worn
bool FirstPerson = true const
bool ThirdPerson = false const

; Menus
string PipboyMenu = "PipboyMenu" const
string ConsoleMenu = "Console" const
string LoadingMenu = "LoadingMenu" const

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
	If (StringIsNoneOrEmpty(value) != true)
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
		RegisterForMenuOpenCloseEvent(PipboyMenu)
		RegisterForMenuOpenCloseEvent(ConsoleMenu)
		RegisterForMenuOpenCloseEvent(LoadingMenu)
		OverlayMenu.Open()
	EndEvent

	;---------------------------------------------

	Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
		WriteLine(self, "Equipped.OnMenuOpenCloseEvent(asMenuName="+asMenuName+", abOpening="+abOpening+")")
		If (asMenuName == OverlayMenu.Name)
			If (abOpening)
				OverlayMenu.SetURI(URI)
				OverlayMenu.SetVisible(IsFirstPerson)
			EndIf
		EndIf
	EndEvent

	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		WriteLine(self, "Equipped.OnPlayerCameraState(aiOldState="+aiOldState+", aiNewState="+aiNewState+")")
		OverlayMenu.SetVisible(IsFirstPerson)
	EndEvent

	;---------------------------------------------

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		EquipmentHandler()
	EndEvent

	Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		EquipmentHandler()
	EndEvent

	Function EquipmentHandler()
		string value = GetURI()
		If (TryChange(value))
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
		OverlayMenu.Close()
	EndEvent
EndState


Function EquipmentHandler()
	{EMPTY}
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
	string value = Player.GetWornItem(BipedEyes, ThirdPerson).ModelName
	WriteLine(self, "GetURI::value:"+value)
	return value
EndFunction


; Properties
;---------------------------------------------

Group Overlay
	Overlays:Menu Property OverlayMenu Auto Const Mandatory
EndGroup

Group Camera
	int Property CameraFirstPerson = 0 AutoReadOnly

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
