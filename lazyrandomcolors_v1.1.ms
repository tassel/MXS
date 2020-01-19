/*
[DESCRIPTION]
Lazy Random Colors V1.1 – Assigns Random colors to objects or Gray color to objects.

[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2009 <--> 2012

[CREATION INFO]
Last Modified: Apr 14, 2011
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com

[History]
V1.0: First version.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------
	try(closeRolloutFloater LazyRandomColorFloater) catch()
----------------------------------------------------------------------------------------------------------------------------------------------------------
	(     
        Rollout Roll_RandomColor "Random Colors"
        (
			function Fn_RandomColors objs =
				(
					for i in objs do
					i.wirecolor = random black white
                )
				
			function Fn_RandomColorsGray objs =
                (
					for i in objs do
					i.wirecolor = white * random 0.2 0.8
                )
				
			function Fn_RandomColorsGrayOnly objs =
                (
					for i in objs do
					i.wirecolor = gray
                )
----------------------------------------------------------------------------------------------------------------------------------------------------------
				group "Random Colors"
                (
					radiobuttons RanWho labels:#("By Selected", "By Geometry", "By Objects (All)") across:2
					Button DoRandCol "Assign" width:70 height:30 align:#right
                )
				
                group "Random Gray"
                (
					radiobuttons RanGray labels:#("By Selected", "By Geometry", "By Objects (All)") across:2
					button DoGrayCol "Assign" width:70 height:30 align:#right
                )
				
				group "Gray Only"
                (
					radiobuttons RanGrayOnly labels:#("By Selected", "By Geometry", "By Objects (All)") across:2
					button DoGrayOnly "Assign" width:70 height:30 align:#right
                )
				
                group "About"
                (
					HyperLink homepage2 "..:: Raymond H.Ingebretsen'2011 ::.." address:"http://www.homme3d.com/" color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255) align:#center
				)
----------------------------------------------------------------------------------------------------------------------------------------------------------				
                on DoRandCol pressed do
                (
					if RanWho.state==1 then
						Fn_RandomColors selection
							else
					if RanWho.state==2 then
						Fn_RandomColors geometry
							else
						Fn_RandomColors objects
                )
				
                on DoGrayCol pressed do
                (
					if RanGray.state==1 then
						Fn_RandomColorsGray selection
							else
					if RanGray.state==2 then
						Fn_RandomColorsGray geometry
							else
						Fn_RandomColorsGray objects
                )  
				
                 on DoGrayOnly pressed do
                (
					if RanGrayOnly.state==1 then
						Fn_RandomColorsGrayOnly selection
							else
					if RanGrayOnly.state==2 then
						Fn_RandomColorsGrayOnly geometry
							else
						Fn_RandomColorsGrayOnly objects
                )       
		)
----------------------------------------------------------------------------------------------------------------------------------------------------------
        LazyRandomColorFloater=NewRolloutFloater "Lazy Random Colors" 210 310 280 150
        Addrollout Roll_RandomColor LazyRandomColorFloater
----------------------------------------------------------------------------------------------------------------------------------------------------------
	)
