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


; Add a line for every F command like this: F1 - Major Chords 0-4-7 With notation. Just a list.

Tray.Add("F1 - Major Chords - 0-4-7", NoAction)
Tray.Add("F2 - Minor Chords - 0-3-7", NoAction)
Tray.Add("F3 - Augmented Chords - 0-4-8", NoAction)
Tray.Add("F4 - Diminished Chords - 0-3-6", NoAction)
Tray.Add("F5 - Major 7th Chords - 0-4-7-11", NoAction)
Tray.Add("F6 - Minor 7th Chords - 0-3-7-10", NoAction)
Tray.Add("F7 - Augmented 7th Chords - 0-4-8-11", NoAction)
Tray.Add("F8 - Diminished 7th Chords - 0-3-6-9", NoAction)
Tray.Add("F9 - Major 9th Chords - 0-4-7-11-14", NoAction)
Tray.Add("F10 - Minor 9th Chords - 0-3-7-10-13", NoAction)
Tray.Add("F11 - Augmented 9th Chords - 0-4-8-11-14", NoAction)
Tray.Add("F12 - Diminished 9th Chords - 0-3-6-9-12", NoAction)
Tray.Add("CTRL+F1 - Sus2 Chords - 0-2-7", NoAction)
Tray.Add("CTRL+F2 - Sus4 Chords - 0-5-7", NoAction)
Tray.Add("CTRL+F3 - DOMINANT 7th Chords - 0-4-7-10", NoAction)
Tray.Add("CTRL+F4 - Half-Diminished Chords - 0-3-6-10", NoAction)

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
    ToolTip(ChordTypeName) ; Show the tooltip with the chord name
    SetTimer () => ToolTip(), ToolTipDuration ; Show the tooltip for ToolTipDuration seconds
}


; Main function to convert note intervals to shortcut commands
GenerateChord(NotesToAdd) {
    SendEvent("^c")
    ; NotesToAdd is a string fromatted like this 0-4-7". Split the string into an array
    ChordNotes := StrSplit(NotesToAdd, "-")
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
}

#HotIf WinActive(DawHotFixString) and GetKeyState("CapsLock", "T")

; TRIADS
; F1 - MAJOR Chords 0-4-7
F1:: {
    GenerateChord("0-4-7")
    ToolTipChord("MAJOR Chords 0-4-7")
}

; F2 - MINOR Chords 0-3-7
F2:: {
    GenerateChord("0-3-7")
    ToolTipChord("MINOR Chords 0-3-7")
}

; F3 - AUGMENTED Chords 0-4-8
F3:: {
    GenerateChord("0-4-8")
    ToolTipChord("AUGMENTED Chords 0-4-8")
}

; F4 - DIMINISHED Chords 0-3-6
F4:: {
    GenerateChord("0-3-6")
    ToolTipChord("DIMINISHED Chords 0-3-6")
}

;-------------------------------------------------------------------------------

; 7th Chords

; F5 - MAJOR 7th Chords 0-4-7-11
F5:: {
    GenerateChord("0-4-7-11")
    ToolTipChord("MAJOR 7th Chords 0-4-7-11")
}

; F6 - MINOR 7th Chords 0-3-7-10
F6:: {
    GenerateChord("0-3-7-10")
    ToolTipChord("MINOR 7th Chords 0-3-7-10")
}

; F7 - AUGMENTED 7th Chords 0-4-8-11
F7:: {
    GenerateChord("0-4-8-11")
    ToolTipChord("AUGMENTED 7th Chords 0-4-8-11")
}

; F8 - DIMINISHED 7th Chords 0-3-6-9
F8:: {
    GenerateChord("0-3-6-9")
    ToolTipChord("DIMINISHED 7th Chords 0-3-6-9")
}

;-------------------------------------------------------------------------------
; 9th Chords

; F9 - MAJOR 9th Chords 0-4-7-11-14
F9:: {
    GenerateChord("0-4-7-11-14")
    ToolTipChord("MAJOR 9th Chords 0-4-7-11-14")
}

; F10 - MINOR 9th Chords 0-3-7-10-13
F10:: {
    GenerateChord("0-3-7-10-13")
    ToolTipChord("MINOR 9th Chords 0-3-7-10-13")
}

; F11 - AUGMENTED 9th Chords 0-4-8-11-14
F11:: {
    GenerateChord("0-4-8-11-14")
    ToolTipChord("AUGMENTED 9th Chords 0-4-8-11-14")
}

; F12 - DIMINISHED 9th Chords 0-3-6-9-12
F12:: {
    GenerateChord("0-3-6-9-12")
    ToolTipChord("DIMINISHED 9th Chords 0-3-6-9-12")
}


;-------------------------------------------------------------------------------
; Suspended Chords
; CTRL+F1 - Sus2 Chords - 0-2-7
^F1:: {
    GenerateChord("0-2-7")
    ToolTipChord("Sus2 Chords - 0-2-7")
}

; CTRL+F2 - Sus4 Chords - 0-5-7
^F2:: {
    GenerateChord("0-5-7")
    ToolTipChord("Sus4 Chords - 0-5-7")
}

; CTRL+F3 - DOMINANT 7th Chords 0-4-7-10
^F3:: {
    GenerateChord("0-4-7-10")
    ToolTipChord("DOMINANT 7th Chords 0-4-7-10")
}

; CTRL+F4 - Half-Diminished Chords (0-3-6-10)
^F4:: {
    GenerateChord("0-3-6-10")
    ToolTipChord("Half-Diminished Chords (0-3-6-10)")
}


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