#Requires AutoHotkey v2.0

global licenseGui := 0

LicenseGuiToggle() {
    if (licenseGui == 0) {
        global licenseGui := GuiExt("+DPIScale ")
        
        licenseGui.SetFont("cWhite s12", "Segoe UI")
        licenseGui.SetDarkTitle()
        licenseGui.SetDarkMenu()
        
        licenseGuiWidth := 960
        licenseGuiHeight := 960
        
        licenseGui.Title := APP_NAME . " " . APP_VERSION . " - License"
        licenseGui.BackColor := "0x202020"
        
        licenseGui.MarginX := +50
        licenseGui.MarginY := +50
        
        licenseText := FileRead("LICENSE")
        licenseGui.Add("Text", "w" . licenseGuiWidth . " c0xf4f4f4", licenseText)
    
        licenseGui.OnEvent('Close', (*) => closeLicenseGui())
        licenseGui.Show("NA AutoSize xCenter w" . licenseGuiWidth . " h" . licenseGuiHeight)
    
        return licenseGui
    } else {
        closeLicenseGui()
    }
}


closeLicenseGui(*) {
    licenseGui.Destroy()
    global licenseGui := 0
    return
}