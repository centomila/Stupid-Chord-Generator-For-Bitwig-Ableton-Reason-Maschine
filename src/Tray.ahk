#Requires AutoHotkey v2.0


global tray := A_TrayMenu
global trayGui := 0

ToggleTraySetIcon() {
    if WinExist(currentDawExeClass) {
        if StatusEnabled {
            TraySetIcon("Images\ICO\Icon-On.ico")
        } else {
            TraySetIcon("Images\ICO\Icon-Off.ico")
        }
    }
}


; Create the submenu for DAWs
dawMenu := Menu()
for DAWs in DAW_LIST_EXE_CLASS_MAP {
    dawMenu.Add(DAWs, SelectDaw, "Radio")
}

tooltipMenu := Menu()
for tooltipValues in TOOLTIP_DURATION_LIST {
    tooltipMenu.Add(tooltipValues, SelectToolTipDuration, "Radio")
}

chordsIniListMenu := Menu()
for chordsIniFiles in CHORDS_INI_LIST {
    chordsIniListMenu.Add(chordsIniFiles, SelectChordsIniSet, "Radio")
}

GenerateTrayMenu() {
    trayGui := Gui("+DPIScale")
    trayGui.SetDarkMenu()
    tray.Delete() ; empty the menu
    tray.Add(APP_NAME, OpenAbout)  ; Title
    tray.Add("About - v" . APP_VERSION, OpenAbout) ; About  
    tray.Add("MIT License", OpenLicense) ; License
    tray.Add("Help", NoAction) ; License

    tray.Add() ; ------------------------------
    tray.Add("DAW", dawMenu) ; Add the DAW submenu
    tray.Add("Tooltip Duration (ms)", tooltipMenu) ; Add the ToolTipDuration submenu
    tray.Add() ; ------------------------------
    tray.Add("Chord Presets", chordsIniListMenu) ; Add the ToolTipDuration submenu
    chordsIniListMenu.Add()
    chordsIniListMenu.Add("Open Chords Preset Folder", OpenChordsFolder)

    tray.Add() ; ------------------------------
    tray.Add("Top Info OSD`tKey Left of 1 (`` or \)", OpenOSDGui)  
    tray.Add() ; ------------------------------

    
    tray.Add() ; ------------------------------

    tray.Add("Reload", ReloadApp)  
    tray.Add("Quit", ExitApp)

    tray.ClickCount := 1
    tray.Default := "About - v" . APP_VERSION
    A_IconTip :=  APP_NAME . " - v" . APP_VERSION . " - " . currentDaw

    AddChordsToTray()

    ResetCheckboxes()
}

ReloadApp(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Reload
}

OpenChordsFolder(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Run "Explorer.exe /e," . A_ScriptDir . "\Chords"
}

SelectToolTipDuration(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for tooltipValues in TOOLTIP_DURATION_LIST {
        tooltipMenu.Uncheck(tooltipValues)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ToolTipDuration")
    tooltipMenu.Check(IniRead("Settings.ini", "Settings", "ToolTipDuration"))
    LoadSettings()
    return
}

SelectChordsIniSet(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for chordsIniFiles in CHORDS_INI_LIST {
        chordsIniListMenu.Uncheck(chordsIniFiles)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ChordIniSet")
    chordsIniListMenu.Check(IniRead("Settings.ini", "Settings", "ChordIniSet"))

    LoadSettings()
    GenerateTrayMenu()
    return
}

SelectDaw(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for DAWs in DAW_LIST_EXE_CLASS_MAP {
        dawMenu.Uncheck(DAWs)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "DAW")
    dawMenu.Check(IniRead("Settings.ini", "Settings", "DAW"))
    currentDaw := A_ThisMenuItem

    switch currentDaw {
        case "NI Maschine 2":
            MsgBox(
                "Instructions:`n`n" .
                "Right Click on the piano roll and select`n`n" .
                "NUDGE GRID > STEP", currentDaw)
            LoadSettings()
            return
        default:
            LoadSettings()
            return
    }

}

OpenAbout(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    aboutGui := AboutGuiToggle()
}

OpenLicense(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    licenseGui := LicenseGuiToggle()
}

OpenOSDGui(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ToggleOSDGui()
}

NoAction(*) {
    return
}

ExitApp(*)
{
    ExitApp()
}

AddChordsToTray() {
    chordGroupSize := 12
    currentGroup := 1
    groupMenu := Menu()

    for index, chords in chordsArray {
        chordName := chords[1]
        chordInterval := chords[2]
        shortcutKey := chords[3]
        textForLabel := chordName . " [" . chordInterval . "]" . "`t" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        if (Mod(index - 1, chordGroupSize) == 0) {
            if (index > 1) {
                tray.Insert("Chord Presets","Chords`t" . ((currentGroup - 1) * chordGroupSize + 1) . "-" . (currentGroup * chordGroupSize), groupMenu, "")
                currentGroup++
            }
            groupMenu := Menu()
        }

        groupMenu.Add(textForLabel, NoAction)

        if (index == chordsArray.Length) {
            tray.Insert("Chord Presets","Chords`t" . ((currentGroup - 1) * chordGroupSize + 1) . "-" . index, groupMenu, "")
        }
    }
}


ResetCheckboxes() {
    ; checkboxes for the tray menu items
    dawMenu.Check(currentDaw)
    tooltipMenu.Check(currentToolTipDuration)
    chordsIniListMenu.Check(currentChordsIniSet)
}

ChordsMenu() {
    ; show the "Chord Preset" menu on the cursor location
    chordsIniListMenu.Show()
    if topGuiOSD == true {
        ToggleOSDGui()
        ToggleOSDGui()
    }
}

try {
    ResetCheckboxes()
}