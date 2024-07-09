#Requires AutoHotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent  ; Keep the script running until the user exits it.
#SingleInstance force

; Install resources for compiled script
#Include InstallResources.ahk
InstallBasicResources() 

; Includes
#Include GlobalVars.ahk
#Include Tray.ahk
#Include TopGui.ahk
#Include About.ahk
#Include VsCodeReload.ahk
LoadSettings()



LoadSettings() {
    try {
        global currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        global currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        global currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")
    } catch {
        ; If the file or the values don't exist, create them
        IniWrite(DEFAULT_DAW, "Settings.ini", "Settings", "DAW")
        IniWrite(1500, "Settings.ini", "Settings", "ToolTipDuration")
        IniWrite("All Chords", "Settings.ini", "Settings", "ChordIniSet")
        ; set global variables values from the ini file
        global currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        global currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        global currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")
        Reload
    }


    ; Access the appropriate global variable value from the map
    global currentDawExeClass := DAW_LIST_EXE_CLASS_MAP.Get(currentDaw)
    global currentChordsIniSetFile := CHORDS_INI_LIST.Get(currentChordsIniSet)

    debugTextAllOptions := "Current Chord Set: " . currentChordsIniSet . " - " . currentChordsIniSetFile . " - " . currentToolTipDuration . " - " . currentDaw . " - " . currentDawExeClass
    OutputDebug(debugTextAllOptions)
    NewGetChordsIni(currentChordsIniSetFile)
    GenerateTrayMenu()
    ResetCheckboxes()
    ToggleEnable()
}



; Main function to convert note intervals to shortcut commands
GenerateChord(notesInterval, chordTypeName, thisHotkey := "", thisLabel := "") {
    If !WinActive(currentDawExeClass) {
        ; exit function
        ToggleEnable()
        SendInput "{" . thisHotkey . "}"
        return
    }
    SendEvent("{Shift Up}{Ctrl Up}{Alt Up}") ; Reset all modifiers

    SendEvent("^c")
    ; NotesToAdd is a string fromatted like this 0-4-7". Split the string into an array
    ; TODO Change the split with spaces instead of -. Then add the case to make inversions
    chordNotes := StrSplit(notesInterval, " ")
    ; Loop through the array and convert strings into numbers
    Loop chordNotes.Length - 1 ; Skip the root note 0
    {
        semitones := chordNotes.Get(A_Index + 1)
        OutputDebug("Semitones: " . semitones)
        switch currentDaw {
            case "Reason":
                SendEvent("^l")
                SendEvent("^c")
                SendEvent("!{Left}")
                if semitones > 0 {
                    SendEvent("{Up " . semitones . "}")
                } else {
                    ; Convert negative numbers to positive
                    semitones := semitones * -1
                    SendEvent("{Down " . semitones . "}")
                }
                SendEvent("^v")
                
            case "NI Maschine 2":
                SendEvent("^c")
                if semitones > 0 {
                    SendEvent("{Up " . semitones . "}")
                } else {
                    ; Convert negative numbers to positive
                    semitones := semitones * -1
                    SendEvent("{Down " . semitones . "}")
                }
                SendEvent("^v")
                SendEvent("!{Left}")

            default:
                SendEvent("^c")
                if semitones > 0 {
                    SendEvent("{Up " . semitones . "}")
                } else {
                    ; Convert negative numbers to positive
                    semitones := semitones * -1
                    SendEvent("{Down " . semitones . "}")
                }
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

ReplaceShortCutSymbols(shortcutKeyString) {
    shortcutKeyString := StrReplace(shortcutKeyString, "+", "SHIFT - ")
    shortcutKeyString := StrReplace(shortcutKeyString, "^", "CTRL - ")
    shortcutKeyString := StrReplace(shortcutKeyString, "!", "ALT - ")
    return shortcutKeyString
}

NewGetChordsIni(ChordsIniFile := "Chords.ini") {
    splitChordsIni := StrSplit(IniRead(ChordsIniFile), "`n")
    global chordsArray := Array()
    for sections in splitChordsIni {
        ChordName := IniRead(CHORDS_INI_LIST.Get(currentChordsIniSet), sections, "ChordName")
        ChordInterval := IniRead(CHORDS_INI_LIST.Get(currentChordsIniSet), sections, "ChordInterval")
        ShortcutKey := IniRead(CHORDS_INI_LIST.Get(currentChordsIniSet), sections, "ShortcutKey")
        ; add elements to the array
        chordsArray.Push([ChordName, ChordInterval, ShortcutKey])
    }
    OutputDebug("ChordsIniArray: " . chordsArray.Length)
    return chordsArray
}


DynamicIniMapping(onOff := "Off") {
    for chords in chordsArray {
        chordName := chords[1]
        chordInterval := chords[2]
        shortcutKey := chords[3]

        Hotkey(shortcutKey, GenerateChord.Bind(chordInterval, chordName), onOff)
    }
}

; Function to change the system tray icon based on the Caps Lock state.
ToggleEnable() {
    If (WinActive(currentDawExeClass) and GetKeyState("CapsLock", "T")) {
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


#HotIf WinActive(currentDawExeClass) and GetKeyState("CapsLock", "T")
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