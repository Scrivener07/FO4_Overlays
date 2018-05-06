Scriptname HaloHelmet:Overlay extends HaloHelmet:Menu
import HaloHelmet:Log

Actor Player

string EmptyState = "" const
string EquippedState = "Equipped" const

int CameraFirstPerson = 0 const


; Events
;---------------------------------------------

Event OnInit()
	parent.OnInit()
	Player = Game.GetPlayer()
EndEvent


Event OnQuestInit()
	parent.OnQuestInit()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	GiveTestItems()
EndEvent


Event OnQuestShutdown()
	parent.OnQuestShutdown()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


Event Actor.OnItemEquipped(Actor sender, Form akBaseObject, ObjectReference akReference)
	If (akBaseObject == Armor_Synth_Helmet_Closed)
		GotoState(EquippedState)
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	If (akBaseObject == Armor_Synth_Helmet_Closed)
		GotoState(EmptyState)
	EndIf
EndEvent


; States
;---------------------------------------------

State Equipped
	Event OnBeginState(string asOldState)
		WriteLine(self, ToString()+" equipped.")
		RegisterForCameraState()
		self.Open()
		; need a wait or callback here?
		self.SetVisible(IsFirstPerson)
	EndEvent

	Event OnPlayerCameraState(int aiOldState, int aiNewState)
		self.SetVisible(IsFirstPerson)
	EndEvent

	Event OnEndState(string asNewState)
		WriteLine(self, ToString()+" unequipped.")
		UnregisterForCameraState()
		self.Close()
	EndEvent
EndState


; Methods
;---------------------------------------------

DisplayData Function NewDisplay()
	DisplayData display = new DisplayData
	display.Menu = "HaloHelmetMenu"
	display.Asset = "HaloHelmetMenu"
	display.Root = "root1.Overlay"
	return display
EndFunction


; Functions
;---------------------------------------------

Function GiveTestItems() DebugOnly
	Game.GetPlayer().AddItem(Armor_Synth_Helmet_Closed)
	WriteLine(self, ToString()+" added "+Armor_Synth_Helmet_Closed+" for testing.")
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Armor Property Armor_Synth_Helmet_Closed Auto Const Mandatory
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup
