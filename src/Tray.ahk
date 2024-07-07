#Requires AutoHotkey v2.0

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
loop DAW_LIST.Length {
    dawName := DAW_LIST.Get(A_Index)
    dawMenu.Add(dawName, SelectDaw, "Radio")
}

toolTipMenu := Menu()
loop toolTipDurationOptions.Length {
    toolTipMenu.Add(toolTipDurationOptions.Get(A_Index), SelectToolTipDuration, "Radio")
}

tray := A_TrayMenu
tray.Delete()
A_IconTip := APP_NAME


tray.Add(APP_NAME, NoAction)  ; Creates a separator line.


tray.Add() ; Creates a separator line.
tray.Add("DAW", dawMenu) ; Add the DAW submenu
tray.Add("ToolTipDuration", toolTipMenu) ; Add the ToolTipDuration submenu
tray.Add("Edit Chords.ini", EditChordsIniFile)

tray.Add() ; Creates a separator line.
tray.Add("Key Left of 1 (`` or \)`tTop Info OSD", OpenOSDGui)  ; Creates a new menu item.
tray.Add() ; Creates a separator line.
tray.Add("About - v" . APP_VERSION, MenuAbout)  ; Creates a new menu item.
tray.Add("Quit", ExitApp)  ; Creates a new menu item.

AddChordsToTray()


tray.Default := "About - v" . APP_VERSION

EditChordsIniFile(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Run "Chords.ini"
}

SelectToolTipDuration(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    loop toolTipDurationOptions.Length {
        toolTipMenu.Uncheck(toolTipDurationOptions.Get(A_Index))
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ToolTipDuration")
    toolTipMenu.Check(IniRead("Settings.ini", "Settings", "ToolTipDuration"))
    Reload
}

SelectDaw(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    loop DAW_LIST.Length {
        dawName := DAW_LIST.Get(A_Index)
        dawMenu.Uncheck(dawName)
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
        default:
            return
    }
    ; Reload the script
    Reload
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
    for sections in chordsIni {
        section := IniRead("Chords.ini", sections)
        chordName := GetChordsInfoFromIni(section)[1]
        chordInterval := GetChordsInfoFromIni(section)[2]
        shortcutKey := GetChordsInfoFromIni(section)[3]

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
