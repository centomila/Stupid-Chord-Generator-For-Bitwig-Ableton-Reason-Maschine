; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent  ; Keep the script running until the user exits it.
#SingleInstance force

AppName := "Centomila's Stupid Universal Chord Generator"
AppVersion := "1.0.0"

try {
    IniRead("Settings.ini", "Settings", "ToolTipDuration")
} catch {
    IniWrite(1500, "Settings.ini", "Settings", "ToolTipDuration")
}

ChordsIni := StrSplit(IniRead("Chords.ini"), "`n")


ToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
DawList := ["Bitwig Studio", "Ableton Live", "Reason", "NI Maschine 2"]
CurrentDaw := ""

MapHotFixStrings := Map(
    "Bitwig Studio", "ahk_class bitwig",
    "Ableton Live", "ahk_class Ableton Live Window Class",
    "Reason", "ahk_exe Reason.exe",
    "NI Maschine 2", "ahk_exe Maschine 2.exe")

DawHotFixString := "" ; Empty until the script has loaded the correct DAW

; Create the submenu for DAWs
dawMenu := Menu()
loop DawList.Length {
    dawName := DawList.Get(A_Index)
    dawMenu.Add(dawName, SelectDaw, "Radio")
}

; Tray icon
if (A_IsCompiled) {
    ; Compiled version, use icon from the .exe file
    TraySetIcon(A_ScriptName)
} else {
    ; Source version, use the custom icon
    TraySetIcon("FChordsGen.ico")
}

Tray := A_TrayMenu
Tray.Delete()

Tray.Add(AppName, NoAction)  ; Creates a separator line.
Tray.Add() ; Creates a separator line.

AddChordsToTray()

Tray.Add() ; Creates a separator line.
Tray.Add("DAW", dawMenu) ; Add the DAW submenu
Tray.Add("About", MenuAbout)  ; Creates a new menu item.


Tray.Add() ; Creates a separator line.
Tray.Add("Top Info OSD", TopGui)  ; Creates a new menu item.
Tray.Add("Quit", ExitApp)  ; Creates a new menu item.
; Tray default the first item in the menu programmaticaly
; Tray.Default := AppName
Tray.Default := "About"

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
    aboutGui := About()
    aboutGui.Show()
}
About()
{
    #Include About.ahk
}

TopGui(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    #Include TopGui.ahk
}

; Function to open the website
OpenWebsite()
{
    Run("https://centomila.com")
}


NoAction(*) {
    ; Do nothing.
}

ExitApp(*)
{
    ExitApp()
}


try {
    IniRead("Settings.ini", "Settings", "DAW")
    dawMenu.Check(IniRead("Settings.ini", "Settings", "DAW"))
    CurrentDaw := IniRead("Settings.ini", "Settings", "DAW")
    DawHotFixString := MapHotFixStrings.Get(IniRead("Settings.ini", "Settings", "DAW"))

} catch {
    IniWrite("Bitwig Studio", "Settings.ini", "Settings", "DAW")
    dawMenu.Check(IniRead("Settings.ini", "Settings", "DAW"))
    DawHotFixString := MapHotFixStrings.Get(IniRead("Settings.ini", "Settings", "DAW"))
}

; Main function to convert note intervals to shortcut commands
ToolTipChord(ChordTypeName) {
    ToolTip("`n" . ChordTypeName . "`n") ; Show the tooltip with the chord name
    SetTimer () => ToolTip(), ToolTipDuration ; Show the tooltip for ToolTipDuration seconds
}


; Main function to convert note intervals to shortcut commands
GenerateChord(NotesInterval, ChordTypeName, ThisHotkey := "", ThisLabel := "") {
    If !WinActive(DawHotFixString) {
        ; exit function
        ToggleEnable()
        SendInput "{" . ThisHotkey . "}"
        return
    }
    SendEvent("^c")
    ; NotesToAdd is a string fromatted like this 0-4-7". Split the string into an array
    ChordNotes := StrSplit(NotesInterval, "-")
    ; Loop through the array and convert strings into numbers
    Loop ChordNotes.Length - 1 ; Skip the root note 0
    {
        semitones := ChordNotes.Get(A_Index + 1)

        switch CurrentDaw {
            case "Reason":
                SendEvent("^l")
                SendEvent("^c")
                SendEvent("!{Left}")
                SendEvent("^{Up " . semitones . "}")
                SendEvent("^v")
            case "NI Maschine 2":
                SendEvent("^c")
                SendEvent("!{Up " . semitones . "}")
                SendEvent("^v")
                SendEvent("!{Left}")
            default:
                SendEvent("^c")
                SendEvent("{Up " . semitones . "}")
                SendEvent("^v")
        }
    }
    ToolTipChord(ChordTypeName)
}


AddChordsToTray() {
    for i, chord in ChordsIni {
        section := IniRead("Chords.ini", chord)
        chordName := StrSplit(StrSplit(section, "`n")[1], "=")[2]
        chordInterval := StrSplit(StrSplit(section, "`n")[2], "=")[2]
        shortcutKey := StrSplit(StrSplit(section, "`n")[3], "=")[2]

        Tray.Add(shortcutKey . " | " . chordName . " | " . chordInterval, NoAction)
    }
}

DynamicIniMapping(OnOff := "Off") {
    for sections in ChordsIni {
        section := IniRead("Chords.ini", sections)
        ChordName := StrSplit(StrSplit(section, "`n")[1], "=")[2]
        ChordInterval := StrSplit(StrSplit(section, "`n")[2], "=")[2]
        ShortCutKey := StrSplit(StrSplit(section, "`n")[3], "=")[2]

        ; MsgBox(ChordName . " - " . ChordInterval . " - " . ShortCutKey)

        Hotkey(ShortCutKey, GenerateChord.Bind(ChordInterval, ChordName), OnOff)
    }
}

; Function to change the system tray icon based on the Caps Lock state.
ToggleEnable() {
    If (WinActive(DawHotFixString) and GetKeyState("CapsLock", "T")) {
        DynamicIniMapping(OnOff := "On")
        ToolTip "`nCHORDS ON`n ", 9999, 9999 ; Positioned at 9999,9999 so it is always on the lower right corner
        ; TraySetIcon(IconOn) ; Set the system tray icon to the "F13-ON.ico" icon.
    } else {
        DynamicIniMapping(OnOff := "Off")
        ToolTip "`nOFF`n ", 9999, 9999 ; Positioned at 9999,9999 so it is always on the lower right corner
        ; TraySetIcon(IconOff) ; Set the system tray icon to the "F13-OFF.ico" icon.
    }
    SetTimer () => ToolTip(), -1500 ; Clear the tooltip after 1.5 seconds
}

ToggleEnable() ; Execute ChangeIcon on startup.

; the tilde (~) symbol before a hotkey tells AutoHotkey to allow the original function of the key to pass through.
; This means that the key will still perform its default action, in addition to executing the script you've defined.
~CapsLock:: ToggleEnable ; Execute the ChangeIcon function when the Caps Lock key is pressed.


;-------------------------------------------------------------------------------
; Octave change
; Page Down Select all and move an octave DOWN
PgDn:: {
    SendEvent("((^a)(+{Down}))")
    ToolTipChord("Octave DOWN")
}

; Page Up Select all and move an octave UP
PgUp:: {
    SendEvent("((^a)(+{Up}))")
    ToolTipChord("Octave UP")
}
#HotIf


; Autoreload on saving trick
#HotIf WinActive("Visual Studio Code")
~^s:: Reload
#HotIf