Scriptname Scouter:Overlay extends Quest
{Provides advanced overlay interactions for the scouter.}
import Scouter:Log
import Fallout:Overlays:Client

Actor Player
Armor Scouter

string TextBox4_Label = ""
string TextBox4_Value = ""

string TextBox5_Label = ""
string TextBox5_Value = ""


; Events
;---------------------------------------------

Event OnQuestInit()
	Player = Game.GetPlayer()
	OnGameReload()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	OnGameReload()
EndEvent


Function OnGameReload()
	If (Plugin.IsInstalled)
		Scouter = Plugin.GetArmor(Plugin._R_Scouter)
		If (Scouter)
			TextBox4_Label = Client.GetMember("TextBox4.Label")
			TextBox4_Value = Client.GetMember("TextBox4.Value")
			TextBox5_Label = Client.GetMember("TextBox5.Label")
			TextBox5_Value = Client.GetMember("TextBox5.Value")
			Client.RegisterForOpenCloseEvent(self)
			WriteLine(self, "OnGameReload")
		Else
			WriteUnexpectedValue(self, "OnGameReload", "Scouter", "The Armor cannot be none.")
		EndIf
	Else
		WriteUnexpectedValue(self, "OnGameReload", "Plugin.IsInstalled", "The plugin is not installed.")
	EndIf
EndFunction


Event Fallout:Overlays:Client.OpenCloseEvent(Fallout:Overlays:Client sender, var[] arguments)
	OpenCloseEventArgs e = Client.GetOpenCloseEventArgs(arguments)
	If (e.Opening)
		If (Client.Equipped == Scouter)
			WriteLine(self, "Invoking AS3 code on the scouter overlay.")

			Game:PluginInfo info = Plugin.GetInfo()

			Client.Set(TextBox4_Label, "Mod")
			Client.Set(TextBox4_Value, info.name+" by "+info.author)

			Client.Set(TextBox5_Label, "Player Level")
			Client.Set(TextBox5_Value, "The players level is "+Game.GetPlayerLevel())
		Else
			WriteLine(self, "No scouter item is equipped.")
		EndIf
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Fallout:Overlays:Client Property Client Auto Const Mandatory
	Scouter:Plugin Property Plugin Auto Const Mandatory
EndGroup
