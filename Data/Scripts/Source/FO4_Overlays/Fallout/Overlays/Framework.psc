Scriptname Fallout:Overlays:Framework extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Client
import Fallout:Overlays:Papyrus

Actor Player
;---------------------------------------------
string File
string EquippedState = "Equipped" const
;---------------------------------------------
int Invalid = -1 const
int BipedEyes = 17 const
bool ThirdPerson = false const
;---------------------------------------------
string ExamineMenu = "ExamineMenu" const
string ScopeMenu = "ScopeMenu" const


; Events
;---------------------------------------------

Event OnQuestInit()
	Player = Game.GetPlayer()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


Event OnQuestShutdown()
	ClearState(self)
	UnregisterForAllEvents()
EndEvent


Event Actor.OnItemEquipped(Actor sender, Form baseObject, ObjectReference reference)
	If (ItemFilter(baseObject))
		WriteLine(self, "Actor.OnItemEquipped", "baseObject="+baseObject)
		Equipment()
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor sender, Form baseObject, ObjectReference reference)
	{EMPTY}
EndEvent


; Methods
;---------------------------------------------

bool Function ItemFilter(Form item)
	Armor armo = item as Armor
	return armo && HasSlotMask(armo, kSlotMask47)
EndFunction


bool Function HasSlotMask(Armor armo, int value) Global
	return Math.LogicalAnd(armo.GetSlotMask(), value) == value
EndFunction


bool Function Equipment()
	string value = GetFile()
	If (value) ; Do not allow a change to none/empty value. A none value is valid for TryChange.
		If (TryChange(value))
			return ChangeState(self, EquippedState)
		Else
			return false
		EndIf
	Else
		return false
	EndIf
EndFunction


string Function GetFile()
	{Gets the file path for any eye slot armor.}
	; #1 Check the Armor's ObjectMods for any associated loose mod with an icon path.
	; #2 Check the Armor's world model path.
	; #3 Check the Armor's model path.
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
					If (value)
						WriteLine(self, "GetFile", "LooseMod:'"+value+"'")
						return value
					EndIf
					index += 1
				EndWhile
			EndIf
			;---------------------------------------------
			value = GetWorldModel(worn)
			If (value)
				WriteLine(self, "GetFile", "WorldModel:'"+value+"'")
				return value
			Else
				value = GetModel(worn)
				WriteLine(self, "GetFile", "Model:'"+value+"'")
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
	If (value != File)
		WriteChangedValue(self, "File", File, value)
		File = value
		return true
	Else
		WriteUnexpectedValue(self, "TryChange", "value", "The File already equals '"+value+"'")
		return false
	EndIf
EndFunction


; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string oldState)
		WriteLine(self, "Equipped.OnBeginState")
		RegisterForCameraState()
		RegisterForMenuOpenCloseEvent(Menu.Name)
		RegisterForMenuOpenCloseEvent(ExamineMenu)
		RegisterForMenuOpenCloseEvent(ScopeMenu)
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
				Menu.Load(File)
				Menu.SetAlpha(Configuration.Alpha)
				Menu.SetVisible(IsFirstPerson)
			Else
				Menu.Open()
			EndIf
			OpenCloseEventArgs e = new OpenCloseEventArgs
			e.Opening = opening
			SendOpenCloseEvent(e)
		EndIf

		If (menuName == ScopeMenu)
			If (opening)
				Menu.AlphaTo(Configuration.ScopeAlpha, Configuration.AlphaSpeed)
			Else
				Menu.AlphaTo(Configuration.Alpha, Configuration.AlphaSpeed)
			EndIf
		EndIf

		If (menuName == ExamineMenu && !opening)
			Menu.Load(File)
		EndIf
	EndEvent

	Event OnPlayerCameraState(int oldState, int newState)
		WriteLine(self, "Equipped.OnPlayerCameraState(oldState="+oldState+", newState="+newState+") -- IsFirstPerson:"+IsFirstPerson)
		Menu.SetVisible(IsFirstPerson)
	EndEvent

	;---------------------------------------------

	Event Actor.OnItemEquipped(Actor sender, Form baseObject, ObjectReference reference)
		If (ItemFilter(baseObject))
			WriteLine(self, "Equipped.Actor.OnItemEquipped", "baseObject="+baseObject)
			Equipment()
		EndIf
	EndEvent

	Event Actor.OnItemUnequipped(Actor sender, Form baseObject, ObjectReference reference)
		If (ItemFilter(baseObject))
			WriteLine(self, "Equipped.Actor.OnItemUnequipped", "baseObject="+baseObject)
			Equipment()
		EndIf
	EndEvent

	bool Function Equipment()
		string value = GetFile()
		If (TryChange(value)) ; ALLOW a change to none/empty
			If (!value)
				return ClearState(self)
			Else
				return Menu.Load(File)
			EndIf
		Else
			return false
		EndIf
	EndFunction

	;---------------------------------------------

	Event OnEndState(string newState)
		WriteLine(self, "Equipped.OnEndState")
		UnregisterForCameraState()
		UnregisterForAllMenuOpenCloseEvents()
		UnregisterForGameReload(self)
		Menu.Close()
	EndEvent
EndState


; Client
;---------------------------------------------

Function SendOpenCloseEvent(OpenCloseEventArgs e)
	If (e)
		var[] arguments = new var[1]
		arguments[0] = e
		Client.SendCustomEvent("OpenCloseEvent", arguments)
	Else
		WriteUnexpectedValue(self, "SendOpenCloseEvent", "e", "The argument cannot be none.")
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Keyword Property ArmorBodyPartEyes Auto Const Mandatory
EndGroup

Group Overlay
	Overlays:Menu Property Menu Auto Const Mandatory
	Overlays:Client Property Client Auto Const Mandatory
	Overlays:Configuration Property Configuration Auto Const Mandatory
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Game.GetCameraState() == 0
		EndFunction
	EndProperty
EndGroup
