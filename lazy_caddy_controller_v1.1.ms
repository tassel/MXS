/*
[DESCRIPTION]
Lazy Caddy Controller V1.1 - Script to control the Caddy.
 
[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2012

NOTE
You must have the Caddy open to se what's going on :o) 

[CREATION INFO]
Last Modified: Feb 20, 2012
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com
 
--[History]
V1.0: First version.
V1.1: Added write settings to "Scripts/startup" folder.
*/

		try(destroyDialog roll_CaddyCustomize)catch()
     
			rollout roll_CaddyCustomize "Lazy Caddy Controller V1.1"
            (
                    group "Caddy Settings:"
                    (
                            spinner spn_WidgetSpacing "WidgetSpacing:" range:[0.0,30.0,0.0] type:#float
                            spinner spn_Transparency "Transparency:" range:[0.0,0.9,0.0] type:#float
                            spinner spn_HoverTransparency "HoverTransparency:" range:[0.0,0.9,0.0] type:#float
                    )
                           
                    group "Caddy Position:"
                    (
                            spinner spn_CenterXPos "CenterXPos:" range:[0.0,1.0,0.0] type:#float
                            spinner spn_CenterYPos "CenterYPos:" range:[0.0,1.0,0.0] type:#float
                    )
                   
                    group "Caddy Center On Selected:"
                    (
                            button btn_CCOSTrue "True / On" width:90 across:2
                            button btn_CCOSFalse "False / Off" width:90
                    )
                   
						button btn_GenerateScript  "..:: WRITE FILE TO STARTUP ::.." width:210 height:25 tooltip:"Print to listener and write file to scripts/startup!"
						HyperLink Hypl_homepage "..:: Raymond H.Ingebretsen'2012 ::." address:"http://www.homme3d.com" color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255) align:#center
                   
                    ---------------------------------------------------------------------------------------------
                    -- Fn
                    ---------------------------------------------------------------------------------------------

				fn appendString s add = (format "%" add to:s)
					
				fn CaddyToMXS =
				(		
					str = stringstream ""

						appendString str ("\tGrip.CenterXPos = "+(roll_CaddyCustomize.spn_CenterXPos.value as string)+"\n")
						appendString str ("\tGrip.CenterYPos = "+(roll_CaddyCustomize.spn_CenterYPos.value as string)+"\n")
						appendString str ("\tGrip.WidgetSpacing = "+(roll_CaddyCustomize.spn_WidgetSpacing.value as string)+"\n")
						appendString str ("\tGrip.Transparency = "+(roll_CaddyCustomize.spn_Transparency.value as string)+"\n")
						appendString str ("\tGrip.HoverTransparency = "+(roll_CaddyCustomize.spn_HoverTransparency.value as string)+"\n")
						appendString str ("\tGrip.CenterOnSelected =  "+(Grip.CenterOnSelected as string)+"\n")
					
							format "-- CaddyToMXS OUTPUT:\n\n"
							format "%\n" (str as string)
							format "\n\n"

							appendString str ("")

							global filname = (getDir #maxRoot + "scripts\\startup\\CaddySettings.ms") 					
							f = fopen filname "wb"
							writestring f str
							fclose f 
					
							return str
					) -- End Function
					
					
                    ---------------------------------------------------------------------------------------------
                    -- Print Settings to Listener and Write to File
                    ---------------------------------------------------------------------------------------------
				
				on btn_GenerateScript pressed do
				(
						CaddyToMXS()				
				)
                    ---------------------------------------------------------------------------------------------
                    -- Caddy X and Y Position
                    ---------------------------------------------------------------------------------------------
                    on spn_CenterXPos changed val do
                            (
                                    Grip.CenterXPos = val
                            )
                           
                    on spn_CenterYPos changed val do
                            (
                                    Grip.CenterYPos = val
                            )
                           
                    ---------------------------------------------------------------------------------------------
                    -- Caddy Transparency and Spacing
                    ---------------------------------------------------------------------------------------------
                    on spn_WidgetSpacing changed val do
                            (
                                    Grip.WidgetSpacing = val
                            )
                   
                    on spn_Transparency changed val do
                            (
                                    Grip.Transparency = val
                            )
                   
                    on spn_HoverTransparency changed val do
                            (
                                    Grip.HoverTransparency = val
                            )
                           
                    ---------------------------------------------------------------------------------------------
                    -- Caddy Center On and Off
                    ---------------------------------------------------------------------------------------------
                    on button btn_CCOSTrue pressed do
                    (
                            Grip.CenterOnSelected = True
                    )
                   
                    on button btn_CCOSFalse pressed do
                    (
                            Grip.CenterOnSelected = False
                    )
                   
			) -- End Rollout
     
            createDialog roll_CaddyCustomize 220 255 50 180
