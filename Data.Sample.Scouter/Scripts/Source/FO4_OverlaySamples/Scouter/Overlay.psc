Scriptname Scouter:Overlay extends Quest
{Provides advanced overlay interactions for the scouter.}
import Scouter:Log
import Fallout:Overlays:Framework

Actor Player
Armor Scouter

Fallout:Overlays:Framework Framework
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
			Framework = OverlayFramework()
			If (Framework)
				TextBox4_Label = Framework.GetMember("TextBox4.Label")
				TextBox4_Value = Framework.GetMember("TextBox4.Value")
				TextBox5_Label = Framework.GetMember("TextBox5.Label")
				TextBox5_Value = Framework.GetMember("TextBox5.Value")
				Framework.RegisterForOpenCloseEvent(self)

				WriteLine(self, "OnGameReload")
			Else
				WriteUnexpectedValue(self, "OnGameReload", "Framework", "The script object cannot be none.")
			EndIf
		Else
			WriteUnexpectedValue(self, "OnGameReload", "Scouter", "The Armor cannot be none.")
		EndIf
	Else
		WriteUnexpectedValue(self, "OnGameReload", "Plugin.IsInstalled", "The plugin is not installed.")
	EndIf
EndFunction


Event Fallout:Overlays:Framework.OpenCloseEvent(Fallout:Overlays:Framework sender, var[] arguments)
	OpenCloseEventArgs e = sender.GetOpenCloseEventArgs(arguments)
	If (e.Opening)
		If (sender.Equipped == Scouter)
			WriteLine(self, "Invoking AS3 code on the scouter overlay.")

			Game:PluginInfo info = Plugin.GetInfo()

			sender.Set(TextBox4_Label, "Mod")
			sender.Set(TextBox4_Value, info.name+" by "+info.author)

			sender.Set(TextBox5_Label, "Player Level")
			sender.Set(TextBox5_Value, "The players level is "+Game.GetPlayerLevel())

		Else
			WriteLine(self, "No scouter item is equipped.")
		EndIf
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Scouter:Plugin Property Plugin Auto Const Mandatory
EndGroup
