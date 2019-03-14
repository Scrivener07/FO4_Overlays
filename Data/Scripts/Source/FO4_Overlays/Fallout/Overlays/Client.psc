Scriptname Fallout:Overlays:Client extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

Actor Player
int BipedEyes = 17 const
bool ThirdPerson = false const


; Events
;---------------------------------------------

Event OnQuestInit()
	Player = Game.GetPlayer()
EndEvent


; Methods
;---------------------------------------------

Actor:WornItem Function GetWorn()
	{Scans down the highest slot of an eye slot item.}
	int slot = 0
	While (slot <= BipedEyes)
		Actor:WornItem worn = Player.GetWornItem(slot, ThirdPerson)
		If (Framework.ItemFilter(worn.Item))
			return worn
		EndIf
		slot += 1
	EndWhile
	WriteUnexpectedValue(self, "GetWorn", "value", "No biped slot has a valid eyes item.")
	return none
EndFunction


string Function GetMember(string member)
	{Provides instance member paths the client.}
	If (member)
		return Menu.GetClientMember(member)
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


; Properties
;---------------------------------------------

Group Overlay
	Fallout:Overlays:Framework Property Framework Auto Const Mandatory
	Fallout:Overlays:Menu Property Menu Auto Const Mandatory
EndGroup

Armor Property Equipped Hidden
	{Returns the equipped eyes item.}
	Armor Function Get()
		return GetWorn().Item as Armor
	EndFunction
EndProperty
