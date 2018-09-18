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
	If (ItemFilter(akBaseObject))
		WriteLine(self, "Actor.OnItemEquipped", "akBaseObject="+akBaseObject)
		Equipment()
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent


; Methods
;---------------------------------------------

bool Function ItemFilter(Form item)
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
	int slot = 0
	While (slot <= BipedEyes)
		Actor:WornItem worn = Player.GetWornItem(slot, ThirdPerson)
		If (ItemFilter(worn.Item))
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
			value = GetWorldModel(worn)
			If (!StringIsNoneOrEmpty(value))
				WriteLine(self, "GetURI", "WorldModel:'"+value+"'")
				return value
			Else
				value = GetModel(worn)
				WriteLine(self, "GetURI", "Model:'"+value+"'")
				return value
			EndIf
		EndIf
		slot += 1
	EndWhile
	return ""
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


; TODO: The F4SE function GetWorldModelPath does not seem to work on Armor forms.
string Function GetWorldModel(Actor:WornItem worn)
	{Derived from the armor world model path.}
	Armor armo = worn.Item as Armor
	If (armo && armo.HasWorldModel())
		return armo.GetWorldModelPath()
	Else
		return ""
	EndIf
EndFunction


string Function GetModel(Actor:WornItem worn)
	{Derived from the armor model name.}
	return worn.ModelName
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



; Client API
;---------------------------------------------

; UNUSED
Armor Property Equipped Hidden
	{Returns the equipped eyes item. This may be performance heavy?}
	Armor Function Get()
		return GetWorn().Item as Armor
	EndFunction
EndProperty


; UNUSED
Actor:WornItem Function GetWorn()
	{Scans down the the highest slot of an eye slot item.}
	int slot = 0
	While (slot <= BipedEyes)
		Actor:WornItem worn = Player.GetWornItem(slot, ThirdPerson)
		If (ItemFilter(worn.Item))
			return worn
		EndIf
		slot += 1
	EndWhile
	WriteUnexpectedValue(self, "GetWorn", "value", "No biped slot has a valid eyes item.")
	return none
EndFunction

;---------------------------------------------

string Function GetMember(string member)
	{Provides instance member paths the client.}
	If (member)
		return Menu.GetClientMember(member)
	Else
		WriteUnexpectedValue(self, "GetMember", "member", "The value cannot be none or empty.")
		return ""
	EndIf
EndFunction


var Function Get(string menuName, string member)
	return UI.Get(Menu.Name, member)
EndFunction


bool Function Set(string member, var argument)
	return UI.Set(Menu.Name, member, argument)
EndFunction


var Function Invoke(string member, var[] arguments = none)
	return UI.Invoke(Menu.Name, member, arguments)
EndFunction


; Functions
;---------------------------------------------

bool Function HasSlotMask(Armor armo, int value)
	return Math.LogicalAnd(armo.GetSlotMask(), value) == value
EndFunction


; Globals
;---------------------------------------------

Overlays:Framework Function OverlayFramework() Global
	return Game.GetFormFromFile(0x00000F99, "Overlays.esp") as Overlays:Framework
EndFunction


; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string asOldState)
		WriteLine(self, "Equipped.OnBeginState")
		RegisterForCameraState()
		RegisterForMenuOpenCloseEvent(Menu.Name)
		RegisterForGameReload(self)
		Menu.Open()
	EndEvent

	;---------------------------------------------

	Event OnGameReload()
		WriteLine(self, "Equipped.OnGameReload")
		Menu.Open()
	EndEvent

	Event OnMenuOpenCloseEvent(string menuName, bool opening)
		WriteLine(self, "Equipped.OnMenuOpenCloseEvent(menuName="+menuName+", opening="+opening+")")
		If (menuName == Menu.Name)
			If (opening)
				Menu.SetURI(URI)
				Menu.SetAlpha(Fallout_Overlays_Alpha.GetValue())
				Menu.SetVisible(IsFirstPerson)
			Else
				Menu.Open()
			EndIf

			OpenCloseEventArgs e = new OpenCloseEventArgs
			e.Opening = opening
			self.SendOpenCloseEvent(e)
		EndIf
	EndEvent

	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		WriteLine(self, "Equipped.OnPlayerCameraState(aiOldState="+aiOldState+", aiNewState="+aiNewState+")")
		Menu.SetVisible(IsFirstPerson)
	EndEvent

	;---------------------------------------------

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (ItemFilter(akBaseObject))
			WriteLine(self, "Equipped.Actor.OnItemEquipped", "akBaseObject="+akBaseObject)
			Equipment()
		EndIf
	EndEvent

	Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (ItemFilter(akBaseObject))
			WriteLine(self, "Equipped.Actor.OnItemUnequipped", "akBaseObject="+akBaseObject)
			Equipment()
		EndIf
	EndEvent

	bool Function Equipment()
		string value = GetURI()
		If (TryChange(value)) ; ALLOW a change to none/empty
			If (StringIsNoneOrEmpty(value))
				return ClearState(self)
			Else
				return Menu.SetURI(URI)
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
		Menu.Close()
	EndEvent
EndState


; Open/Close Event
;---------------------------------------------

CustomEvent OpenCloseEvent

Struct OpenCloseEventArgs
	bool Opening = false
EndStruct


Function SendOpenCloseEvent(OpenCloseEventArgs e)
	If (e)
		var[] arguments = new var[1]
		arguments[0] = e
		self.SendCustomEvent("OpenCloseEvent", arguments)
	Else
		WriteLine(self, "SendOpenCloseEvent : e : Cannot be none.")
	EndIf
EndFunction


bool Function RegisterForOpenCloseEvent(ScriptObject script)
	If (script)
		script.RegisterForCustomEvent(self, "OpenCloseEvent")
		return true
	Else
		WriteLine(self, "RegisterForOpenCloseEvent : script : Cannot register a none script for events.")
		return false
	EndIf
EndFunction


bool Function UnregisterForOpenCloseEvent(ScriptObject script)
	If (script)
		script.UnregisterForCustomEvent(self, "OpenCloseEvent")
		return true
	Else
		WriteLine(self, "UnregisterForOpenCloseEvent : script : Cannot unregister a none script for events.")
		return false
	EndIf
EndFunction


OpenCloseEventArgs Function GetOpenCloseEventArgs(var[] arguments)
	If (arguments)
		return arguments[0] as OpenCloseEventArgs
	Else
		return none
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Keyword Property ArmorBodyPartEyes Auto Const Mandatory
	GlobalVariable Property Fallout_Overlays_Alpha Auto Const Mandatory
EndGroup

Group Overlay
	Overlays:Menu Property Menu Auto Const Mandatory
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup
