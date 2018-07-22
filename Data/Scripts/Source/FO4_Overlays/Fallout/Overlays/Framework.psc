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
	If (ItemEquipped(akBaseObject))
		Equipment()
		WriteLine(self, "Actor.OnItemEquipped", "akBaseObject="+akBaseObject)
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent


; Methods
;---------------------------------------------

bool Function ItemEquipped(Form item)
	Armor armo = item as Armor
	return armo && HasSlotMask(armo, kSlotMask47)
EndFunction


bool Function Equipment()
	string value = GetURI()
	If (StringIsNoneOrEmpty(value) != true) ; do not allow a change to none/empty
		If (TryChange(value))
			return ChangeState(self, EquippedState)
		Else
			return false
		EndIf
	Else
		return false
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
		Form item = Player.GetWornItem(slot, ThirdPerson).Item
		If (ItemEquipped(item))
			return slot
		EndIf
		slot += 1
	EndWhile
	return Invalid
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


string Function GetDefault(int slot)
	{Derived from the armor model name.}
	return Player.GetWornItem(slot, ThirdPerson).ModelName
EndFunction



string Function GetWorldModel(int slot)
	return Player.GetWornItem(slot, ThirdPerson).Item.GetWorldModelPath()
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
		If (ItemEquipped(akBaseObject))
			Equipment()
			WriteLine(self, "Equipped.Actor.OnItemEquipped", "akBaseObject="+akBaseObject)
		EndIf
	EndEvent

	Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (ItemEquipped(akBaseObject))
			Equipment()
			WriteLine(self, "Equipped.Actor.OnItemEquipped", "akBaseObject="+akBaseObject)
		EndIf
	EndEvent

	bool Function Equipment()
		string value = GetURI()
		If (TryChange(value)) ; ALLOW a change to none/empty
			If (StringIsNoneOrEmpty(value))
				return ClearState(self)
			Else
				return OverlayMenu.SetURI(URI)
			EndIf
		Else
			return false
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


; Functions
;---------------------------------------------

bool Function HasSlotMask(Armor armo, int value)
	return Math.LogicalAnd(armo.GetSlotMask(), value) == value
EndFunction


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
