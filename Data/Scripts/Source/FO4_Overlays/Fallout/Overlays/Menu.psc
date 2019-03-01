Scriptname Fallout:Overlays:Menu extends Fallout:Overlays:Type
import Fallout:Overlays
import Fallout:Overlays:Papyrus


; Events
;---------------------------------------------

Event OnQuestInit()
	OnGameReload()
	RegisterForGameReload(self)
EndEvent


Event OnGameReload()
	UI:MenuData data = new UI:MenuData
	data.MenuFlags = FlagDoNotPreventGameSave
	data.ExtendedFlags = FlagNone
	If (UI.RegisterCustomMenu(Name, Path, Root, data))
		WriteLine(self, ToString()+" has registered as a custom menu.")
	Else
		WriteUnexpected(self, "OnGameReload", ToString()+" failed to register as a custom menu.")
	EndIf
EndEvent


; Methods
;---------------------------------------------

bool Function Open()
	If (IsOpen)
		WriteUnexpected(self, "Open", ToString()+" is already open.")
		return true
	Else
		If (IsRegistered)
			return UI.OpenMenu(Name)
		Else
			WriteUnexpected(self, "Open", ToString()+" is not registered.")
			return false
		EndIf
	EndIf
EndFunction


bool Function Close()
	If (!IsOpen)
		WriteUnexpected(self, "Close", ToString()+" is already closed.")
		return true
	Else
		If (IsRegistered)
			return UI.CloseMenu(Name)
		Else
			WriteUnexpected(self, "Close", ToString()+" is not registered.")
			return false
		EndIf
	EndIf
EndFunction


bool Function GetVisible()
	If (IsOpen)
		return UI.Get(Name, GetMember("Visible")) as bool
	Else
		WriteUnexpected(self, "GetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


bool Function SetVisible(bool value)
	If (IsOpen)
		WriteLine(self, ToString()+" setting visible to "+value)
		return UI.Set(Name, GetMember("Visible"), value)
	Else
		WriteUnexpected(self, "SetVisible", ToString()+" is not open.")
		return false
	EndIf
EndFunction


bool Function SetAlpha(float value)
	If (IsOpen)
		return UI.Set(Name, GetMember("Alpha"), value)
	Else
		WriteUnexpected(self, "SetAlpha", ToString()+" is not open.")
		return false
	EndIf
EndFunction


bool Function SetURI(string value)
	If (IsOpen)
		If (value)
			var[] arguments = new var[1]
			arguments[0] = value
			UI.Invoke(Name, GetMember("SetURI"), arguments)
			WriteLine(self, "SetURI:"+value)
			return true
		Else
			WriteUnexpectedValue(self, "SetURI", "value", "The value cannot be none or empty.")
			return false
		EndIf
	Else
		WriteUnexpected(self, "SetURI", ToString()+" is not open.")
		return false
	EndIf
EndFunction


; Functions
;---------------------------------------------

string Function GetMember(string member)
	{Returns the full AS3 instance path for the given member name.}
	If !(member)
		WriteUnexpectedValue(self, "GetMember", "member", "The value cannot be none or empty.")
		return ""
	ElseIf !(Root)
		WriteUnexpectedValue(self, "GetMember", "Root", "The value cannot be none or empty.")
		return ""
	Else
		return Root+"."+member
	EndIf
EndFunction


string Function GetClientMember(string member)
	If (member)
		return GetMember(Client+"."+member)
	Else
		WriteUnexpectedValue(self, "GetClientMember", "member", "The value cannot be none or empty.")
		return ""
	EndIf
EndFunction


string Function ToString()
	{The string representation of this type.}
	return "[Name:"+Name+", Path:"+Path+", Root:"+Root+"]"
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
			{The root instance path of this menu's display object.}
			return "root1"
		EndFunction
	EndProperty

	string Property Client Hidden
		string Function Get()
			{The instance path of the client's display object.}
			; This will change if any display objects are added or removed in the Flash editor.
			return "Overlay.instance3"
		EndFunction
	EndProperty

	bool Property IsOpen Hidden
		bool Function Get()
			{Returns true if this menu is open.}
			return UI.IsMenuOpen(Name)
		EndFunction
	EndProperty

	bool Property IsRegistered Hidden
		bool Function Get()
			{Returns true if this menu is registered.}
			return UI.IsMenuRegistered(Name)
		EndFunction
	EndProperty
EndGroup

Group MenuFlags
	int Property FlagNone = 0x0 AutoReadOnly
	int Property FlagDoNotPreventGameSave = 0x800 AutoReadOnly
EndGroup

Group ExtendedFlags
	; If you set extendedFlags & 2, it will disable your ShowCursor if the Gamepad is enabled
	int Property FlagInheritColors = 1 AutoReadOnly
	int Property FlagCheckForGamepad = 2 AutoReadOnly
EndGroup
