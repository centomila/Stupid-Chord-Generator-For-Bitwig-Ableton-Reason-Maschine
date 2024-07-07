; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent  ; Keep the script running until the user exits it.
#SingleInstance force
#Include GlobalVars.ahk
#Include Tray.ahk
#Include TopGui.ahk
#Include About.ahk
#Include VsCodeReload.ahk

try {
    IniRead("Settings.ini", "Settings", "ToolTipDuration")
} catch {
    IniWrite(1500, "Settings.ini", "Settings", "ToolTipDuration")
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
GenerateChord(NotesInterval, ChordTypeName, ThisHotkey := "", ThisLabel := "") {
    If !WinActive(DawHotFixString) {
        ; exit function
        ToggleEnable()
        SendInput "{" . ThisHotkey . "}"
        return
    }
    SendEvent("{Shift Up}{Ctrl Up}{Alt Up}") ; Reset all modifiers

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
    ; Tooltip
    ToolTip("`n" . ChordTypeName . "`n ") ; Show the tooltip with the chord name
    SetTimer () => ToolTip(), ToolTipDuration ; Show the tooltip for ToolTipDuration seconds
}


AddChordsToTray() {
    Tray.Add("F1/F12 - Basic Chords", NoAction, "BarBreak") ; Creates a separator line.
    Tray.Add()
    for sections in ChordsIni {
        section := IniRead("Chords.ini", sections)
        chordInfo := GetChordsInfoFromIni(section)
        ChordName := chordInfo[1]
        ChordInterval := chordInfo[2]
        TextForLabel := chordInfo[3]

        TextForLabel := ChordName . "`n(" . ChordInterval . ")`n" . TextForLabel
        TextForLabel := StrReplace(TextForLabel, "+", "SHIFT - ")
        TextForLabel := StrReplace(TextForLabel, "^", "CTRL - ")
        TextForLabel := StrReplace(TextForLabel, "!", "ALT - ")
        if (A_Index == 13) {
            Tray.Add()
            Tray.Add("CTRL+F1/CTRL+F12 - Advanced Chords", NoAction, "") ; Creates a separator line.
            Tray.Add()
        }
        if (A_Index == 25) {
            Tray.Add("SHIFT+F1/SHIFT+F12 - Advanced Chords", NoAction, "BarBreak") ; Creates a separator line.
            Tray.Add()
        }
        if (A_Index == 37) {
            Tray.Add()
            Tray.Add("ALT+F1/ALT+F12 - Advanced Chords", NoAction, "") ; Creates a separator line.
            Tray.Add()
        }
        Tray.Add(TextForLabel . A_Tab . chordName . "  (" . chordInterval . ")", NoAction)
    }
}

GetChordsInfoFromIni(section) {
    ChordName := StrSplit(StrSplit(section, "`n")[1], "=")[2]
    ChordInterval := StrSplit(StrSplit(section, "`n")[2], "=")[2]
    ShortCutKey := StrSplit(StrSplit(section, "`n")[3], "=")[2]
    return [ChordName, ChordInterval, ShortCutKey]
}


DynamicIniMapping(OnOff := "Off") {
    for sections in ChordsIni {
        section := IniRead("Chords.ini", sections)
        chordInfo := GetChordsInfoFromIni(section)
        ChordName := chordInfo[1]
        ChordInterval := chordInfo[2]
        ShortCutKey := chordInfo[3]

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
        ToggleOSDGui()
        ; TraySetIcon(IconOff) ; Set the system tray icon to the "F13-OFF.ico" icon.
    }
    SetTimer () => ToolTip(), -1500 ; Clear the tooltip after 1.5 seconds
}

~CapsLock:: ToggleEnable


#HotIf WinActive(DawHotFixString) and GetKeyState("CapsLock", "T")
; Octave change
; Page Down Select all and move an octave DOWN
PgDn:: {
    SendEvent("((^a)(+{Down}))")
}

; Page Up Select all and move an octave UP
PgUp:: {
    SendEvent("((^a)(+{Up}))")
}

SC029:: { ; Scan code for backtick or \
    ToggleOSDGui()
}
#HotIf