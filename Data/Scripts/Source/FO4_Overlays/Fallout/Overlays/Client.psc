Scriptname Fallout:Overlays:Client extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

Actor Player
bool ThirdPerson = false const


; Events
;---------------------------------------------

Event OnQuestInit()
	Player = Game.GetPlayer()
EndEvent


; Methods
;---------------------------------------------

string Function GetMember(string member)
	{Provides the instance variable path for client members.}
	If (member)
		return Menu.GetMember(Menu.Client+"."+member)
	Else
		WriteUnexpectedValue(self, "GetMember", "member", "The value cannot be none or empty.")
		return ""
	EndIf
EndFunction


var Function Get(string member)
	return UI.Get(Menu.Name, member)
EndFunction


bool Function Set(string member, var argument)
	return UI.Set(Menu.Name, member, argument)
EndFunction


var Function Invoke(string member, var[] arguments = none)
	return UI.Invoke(Menu.Name, member, arguments)
EndFunction


; Open/Close Event
;---------------------------------------------

CustomEvent OpenCloseEvent

Struct OpenCloseEventArgs
	bool Opening = false
EndStruct


bool Function RegisterForOpenCloseEvent(ScriptObject script)
	If (script)
		script.RegisterForCustomEvent(self, "OpenCloseEvent")
		return true
	Else
		WriteUnexpectedValue(self, "RegisterForOpenCloseEvent", "script", "Cannot register a none script for events.")
		return false
	EndIf
EndFunction


bool Function UnregisterForOpenCloseEvent(ScriptObject script)
	If (script)
		script.UnregisterForCustomEvent(self, "OpenCloseEvent")
		return true
	Else
		WriteUnexpectedValue(self, "UnregisterForOpenCloseEvent", "script", "Cannot unregister a none script for events.")
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


; Loaded Event
;---------------------------------------------

CustomEvent LoadedEvent

Struct LoadedEventArgs
	bool Success = false
	string Instance = ""
EndStruct


bool Function RegisterForLoadedEvent(ScriptObject script)
	If (script)
		script.RegisterForCustomEvent(self, "LoadedEvent")
		return true
	Else
		WriteUnexpectedValue(self, "RegisterForLoadedEvent", "script", "Cannot register a none script for events.")
		return false
	EndIf
EndFunction


bool Function UnregisterForLoadedEvent(ScriptObject script)
	If (script)
		script.UnregisterForCustomEvent(self, "LoadedEvent")
		return true
	Else
		WriteUnexpectedValue(self, "UnregisterForLoadedEvent", "script", "Cannot unregister a none script for events.")
		return false
	EndIf
EndFunction


LoadedEventArgs Function GetLoadedEventArgs(var[] arguments)
	If (arguments)
		return arguments[0] as LoadedEventArgs
	Else
		return none
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Armor Property Equipped Hidden
		{Returns the equipped eyes item.}
		Armor Function Get()
			return Framework.GetWorn().Item as Armor
		EndFunction
	EndProperty
EndGroup

Group Private
	Fallout:Overlays:Framework Property Framework Auto Const Mandatory
	{Private- The framework is used to track equipment changes on the player.}

	Fallout:Overlays:Menu Property Menu Auto Const Mandatory
	{Private- Provides an abstraction for interacting with the overlay menu.}
EndGroup
