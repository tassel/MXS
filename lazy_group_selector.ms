/*
[DESCRIPTION]
Lazy Group Selector V1.0 – Collect all groups in the scene.
 
[INFO]
- Put the files in maxroot\scripts\ (e.g.: C:\3dsmax2012\Scripts\)
- Tested with 3DS Max 2012
 
[CREATION INFO]
Last Modified: Oct 19, 2011
Author: Raymond Homme Ingebretsen
Webpage: http://www.homme3d.com
 
[History]
V1.0: First version.
*/
 
try(destroyDialog GroupSelector)catch()
 
rollout GroupSelector "Lazy Group Selector"
(
	button btn_UpdateGroups "Update" width:210 height:25 align:#center
	group "Select Group:"
		(
			dropdownlist DD_Group "" items:#()
		)
	
	HyperLink hl_homepage "..:: Raymond H.Ingebretsen ::.." address:"http://www.homme3d.com/" color:(color 000 000 000) hovercolor:(color 255 255 255) visitedcolor:(color 000 000 000) align:#center

local Groups_Array = #()
 
fn Update_Groups =
(
	Groups_Array = for o in objects where isGroupHead o collect o
	DD_Group.items = for o in Groups_Array collect o.name
)
       
	on GroupSelector open do Update_Groups()
	on DD_Group selected i do select Groups_Array[i]
	on btn_UpdateGroups pressed do Update_Groups()
 )
 
createDialog GroupSelector width:220