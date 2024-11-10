	try(destroyDialog rol_selectByNameRollout)catch()

	rollout rol_selectByNameRollout "Select Objects by Name"
	(
		groupbox ObjectSelect "Enter to search Objects by Name: " width:330 height:95 pos:[3,3]
		editText nameInput "Search for:" fieldWidth:260 pos:[10,30] height:18 align:#left
		button selectBtn "..:: Select Objects ::.." width:315  pos:[10,60] height:32 align:#left
	
		on selectBtn pressed do
		(
			-- Get the input from the text field
			searchNameStr = nameInput.text
		
			-- Find and select objects whose names contain the entered pattern
			objsToSelArray = for o in objects where (matchPattern o.name pattern:("*" + searchNameStr + "*")) collect o
			select objsToSelArray
		)
	)

	-- Create and display the dialog box
	createDialog rol_selectByNameRollout 340 110
