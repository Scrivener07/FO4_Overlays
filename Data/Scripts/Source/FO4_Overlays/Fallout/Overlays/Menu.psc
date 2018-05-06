Scriptname HaloHelmet:Menu extends HaloHelmet:MenuType Hidden
import HaloHelmet:Log

DisplayData Display


; Events
;---------------------------------------------

Event OnQuestInit()
	OnGameReload()
	RegisterForGameReload(self)
EndEvent


Event OnGameReload()
	Display = NewDisplay()

	UI:MenuData data = new UI:MenuData
	data.MenuFlags = FlagNone
	; data.MovieFlags = 0
	data.ExtendedFlags = 0
	data.Depth = -1000 ; halp me lol

	If (UI.RegisterCustomMenu(Display.Menu, Display.Asset, Display.Root, data))
		WriteLine(self, ToString()+" has registered as a custom menu.")
	Else
		WriteUnexpected(self, "OnGameReload", ToString()+" failed to register as a custom menu.")
	EndIf
EndEvent


; Methods
;---------------------------------------------

DisplayData Function NewDisplay()
	return new DisplayData
EndFunction


bool Function Open()
	If (UI.IsMenuRegistered(Menu))
		return UI.OpenMenu(Menu)
	Else
		WriteUnexpected(self, "Open", ToString()+" is not registered.")
		return false
	EndIf
EndFunction


bool Function Close()
	If (UI.IsMenuRegistered(Menu))
		return UI.CloseMenu(Menu)
	Else
		WriteUnexpected(self, "Close", ToString()+" is not registered.")
		return false
	EndIf
EndFunction


bool Function GetVisible()
	If (UI.IsMenuOpen(Menu))
		return UI.Get(Menu, GetMember("Visible")) as bool
	Else
		WriteUnexpected(self, "GetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


bool Function SetVisible(bool value)
	If (UI.IsMenuOpen(Menu))
		WriteLine(self, ToString()+" setting visible to "+value)
		return UI.Set(Menu, GetMember("Visible"), value)
	Else
		WriteUnexpected(self, "SetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


string Function GetMember(string member)
	{Returns the full AS3 instance path for the given member name.}
	If (StringIsNoneOrEmpty(member))
		WriteUnexpectedValue(self, "GetMember", "member", "Cannot operate on a none or empty display member.")
		return none
	ElseIf (StringIsNoneOrEmpty(root))
		WriteUnexpected(self, "GetMember", "Cannot operate on a none or empty display root.")
		return none
	Else
		return Root+"."+member
	EndIf
EndFunction


; Functions
;---------------------------------------------

string Function ToString()
	{The string representation of this type.}
	return "[Menu:"+Menu+", Asset:"+Asset+", Root:"+Root+"]"
EndFunction


; Properties
;---------------------------------------------

Group Display
	string Property Menu Hidden
		string Function Get()
			return Display.Menu
		EndFunction
	EndProperty

	string Property Root Hidden
		string Function Get()
			return Display.Root
		EndFunction
	EndProperty

	string Property Asset Hidden
		string Function Get()
			return Display.Asset
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
