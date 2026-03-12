/*
    Navisworks Attributes Cleaner - Made to clean up imported CAD/DAK files
    -------------------------------------------------------------------
	Script by Raymond H.Ingebretsen'2018
*/

try(destroyDialog NWCleanerRollout)catch()

global NWCleanerRollout
global worker

/* -------------------------
   CLEANUP FUNCTIONS
------------------------- */

fn deleteAllCAs obj deleteBase deleteMods =
(
    local removed = 0
    
    if deleteBase do
    (
        local caCount = custAttributes.count obj BaseObject:true
        for i = caCount to 1 by -1 do
        (
            custAttributes.delete obj i BaseObject:true
            removed += 1
        )
    )
    
    if deleteMods do
    (
        for m = obj.modifiers.count to 1 by -1 do
        (
            local mod = obj.modifiers[m]
            if isValidModifier mod do
            (
                local mCount = custAttributes.count mod
                for i = mCount to 1 by -1 do
                (
                    custAttributes.delete mod i
                    removed += 1
                )
            )
        )
    )
    return removed
)

fn cleanNavisProps obj =
(
    local removed = 0
    try
    (
        if obj.propertySets != undefined do
        (
            local pCount = obj.propertySets.count
            for i = pCount to 1 by -1 do
            (
                obj.propertySets.delete i
                removed += 1
            )
        )
    ) catch()
    return removed
)

/* -------------------------
   UI ROLLOUT
------------------------- */

rollout NWCleanerRollout "Attributes Cleaner - Navisworks / CAD Cleanup" width:340 height:550
(
    group "CHECKERS:"
    (
        checkbox chkBase "Delete Custom Attributes (BaseObject)" checked:true
        checkbox chkMods "Delete Custom Attributes (Modifiers)" checked:true
        checkbox chkNW "Delete Navisworks PropertySets" checked:true
        checkbox chkAll "Clear the entire scene (not just selection)" checked:false
    )
    
    group "BATCH SIZE:"
    (
        spinner spnBatch "Batch size:" type:#integer range:[50,600,300] width:80 align:#left across:2 tooltip:"Objects per batch"
        checkbox chkSafe "Safe Mode (300 batch)" align:#right checked:false tooltip:"300 objects per batch"
    )
    
    group "PROGRESS AND LOG:"
    (
        progressbar pb "" width:300 height:12 color:(color 80 160 255)
        dotNetControl logBox "System.Windows.Forms.RichTextBox" width:300 height:260
    )
    
    group "EXECUTE:"
    (
        button btnRun "..:: RUN CLEANUP ::.." width:300 height:40
    )

	HyperLink hl_homme3d "..:: (c) Raymond H.Ingebretsen'2018 ::.." address:"https://homme3d.com/" align:#center color:(color 255 255 255) hovercolor:(color 111 111 111) visitedcolor:(color 255 255 255)
		
    /* -------------------------
       LOGBOX COLORS
    ------------------------- */
	on NWCleanerRollout open do
	(
		logBox.BackColor = (dotNetClass "System.Drawing.Color").Black
		logBox.ForeColor = (dotNetClass "System.Drawing.Color").White
	)
	
    /* -------------------------
       LOGGING (COLOR-CODED)
    ------------------------- */

	fn log msg color:(color 255 255 255) =
	(
		local col = (dotNetClass "System.Drawing.Color").FromArgb color.r color.g color.b
		logBox.SelectionColor = col
		logBox.AppendText (msg + "\n")
		logBox.ScrollToCaret()
	)

    /* -------------------------
       SAFE MODE
    ------------------------- */

    on chkSafe changed state do
    (
        if state then
        (
            spnBatch.value = 300
            log "Safe Mode enabled (batch = 300)" color:(color 255 200 0)
        )
        else
        (
            spnBatch.value = 600
            log "Safe Mode disabled (batch = 600)" color:(color 255 255 255)
        )
    )

    /* -------------------------
       CLEANUP WORKER
    ------------------------- */

    fn doCleanup sender args =
    (
        local objs = if chkAll.checked then (objects as array) else (selection as array)
        local total = objs.count
        local totalRemoved = 0
        local batchSize = spnBatch.value

        for startIndex = 1 to total by batchSize do
        (
            local endIndex = aMin (startIndex + batchSize - 1) total
            
            for i = startIndex to endIndex do
            (
                local obj = objs[i]
                if isValidNode obj do
                (
                    if chkBase.checked or chkMods.checked do
                        totalRemoved += deleteAllCAs obj chkBase.checked chkMods.checked
                    
                    if chkNW.checked do
                        totalRemoved += cleanNavisProps obj
                )
                -- worker.ReportProgress i
				worker.ReportProgress (100.0 * i / total)

            )
            gc light:true
        )
        args.Result = totalRemoved
    )

    fn updateProgress sender args =
    (
        pb.value = args.ProgressPercentage
    )

    fn cleanupDone sender args =
    (
        local removed = args.Result
        log ("Done! Attributes deleted: " + removed as string) color:(color 0 255 0)
        btnRun.enabled = true
    )

    /* -------------------------
       RUN BUTTON
    ------------------------- */

    on btnRun pressed do
    (
        local objs = if chkAll.checked then (objects as array) else (selection as array)

        if objs.count == 0 then
        (
            messageBox "No objects selected in the scene."
            return()
        )

        if spnBatch.value > 600 then
        (
            messageBox "Batch size cannot exceed 600."
            spnBatch.value = 600
            return()
        )

        logBox.Clear()
        pb.value = 0
        btnRun.enabled = false

        log ("Starting cleanup of " + objs.count as string + " objects...") color:(color 180 220 255)
        log ("Batch size: " + spnBatch.value as string)

        worker.RunWorkerAsync()
    )
)

	/* -------------------------
	DOTNET WORKER
	------------------------- */

	worker = dotNetObject "System.ComponentModel.BackgroundWorker"
	worker.WorkerReportsProgress = true
	worker.WorkerSupportsCancellation = false

	dotNet.addEventHandler worker "DoWork" NWCleanerRollout.doCleanup
	dotNet.addEventHandler worker "ProgressChanged" NWCleanerRollout.updateProgress
	dotNet.addEventHandler worker "RunWorkerCompleted" NWCleanerRollout.cleanupDone

createDialog NWCleanerRollout
