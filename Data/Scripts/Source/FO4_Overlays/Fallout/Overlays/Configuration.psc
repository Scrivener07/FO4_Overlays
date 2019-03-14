Scriptname Fallout:Overlays:Configuration extends Fallout:Overlays:Type
import Fallout
import Fallout:Overlays
import Fallout:Overlays:Papyrus

; Methods
;---------------------------------------------

Function SetAlpha(float value)
	Fallout_Overlays_Alpha.SetValue(value)
	If (Menu.IsOpen)
		Menu.SetAlpha(value)
	EndIf
	WriteLine(self, "SetAlpha", value)
EndFunction


Function SetAlphaSpeed(float value)
	Fallout_Overlays_AlphaSpeed.SetValue(value)
	WriteLine(self, "SetAlphaSpeed", value)
EndFunction


Function SetScopeAlpha(float value)
	Fallout_Overlays_Scope_Alpha.SetValue(value)
	WriteLine(self, "SetScopeAlpha", value)
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Overlays:Menu Property Menu Auto Const Mandatory
	GlobalVariable Property Fallout_Overlays_Alpha Auto Const Mandatory
	GlobalVariable Property Fallout_Overlays_AlphaSpeed Auto Const Mandatory
	GlobalVariable Property Fallout_Overlays_Scope_Alpha Auto Const Mandatory
EndGroup

Group Settings
	float Property Alpha Hidden
		float Function Get()
			return Fallout_Overlays_Alpha.GetValue()
		EndFunction
		Function Set(float value)
			Fallout_Overlays_Alpha.SetValue(value)
		EndFunction
	EndProperty

	float Property AlphaSpeed Hidden
		float Function Get()
			return Fallout_Overlays_AlphaSpeed.GetValue()
		EndFunction
		Function Set(float value)
			Fallout_Overlays_AlphaSpeed.SetValue(value)
		EndFunction
	EndProperty

	float Property ScopeAlpha Hidden
		float Function Get()
			return Fallout_Overlays_Scope_Alpha.GetValue()
		EndFunction
		Function Set(float value)
			Fallout_Overlays_Scope_Alpha.SetValue(value)
		EndFunction
	EndProperty
EndGroup
