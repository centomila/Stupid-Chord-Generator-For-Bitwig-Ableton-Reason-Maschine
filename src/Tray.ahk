#Requires AutoHotkey v2.0


tray := A_TrayMenu


; Tray icon
if (A_IsCompiled) {
    ; Compiled version, use icon from the .exe file
    TraySetIcon(A_ScriptName)
} else {
    ; Source version, use the custom icon
    TraySetIcon("FChordsGen.ico")
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
    tray.Delete() ; empty the menu
    tray.Add(APP_NAME, NoAction)  ; Creates a separator line.

    tray.Add() ; Creates a separator line.
    tray.Add("DAW", dawMenu) ; Add the DAW submenu
    tray.Add("Tooltip Duration (ms)", tooltipMenu) ; Add the ToolTipDuration submenu
    tray.Add("Chord Set", chordsIniListMenu) ; Add the ToolTipDuration submenu
    tray.Add() ; Creates a separator line.
    tray.Add("Edit Chords.ini", EditChordsIniFile)

    tray.Add() ; Creates a separator line.
    tray.Add("Key Left of 1 (`` or \)`tTop Info OSD", OpenOSDGui)  ; Creates a new menu item.
    tray.Add() ; Creates a separator line.
    tray.Add("About - v" . APP_VERSION, MenuAbout)  ; Creates a new menu item.
    tray.Add("Quit", ExitApp)  ; Creates a new menu item.
    
    tray.Default := "About - v" . APP_VERSION
    A_IconTip := APP_NAME

    ; AddChordsToTray()
    AddChordsToTray()

    ResetCheckboxes()
}

EditChordsIniFile(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Run "Chords.ini"
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

MenuAbout(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    aboutGui := aboutGuiToggle()
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
    tray.Add("F1/F12 - Basic Chords", NoAction, "BarBreak") ; Creates a separator line.
    tray.Add()

    for chords in chordsArray {
        chordName := chords[1]
        chordInterval := chords[2]
        shortcutKey := chords[3]
        textForLabel := shortcutKey . "`t" . chordName . " [" . chordInterval . "]"
        textForLabel := ReplaceShortCutSymbols(textForLabel)
        if (A_Index == 13) {
            tray.Add()
            tray.Add("CTRL+F1/CTRL+F12", NoAction, "") ; Creates a separator line.
            tray.Add()
        }
        if (A_Index == 25) {
            tray.Add("SHIFT+F1/SHIFT+F12", NoAction, "BarBreak") ; Creates a separator line.
            tray.Add()
        }
        if (A_Index == 37) {
            tray.Add()
            tray.Add("ALT+F1/ALT+F12", NoAction, "") ; Creates a separator line.
            tray.Add()
        }
        tray.Add(textForLabel, NoAction)
    }
}


ResetCheckboxes() {
    ; checkboxes for the tray menu items
    dawMenu.Check(currentDaw)
    tooltipMenu.Check(currentToolTipDuration)
    chordsIniListMenu.Check(currentChordsIniSet)
}

try {
    ResetCheckboxes()
}