/*
###########################################################################################################################################################################
#  
#  [DESCRIPTION]
#   Render Switcher V1.0 – Sets Renderengine, Reset Material Editor to Default Scanline, Mr or Vray, Erase Scene Materials,
#   Delete materials by Selected/Unselected Materials and CleanUP/Delete Unused Materials from scene.
#
#  [INFO]
#   - Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2009\Scripts\)
#   - Works with Max 9 -> 2011
#
#  [CREATION INFO]
#   Author: Raymond Homme Ingebretsen
#   Last Modified: Jan 22, 2011
#
###########################################################################################################################################################################
#
#  [History]
#   Jan 22, 2011: First Version of script.
#
###########################################################################################################################################################################
*/

try (closeRolloutFloater roll_easyrenderswitcher) catch()

rsys = #()
for i = 1 to (rendererclass.classes.count-1) do (append rsys (rendererclass.classes[i] as string))
		
rollout rlist "RendererSwitcher" width:230 height:200 category:1
(
		listbox rlistbox "Available Render Engines:" items:rsys
		on rlistbox doubleclicked rsel do
		(
				renderers.production = rendererclass.classes[rsel] ()
				destroydialog rlist
		)
)
 
if classOf rMatEditing == RolloutClass do destroyDialog rMatEditing
 
(
	rollout rMatEditing "Material Manager" width:230 height:280 category:2
	(
		checkbox resetmateditor "Reset Material Editor" checked:false pos:[7,25]
		checkbox erasescenemats "Erase All Scene Materials" checked:false pos:[7,45]
		checkbox delcurrobjmat "Delete All Selected Object Materials" checked:false pos:[7,65]
		checkbox delnonselobj "Delete All Unselected Object Materials" checked:false pos:[7,85]
		checkbox delunusedmats "Delete Unused Materials From Scene" checked:false pos:[7,105]
		radiobuttons defaultorvray labels:#("Default Material", "mental ray Material", "V-Ray Material") default:1 pos:[7,130] enabled:false
		button btn_execute "Execute" width:70 height:20 pos:[30,190]
		button btn_cancel "Reset" width:70 height:20 pos:[118, 190]
		groupBox managemats "Managing Materials" width:210 height:210 pos:[3,5]
				
				
		on resetmateditor changed state do
		(
				defaultorvray.enabled = state
		)
		on btn_execute pressed do
		(
			if resetmateditor.checked == true  and defaultorvray.state == 1 then
			(
				matcount = meditMaterials.count
				for i = 1 to matcount do
				(
						matindex = i as string
						while matindex.count < 2 do (matindex = "0" + matindex)
						meditMaterials[i] = standard name: (matindex +" - Default Material")
				)
				resetmateditor.checked = false
				defaultorvray.enabled = false
			)
			
			if resetmateditor.checked == true and defaultorvray.state == 2 then
			(
				matcount = meditMaterials.count
				for i = 1 to matcount do
				(
						matindex = i as string
						while matindex.count < 2 do (matindex = "0" + matindex)
						meditMaterials[i] = Arch___Design__mi ()
						 meditMaterials[i].name = matindex +" - mental ray Material"
				)
				resetmateditor.checked = false
				defaultorvray.enabled = false
			)
			if resetmateditor.checked == true and defaultorvray.state == 3 then
			(
				matcount = meditMaterials.count
				for i = 1 to matcount do
				(
						matindex = i as string
						while matindex.count < 2 do (matindex = "0" + matindex)
						meditMaterials[i] = VRayMtl name: (matindex +" - VRay Material")
				)
				resetmateditor.checked = false
				defaultorvray.enabled = false
			)
			if erasescenemats.checked == true then
			(
					$*.material = undefined
					erasescenemats.checked = false
			)

			if delcurrobjmat.checked == true then
			(
				for obj in selection do
				(
						$.material = undefined
						delcurrobjmat.checked = false
				)
			)

			if delnonselobj.checked == true then
			(
				actionMan.executeAction 0 "40044"
				for obj in selection do
				(
						$.material = undefined
						delnonselobj.checked = false
				)
			)	
		)
		on btn_cancel pressed do
		(
			removeRollout  rMatEditing
			addRollout rMatEditing rof
		)
	)
)

rollout rAbout "About" width:230 height:200 category:3
(
	HyperLink hl_homepage "www.homme3d.com" address:"http://www.homme3d.com/" color:(color 255 153 51) hovercolor:(color 255 153 51) visitedcolor:(color 255 153 51) align:#center
	label lbl_tnx "Thanks to Håvard Schei for Help/Support" align:#center
)
		
roll_easyrenderswitcher=newrolloutfloater "Easy RenderSwitcher V1.0" 230 520
		
addRollout rlist roll_easyrenderswitcher rolledUp:false
addRollout rMatEditing roll_easyrenderswitcher rolledUp:false
addRollout rAbout roll_easyrenderswitcher rolledUp:false