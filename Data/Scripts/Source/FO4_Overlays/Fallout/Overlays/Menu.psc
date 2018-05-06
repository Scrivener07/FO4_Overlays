Scriptname Fallout:Overlays:Menu extends Fallout:Overlays:Type
import Fallout:Overlays:Papyrus


; Events
;---------------------------------------------

Event OnQuestInit()
	OnGameReload()
	RegisterForGameReload(self)
EndEvent


Event OnGameReload()
	UI:MenuData data = new UI:MenuData
	data.MenuFlags = FlagNone
	; data.MovieFlags = 0
	data.ExtendedFlags = 0
	data.Depth = -1000 ; halp me lol

	If (UI.RegisterCustomMenu(Name, Path, Instance, data))
		WriteLine(self, ToString()+" has registered as a custom menu.")
	Else
		WriteUnexpected(self, "OnGameReload", ToString()+" failed to register as a custom menu.")
	EndIf
EndEvent


; Methods
;---------------------------------------------

bool Function Open()
	If (UI.IsMenuRegistered(Name))
		return UI.OpenMenu(Name)
	Else
		WriteUnexpected(self, "Open", ToString()+" is not registered.")
		return false
	EndIf
EndFunction


bool Function Close()
	If (UI.IsMenuRegistered(Name))
		return UI.CloseMenu(Name)
	Else
		WriteUnexpected(self, "Close", ToString()+" is not registered.")
		return false
	EndIf
EndFunction


bool Function GetVisible()
	If (UI.IsMenuOpen(Name))
		return UI.Get(Name, GetMember("Visible")) as bool
	Else
		WriteUnexpected(self, "GetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


bool Function SetVisible(bool value)
	If (UI.IsMenuOpen(Name))
		WriteLine(self, ToString()+" setting visible to "+value)
		return UI.Set(Name, GetMember("Visible"), value)
	Else
		WriteUnexpected(self, "SetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


; Functions
;---------------------------------------------

string Function GetMember(string member)
	{Returns the full AS3 instance path for the given member name.}
	If (StringIsNoneOrEmpty(member))
		WriteUnexpectedValue(self, "GetMember", "member", "Cannot operate on a none or empty member.")
		return none
	ElseIf (StringIsNoneOrEmpty(Instance))
		WriteUnexpected(self, "GetMember", "Cannot operate on a none or empty instance path.")
		return none
	Else
		return Instance+"."+member
	EndIf
EndFunction


string Function ToString()
	{The string representation of this type.}
	return "[Name:"+Name+", Path:"+Path+", Instance:"+Instance+"]"
EndFunction


; Properties
;---------------------------------------------

Group Properties
	string Property Name Hidden
		string Function Get()
			{The name of this menu.}
			return "OverlayMenu"
		EndFunction
	EndProperty

	string Property Path Hidden
		string Function Get()
			{The swf file path of this menu without the file extension. The root directory is "Data\Interface".}
			return "OverlayMenu"
		EndFunction
	EndProperty

	string Property Root Hidden
		string Function Get()
			{The root display object of this menu.}
			return "root1"
		EndFunction
	EndProperty

	string Property Instance Hidden
		string Function Get()
			{The root instance path of this menu.}
			return Root+".Menu"
		EndFunction
	EndProperty

	bool Property IsOpen Hidden
		bool Function Get()
			{Returns true if this menu is open.}
			return UI.IsMenuOpen(Name)
		EndFunction
	EndProperty
EndGroup

Group MenuFlags
	int Property FlagNone = 0x0 AutoReadOnly
	int Property FlagPauseGame = 0x01 AutoReadOnly
	int Property FlagShowCursor = 0x04 AutoReadOnly
	int Property FlagEnableMenuControl = 0x08 AutoReadOnly
EndGroup

Group ExtendedFlags
	; If you set extendedFlags & 2, it will disable your ShowCursor if the Gamepad is enabled
	int Property FlagInheritColors = 1 AutoReadOnly
	int Property FlagCheckForGamepad = 2 AutoReadOnly
EndGroup
