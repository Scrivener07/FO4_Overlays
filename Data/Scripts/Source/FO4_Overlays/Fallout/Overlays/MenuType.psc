Scriptname HaloHelmet:MenuType extends Quest Const Native Hidden
{The base type for a menu script.}

; Display
;---------------------------------------------

Struct DisplayData
	string Menu
	{The name of the menu to load within.}

	string Root = "root1"
	{The root display object.}

	string Asset
	{The asset file to load within the given menu. The root directory is "Data\Interface".}
EndStruct


; OnGameReload
;---------------------------------------------

Event OnGameReload() Native
{Event occurs when the game has been reloaded or initialized.}


Event Actor.OnPlayerLoadGame(Actor akSender)
	OnGameReload()
EndEvent


bool Function RegisterForGameReload(MenuType this)
	return this.RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
EndFunction


Function UnregisterForGameReload(MenuType this)
	this.UnregisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
EndFunction


; Functions
;---------------------------------------------

string Function ToString()
	{The string representation of this type.}
	return "[MenuType]"
EndFunction
