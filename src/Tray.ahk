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



Tray := A_TrayMenu
Tray.Delete()

Tray.Add(AppName, NoAction)  ; Creates a separator line.


Tray.Add() ; Creates a separator line.
Tray.Add("DAW", dawMenu) ; Add the DAW submenu
Tray.Add("About - v" . AppVersion, MenuAbout)  ; Creates a new menu item.


Tray.Add() ; Creates a separator line.
Tray.Add("Top Info OSD", OpenOSDGui)  ; Creates a new menu item.
Tray.Add("Quit", ExitApp)  ; Creates a new menu item.

AddChordsToTray()


Tray.Default := "About - v" . AppVersion

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