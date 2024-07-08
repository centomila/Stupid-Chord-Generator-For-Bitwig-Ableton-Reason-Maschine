#Requires AutoHotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent  ; Keep the script running until the user exits it.
#SingleInstance force
#Include GlobalVars.ahk
#Include Tray.ahk
#Include TopGui.ahk
#Include About.ahk
; #Include VsCodeReload.ahk


LoadSettings() {
    try {
        global currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        global currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        global currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")
    } catch {
        IniWrite(DEFAULT_DAW, "Settings.ini", "Settings", "DAW")
        IniWrite(1500, "Settings.ini", "Settings", "ToolTipDuration")
        IniWrite("Chords.ini", "Settings.ini", "Settings", "ChordIniSet")
        global currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        global currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        global currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")

    }
    dawMenu.Check(currentDaw)
    tooltipMenu.Check(currentToolTipDuration)
    chordsIniListMenu.Check(currentChordsIniSet)

    global dawHotFixString := DAW_LIST_EXE_CLASS_MAP.Get(currentDaw)
    OutputDebug("Current DAW: " . currentDaw . " - " . dawHotFixString)
}
LoadSettings()

; Main function to convert note intervals to shortcut commands
GenerateChord(notesInterval, chordTypeName, thisHotkey := "", thisLabel := "") {
    If !WinActive(dawHotFixString) {
        ; exit function
        ToggleEnable()
        SendInput "{" . thisHotkey . "}"
        return
    }
    SendEvent("{Shift Up}{Ctrl Up}{Alt Up}") ; Reset all modifiers

    SendEvent("^c")
    ; NotesToAdd is a string fromatted like this 0-4-7". Split the string into an array
    chordNotes := StrSplit(notesInterval, "-")
    ; Loop through the array and convert strings into numbers
    Loop chordNotes.Length - 1 ; Skip the root note 0
    {
        semitones := chordNotes.Get(A_Index + 1)

        switch currentDaw {
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
    if currentToolTipDuration > 0 {
        thisHotkey := ReplaceShortCutSymbols(thisHotkey)
        ToolTip("`n" . thisHotkey . "`n`n" . chordTypeName . "`n`n " . notesInterval . "`n ") ; Show the tooltip with the chord name
        SetTimer () => ToolTip(), currentToolTipDuration ; Show the tooltip for ToolTipDuration seconds
    }
    return
}

GetChordsInfoFromIni(section) {
    chordName := StrSplit(StrSplit(section, "`n")[1], "=")[2]
    chordInterval := StrSplit(StrSplit(section, "`n")[2], "=")[2]
    shortcutKey := StrSplit(StrSplit(section, "`n")[3], "=")[2]
    return [chordName, chordInterval, shortcutKey]
}


DynamicIniMapping(onOff := "Off") {
    for sections in chordsIni {
        section := IniRead("Chords.ini", sections)
        chordName := GetChordsInfoFromIni(section)[1]
        chordInterval := GetChordsInfoFromIni(section)[2]
        shortcutKey := GetChordsInfoFromIni(section)[3]

        Hotkey(shortcutKey, GenerateChord.Bind(chordInterval, chordName), onOff)
    }

}

; Function to change the system tray icon based on the Caps Lock state.
ToggleEnable() {
    If (WinActive(dawHotFixString) and GetKeyState("CapsLock", "T")) {
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


#HotIf WinActive(dawHotFixString) and GetKeyState("CapsLock", "T")
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