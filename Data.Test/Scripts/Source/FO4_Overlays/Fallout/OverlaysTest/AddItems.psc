Scriptname Fallout:OverlaysTest:AddItems extends Fallout:Overlays:Type DebugOnly
import Fallout:Overlays:Papyrus

Actor Player
bool Silent = true const

; Events
;---------------------------------------------

Event OnInit()
	Player = Game.GetPlayer()
EndEvent


Event OnQuestInit()
	Try(Fallout4, Armor_Synth_Helmet_Closed)
	Try(Fallout4, Armor_Raider_GreenHoodGasmask)
	Try(Fallout4, Armor_Gasmask)
	Try(Fallout4, ClothesBlackRimGlasses)
	Try(Fallout4, Armor_BoS_Science_Scribe_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_TechSuit)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkIV_Left_Arm)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkIV_Legs)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkIV_Right_Arm)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkIV_Torso)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_FOTUS_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Recruit_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Recon_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_AirAssault_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_MarkV_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Prefect_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Pathfinder_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Raider_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Scout_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_MarkVI_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Scanner_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Strider_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Wetwork_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Locus_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_WarMaster_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Hazop_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Engineer_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Pioneer_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Anubis_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_CIO_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Centurion_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Raijin_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Maverick_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Hellcat_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Achilles_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MilitaryPolice_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Operator_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkVb_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Pilot_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Stalker_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Helioskrill_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Deadeye_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Rouge_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Aviator_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Venator_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo4_Warrior_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Indomitable_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Wrath_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Intruder_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Vigilant_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Haunted_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_HaloReach_Noble_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_EOD_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkIV_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_Argus_Helmet)
	Try(CommonwealthSpartanRedux, Armor_CommonwealthSpartan_Halo5_MarkVI_Helmet)
	WriteLine(self, "Added items for debug testing.")
EndEvent


; Functions
;---------------------------------------------

Function Try(string plugin, int formID)
	If (Game.IsPluginInstalled(plugin))
		Form item = Game.GetFormFromFile(formID, plugin)
		If (item)
			Player.AddItem(item, 1, Silent)
		EndIf
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Vanilla
	string Property Fallout4 = "Fallout4.esm" AutoReadOnly
	int Property Armor_Synth_Helmet_Closed = 0x0018796A AutoReadOnly
	int Property Armor_Raider_GreenHoodGasmask = 0x0007239E AutoReadOnly
	int Property Armor_Gasmask = 0x001184C1 AutoReadOnly
	int Property ClothesBlackRimGlasses = 0x00125891 AutoReadOnly
	int Property Armor_BoS_Science_Scribe_Helmet = 0x000E4501 AutoReadOnly ;/ No Biped Eye Slot /;
EndGroup

Group BrandonPotter
	string Property CommonwealthSpartanRedux = "Commonwealth_Spartan_Redux.esp" AutoReadOnly
	int Property Armor_CommonwealthSpartan_TechSuit = 0x0003BC8D AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkIV_Left_Arm = 0x0007EB2D AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkIV_Legs = 0x0007EB2E AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkIV_Right_Arm = 0x0007EB2F AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkIV_Torso = 0x0007EB30 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_FOTUS_Helmet = 0x000378D3 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Recruit_Helmet = 0x00039230 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Recon_Helmet = 0x00039AA5 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_AirAssault_Helmet = 0x0003A319 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_MarkV_Helmet = 0x0003A328 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Prefect_Helmet = 0x0003A338 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Pathfinder_Helmet = 0x0003ABAB AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Raider_Helmet = 0x0003B41E AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Scout_Helmet = 0x0003C4FA AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_MarkVI_Helmet = 0x0003D5D4 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Scanner_Helmet = 0x00043AD7 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Strider_Helmet = 0x00044341 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Wetwork_Helmet = 0x0004B900 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Locus_Helmet = 0x0004C16A AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_WarMaster_Helmet = 0x0004C9D4 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Hazop_Helmet = 0x0004DAAA AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Engineer_Helmet = 0x0004F3E8 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Pioneer_Helmet = 0x0004FC51 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Anubis_Helmet = 0x00050D29 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_CIO_Helmet = 0x0005266B AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Centurion_Helmet = 0x00052ED7 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Raijin_Helmet = 0x00053741 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Maverick_Helmet = 0x00053745 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Hellcat_Helmet = 0x00053749 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Achilles_Helmet = 0x00054828 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MilitaryPolice_Helmet = 0x00055092 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Operator_Helmet = 0x000558FC AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkVb_Helmet = 0x00056166 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Pilot_Helmet = 0x000569D0 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Stalker_Helmet = 0x00069076 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Helioskrill_Helmet = 0x000738C0 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Deadeye_Helmet = 0x0007E947 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Rouge_Helmet = 0x0007E969 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Aviator_Helmet = 0x0007E97E AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Venator_Helmet = 0x0007E98C AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo4_Warrior_Helmet = 0x0007E9A8 AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Indomitable_Helmet = 0x0007E9C6 AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Wrath_Helmet = 0x0007E9DD AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Intruder_Helmet = 0x0007E9F0 AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Vigilant_Helmet = 0x0007E9F4 AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Haunted_Helmet = 0x0007EA07 AutoReadOnly
	int Property Armor_CommonwealthSpartan_HaloReach_Noble_Helmet = 0x0007EA0B AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_EOD_Helmet = 0x0007EB0D AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkIV_Helmet = 0x0007EB2C AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_Argus_Helmet = 0x0008DF46 AutoReadOnly
	int Property Armor_CommonwealthSpartan_Halo5_MarkVI_Helmet = 0x00092AED AutoReadOnly
EndGroup
