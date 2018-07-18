Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

;| Slot | Hexadecimal | Decimal |
;|------------------------------|
;| 30   | 0x00000001  | 1       |
;| 47   | 0x00020000  | 131072  |

Actor Player
;---------------------------------------------
string URI
string EquippedState = "Equipped" const
;---------------------------------------------
int Invalid = -1 const
int BipedEyes = 17 const
bool ThirdPerson = false const


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


Event Actor.OnItemEquipped(Actor sender, Form akBaseObject, ObjectReference akReference)
	Equipment()
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

Function Equipment()
	string value = GetURI()
	If (StringIsNoneOrEmpty(value) != true) ; do not allow a change to none/empty
		If (TryChange(value))
			ChangeState(self, EquippedState)
		EndIf
	EndIf
EndFunction


string Function GetURI()
	int slot = GetSlot()
	If (slot > Invalid)
		string value
		ObjectMod[] mods = Player.GetWornItemMods(slot)
		If (mods)
			int index = 0
			While (index < mods.Length)
				value = GetLooseMod(mods[index])
				If (!StringIsNoneOrEmpty(value))
					WriteLine(self, "GetURI", "LooseMod:'"+value+"'")
					return value
				EndIf

				; value = GetObjectMod(mods[index])
				; If (!StringIsNoneOrEmpty(value))
				; 	WriteLine(self, "GetURI", "ObjectMod:'"+value+"'")
				; 	return value
				; EndIf

				index += 1
			EndWhile
		EndIf
		;---------------------------------------------
		value = GetDefault(slot)
		WriteLine(self, "GetURI", "Default:'"+value+"'")
		return value
	Else
		return ""
	EndIf
EndFunction


int Function GetSlot()
	int slot = 0
	While (slot <= BipedEyes)
		Armor armo = Player.GetWornItem(slot, ThirdPerson).Item as Armor
		If (armo && HasSlotMask(armo, kSlotMask47))
			return slot
		EndIf
		slot += 1
	EndWhile
	return Invalid
EndFunction


bool Function HasSlotMask(Armor armo, int value)
	return Math.LogicalAnd(armo.GetSlotMask(), value) == value
EndFunction



string Function GetLooseMod(ObjectMod omod)
	{Defined by the loose mod icon path.}
	MiscObject misc = omod.GetLooseMod()
	If (misc && misc.HasKeyword(ArmorBodyPartEyes))
		return misc.GetIconPath()
	Else
		return ""
	EndIf
EndFunction


; string Function GetObjectMod(ObjectMod omod)
; 	{Derived from the object mod model path.}
; 	ObjectMod:PropertyModifier[] properties = omod.GetPropertyModifiers()
; 	If (properties)
; 		int index = properties.FindStruct("object", ArmorBodyPartEyes)
; 		If (index > Invalid)
; 			ObjectMod:PropertyModifier modifier = properties[index]
; 			bool bTarget = (modifier.Target == omod.Armor_Target_pkKeywords)
; 			bool bOperator = (modifier.Operator == omod.Modifier_Operator_Add)
; 			If (bTarget && bOperator)
; 				return omod.GetWorldModelPath()
; 			Else
; 				return ""
; 			EndIf
; 		Else
; 			return ""
; 		EndIf
; 	Else
; 		return ""
; 	EndIf
; EndFunction


string Function GetDefault(int slot)
	{Derived from the armor model name.}
	return Player.GetWornItem(slot, ThirdPerson).ModelName
EndFunction


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
		WriteLine(self, "Equipped.OnGameReload")
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


; Properties
;---------------------------------------------

Group Properties
	Keyword Property ArmorBodyPartEyes Auto Const Mandatory
EndGroup

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

; Group Equipped
; 	bool Property HasEquipped Hidden
; 		bool Function Get()
; 			return StringIsNoneOrEmpty(URI) != true
; 		EndFunction
; 	EndProperty
; EndGroup
