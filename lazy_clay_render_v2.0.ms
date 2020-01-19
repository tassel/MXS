/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Lazy Clay Render V2.0 - Scripted Clay Render that keeps everything intact after rendering.
 
[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2012
 
[CREATION INFO]
Date Created : March 11, 2012
Last Modified: March 15, 2012
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com
 
[NOTE]
Use and modify at you own risk.
 
[SPECIAL THANKS TO]
Anubis for always helping me out <<---->> Webpage: http://project3d.narod.ru
Haavard for always helping me out <<---->> Webpage: http://folk.ntnu.no/havardsc/site/wordpress/
Hardrock_ram for always beeing helpful <<---->> Webpage: http://www.3dhue.com/album_personal.php?user_id=490
Tronotrond for big help and suport <<---->> Webpage: http://hille3d.no/
 
[History]
V1.0: First version. Render Clay + Sample spinner Settings
V2.0: Added Environment Color Suport + implemented part of Hardrock_ram & Haavard's sugestions (Big thanks!) ;o)
 
[KNOWN ISSUES]
NONE
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

try destroyDialog rol_clayRender catch()

rollout rol_ClayRender "Lazy Clay Render V2.0"
(
	group ""
	(
		colorpicker clp_color "Environment Color:" modal:false width:160 height:18 color:white align:#right tooltip:"Environment Color"
		spinner spn_clay "Samples:" width:95 height:18  align:#right type:#integer range:[1,24,12] tooltip:"Set Number of Samples\n 1 = Dirty\n 24 = Smooth"
		button btn_clayRender "..:: CLAY RENDER ::.." width:135 height:25 align:#left tooltip:"Render Clay and sett everything back to original state." across:2
		button btn_about "?" width:25 height:25 align:#right tooltip:"About"
	)
      HyperLink Hypl_homepage "..:: Raymond H.Ingebretsen'2012 ::.." address:"http://www.homme3d.com" color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255) align:#center

	on btn_clayRender pressed do
	(
		prevRender = renderers.production 
		undo on
		(
			$geometry.material = standard diffuse:(color 220 220 220) twosided:true
			$lights.enabled = false 
			ThisSkylight = skylight castShadows:true rays_per_sample:spn_clay.value color:clp_color.color
			renderers.production = default_scanline_renderer()
		)
		
		render progressBar:true cancelled:&renderCanceled
		
		if renderCanceled then
			messageBox "Render Canceled..." title:"Clay Render Message..."
		
		renderers.production = prevRender
		max undo
		gc light:true 
	)
   
	on btn_about pressed do
	(
		messageBox "Special Thanks to: Hardrock_ram and Havards @ 3dhue.com\n - For always helping out.." title:"About Clay Render..."
	)
	
) -- End rollout

createDialog rol_clayRender 190 120 90 150 

--// EOF