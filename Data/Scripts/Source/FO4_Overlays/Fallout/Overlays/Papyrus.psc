ScriptName Fallout:Overlays:Papyrus Const Native Hidden
{Extensions for scripting with Papyrus in general.}

; Logging
;---------------------------------------------
; Writes messages as lines in a log file.

bool Function WriteLine(string prefix, string text) Global DebugOnly
	string filename = "Overlays" const
	text = prefix + " " + text
	If(Debug.TraceUser(filename, text))
		return true
	Else
		Debug.OpenUserLog(filename)
		return Debug.TraceUser(filename, text)
	EndIf
EndFunction


bool Function WriteNotification(string prefix, string text) Global DebugOnly
	Debug.Notification(text)
	return WriteLine(prefix, text)
EndFunction


bool Function WriteMessage(string prefix, string title, string text = "") Global DebugOnly
	string value
	If !(StringIsNoneOrEmpty(text))
		value = title+"\n"+text
	EndIf
	Debug.MessageBox(value)
	return WriteLine(prefix, title+" "+text)
EndFunction


; Formated Messages
;---------------------------------------------

bool Function WriteUnexpected(var script, string member, string text = "") Global DebugOnly
	return WriteLine(script+"["+member+"]", "The member '"+member+"' had an unexpected operation. "+text)
EndFunction


bool Function WriteUnexpectedValue(var script, string member, string variable, string text = "") Global DebugOnly
	return WriteLine(script+"["+member+"."+variable+"]", "The member '"+member+"' with variable '"+variable+"' had an unexpected operation. "+text)
EndFunction


bool Function WriteNotImplemented(var script, string member, string text = "") Global DebugOnly
	{The exception that is thrown when a requested method or operation is not implemented.}
	; The exception is thrown when a particular method, get accessors, or set accessors is present as a member of a type but is not implemented.
	return WriteLine(script, member+": The member '"+member+"' was not implemented. "+text)
EndFunction


Function WriteChangedValue(var script, string propertyName, var fromValue, var toValue) Global DebugOnly
	WriteLine(script, "Changing '"+propertyName+"'' from '"+fromValue+"'' to '"+toValue+"'.")
EndFunction


; Debug
;---------------------------------------------

bool Function TraceKeywords(Form aForm) Global DebugOnly
	string logPrefix = "[Papyrus.psc TraceKeywords]" const

	If (aForm)
		Keyword[] array = aForm.GetKeywords()
		If (array)
			int index = 0
			While (index < array.Length)
				WriteLine(logPrefix, aForm+" has keyword: "+array[index]+", @"+index)
				index += 1
			EndWhile
			return true
		Else
			WriteLine(logPrefix, aForm+" has no keywords.")
			return false
		EndIf
	Else
		WriteLine(logPrefix, "Cannot trace keywords on none form.")
		return false
	EndIf
EndFunction


bool Function TracePropertyModifiers(ObjectMod aObjectMod) Global DebugOnly
	string logPrefix = "[Papyrus.psc TracePropertyModifiers]" const

	If (aObjectMod)
		ObjectMod:PropertyModifier[] array = aObjectMod.GetPropertyModifiers()
		If (array)
			int index = 0
			While (index < array.Length)
				WriteLine(logPrefix, aObjectMod+" has PropertyModifier: "+array[index]+", @"+index)
				index += 1
			EndWhile
			return true
		Else
			WriteLine(logPrefix, aObjectMod+" has no property modifiers.")
			return false
		EndIf
	Else
		WriteLine(logPrefix, "Cannot trace property modifiers on none ObjectMod.")
		return false
	EndIf
EndFunction


; String
;---------------------------------------------

bool Function StringIsNoneOrEmpty(string value) Global
	{Indicates whether the specified string is a none or empty string.}
	return !(value) || value == ""
EndFunction
