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
loop DawList.Length {
    dawName := DawList.Get(A_Index)
    dawMenu.Add(dawName, SelectDaw, "Radio")
}

ToolTipMenu := Menu()
loop ToolTipDurationOptions.Length {
    ToolTipMenu.Add(ToolTipDurationOptions.Get(A_Index), SelectToolTipDuration, "Radio")
}

Tray := A_TrayMenu
Tray.Delete()
A_IconTip := AppName


Tray.Add(AppName, NoAction)  ; Creates a separator line.


Tray.Add() ; Creates a separator line.
Tray.Add("DAW", dawMenu) ; Add the DAW submenu
Tray.Add("ToolTipDuration", ToolTipMenu) ; Add the ToolTipDuration submenu
Tray.Add("Edit Chords.ini", EditChordsIniFile)

Tray.Add() ; Creates a separator line.
Tray.Add("Key Left of 1 (`` or \)`tTop Info OSD", OpenOSDGui)  ; Creates a new menu item.
Tray.Add() ; Creates a separator line.
Tray.Add("About - v" . AppVersion, MenuAbout)  ; Creates a new menu item.
Tray.Add("Quit", ExitApp)  ; Creates a new menu item.

AddChordsToTray()


Tray.Default := "About - v" . AppVersion

EditChordsIniFile(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Run "Chords.ini"
}

SelectToolTipDuration(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    loop ToolTipDurationOptions.Length {
        ToolTipMenu.Uncheck(ToolTipDurationOptions.Get(A_Index))
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ToolTipDuration")
    ToolTipMenu.Check(IniRead("Settings.ini", "Settings", "ToolTipDuration"))
    Reload
}

SelectDaw(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    loop DawList.Length {
        dawName := DawList.Get(A_Index)
        dawMenu.Uncheck(dawName)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "DAW")
    dawMenu.Check(IniRead("Settings.ini", "Settings", "DAW"))
    CurrentDaw := A_ThisMenuItem

    switch CurrentDaw {
        case "NI Maschine 2":
            MsgBox(
                "Instructions:`n`n" .
                "Right Click on the piano roll and select`n`n" .
                "NUDGE GRID > STEP", CurrentDaw)
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
    Tray.Add("F1/F12 - Basic Chords", NoAction, "BarBreak") ; Creates a separator line.
    Tray.Add()
    for sections in ChordsIni {
        section := IniRead("Chords.ini", sections)
        chordInfo := GetChordsInfoFromIni(section)
        ChordName := chordInfo[1]
        ChordInterval := chordInfo[2]
        ShortCutKey := chordInfo[3]

        TextForLabel := ShortCutKey . "`t" . ChordName . " [" . ChordInterval . "]"
        TextForLabel := StrReplace(TextForLabel, "+", "SHIFT - ")
        TextForLabel := StrReplace(TextForLabel, "^", "CTRL - ")
        TextForLabel := StrReplace(TextForLabel, "!", "ALT - ")
        if (A_Index == 13) {
            Tray.Add()
            Tray.Add("CTRL+F1/CTRL+F12", NoAction, "") ; Creates a separator line.
            Tray.Add()
        }
        if (A_Index == 25) {
            Tray.Add("SHIFT+F1/SHIFT+F12", NoAction, "BarBreak") ; Creates a separator line.
            Tray.Add()
        }
        if (A_Index == 37) {
            Tray.Add()
            Tray.Add("ALT+F1/ALT+F12", NoAction, "") ; Creates a separator line.
            Tray.Add()
        }
        Tray.Add(TextForLabel, NoAction)
    }
}
