Scriptname Scouter:Plugin extends Quest
{Provides meta information about the Scouter data file.}
import Scouter:Log


; Properties
;---------------------------------------------

Group Properties
	string Property Name Hidden
		{The plugin file name, without the file extension.}
		string Function Get()
			; Note: It is bad practice to include a version in file name.
			; A plugin name and form IDs should remain unchanging when possible.
			return "Scouter_V1.1_by_Ruddy88"
		EndFunction
	EndProperty

	string Property File Hidden
		{The plugin file name & extension.}
		string Function Get()
			return Name+".esp"
		EndFunction
	EndProperty

	bool Property IsInstalled Hidden
		{Returns true if the plugin is installed.}
		bool Function Get()
			return Game.IsPluginInstalled(File)
		EndFunction
	EndProperty
EndGroup

Group ARMO
	int Property _R_Scouter Hidden
		{_R_Scouter "Scouter" [ARMO:0?000800]}
		int Function Get()
			return 0x00000800
		EndFunction
	EndProperty
EndGroup


; Functions
;---------------------------------------------


Game:PluginInfo Function GetInfo()
	{Returns the plugin info for this modification.}
	If (IsInstalled)
		Game:PluginInfo[] plugins = Game.GetInstalledPlugins()
		If (plugins)
			int index = plugins.FindStruct("Name", File)
			If (index > -1)
				return plugins[index]
			Else
				WriteUnexpectedValue(self, "GetInfo", "index", "The array index was invalid.")
				return none
			EndIf
		Else
			WriteUnexpectedValue(self, "GetInfo", "plugins", "The plugin info array cannot be none or empty.")
			return none
		EndIf
	Else
		WriteUnexpectedValue(self, "GetInfo", "IsInstalled", "The plugin file '"+File+"' is not installed.")
		return none
	EndIf
EndFunction


Armor Function GetArmor(int formID)
	{Returns an `Armor` record from a plugin file.}
	If (IsInstalled)
		return Game.GetFormFromFile(formID, File) as Armor
	Else
		WriteUnexpectedValue(self, "GetArmor", "IsInstalled", "The plugin file '"+File+"' is not installed.")
		return none
	EndIf
EndFunction

