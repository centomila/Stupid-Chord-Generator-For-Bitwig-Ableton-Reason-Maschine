#Requires AutoHotkey v2.0

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
Persistent  ; Keep the script running until the user exits it.
#SingleInstance force

; Install resources for compiled script
#Include InstallResources.ahk
InstallBasicResources()

; Includes
#Include GuiEnhancerKit.ahk
#Include GlobalVars.ahk
#Include Tray.ahk
#Include TopGui.ahk
#Include About.ahk
#Include License.ahk
#Include VsCodeReload.ahk
LoadSettings()


LoadSettings() {
    global currentDaw
    global currentToolTipDuration
    global currentChordsIniSet
    global currentDawExeClass
    global currentChordsIniSetFile
    try {
        currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")
    } catch {
        ; If the file or the values don't exist, create them
        IniWrite(DEFAULT_DAW, "Settings.ini", "Settings", "DAW")
        IniWrite(1500, "Settings.ini", "Settings", "ToolTipDuration")
        IniWrite("All Chords", "Settings.ini", "Settings", "ChordIniSet")
        ; set global variables values from the ini file
        currentDaw := IniRead("Settings.ini", "Settings", "DAW")
        currentToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
        currentChordsIniSet := IniRead("Settings.ini", "Settings", "ChordIniSet")
        Reload
    }


    ; Access the appropriate global variable value from the map
    currentDawExeClass := DAW_LIST_EXE_CLASS_MAP.Get(currentDaw)
    currentChordsIniSetFile := CHORDS_INI_LIST.Get(currentChordsIniSet)

    debugTextAllOptions := "Daw: " . currentDaw . " - " . currentDawExeClass . "`nChord Preset: " . currentChordsIniSet . " - " . currentChordsIniSetFile . "`nToolTipDuration: " . currentToolTipDuration . "`n"
    OutputDebug(debugTextAllOptions)
    NewGetChordsIni(currentChordsIniSetFile)
    GenerateTrayMenu()
    ToggleEnable()
}


; Main function to convert note intervals to shortcut commands
GenerateChord(notesInterval, chordTypeName, thisHotkey := "", thisLabel := "") {
    OutputDebug("`nGenerateChord - notesInterval: " . notesInterval . " chordTypeName: " . chordTypeName . " thisHotkey: " . thisHotkey . " thisLabel: " . thisLabel)
    try {
        WinActivate(currentDawExeClass)
    }
    If !WinActive(currentDawExeClass) {
        ; exit function
        ToggleEnable()
        SendInput "{" . thisHotkey . "}"
        return
    }

    if currentDaw == "Reason" {
        if ReasonPianoRollFinder() = false
        {
            MsgBox("Piano Roll not found. Please open it and try again.", "Error")
            Exit
        }
        SendEvent("^l")
        SendEvent("+l")

    }

    SendEvent("{Shift Up}{Ctrl Up}{Alt Up}") ; Reset all modifiers

    SendEvent("^c")
    ; NotesToAdd is a string fromatted like this 0-4-7". Split the string into an array
    chordNotes := StrSplit(notesInterval, " ")
    ; Loop through the array and convert strings into numbers


    Loop chordNotes.Length ; Skip the root note 0
    {
        semitones := chordNotes.Get(A_Index)
        OutputDebug("Semitones: " . semitones)
        switch currentDaw {
            case "Reason":
                if semitones != 0 {
                    SendEvent("^l")
                    SendEvent("^c")
                    SendEvent("!{Left}")
                    if semitones > 0 {
                        SendEvent("^{Up " . semitones . "}")
                    } else if semitones < 0 {
                        semitones := semitones * -1 ; Convert negative numbers to positive
                        SendEvent("^{Down " . semitones . "}")
                    }
                    SendEvent("^v")
                }

            case "NI Maschine 2":
                if semitones != 0 {
                    SendEvent("^c")
                    if semitones > 0 {
                        SendEvent("!{Up " . semitones . "}")
                        Sleep(50)
                    } else if semitones < 0 {
                        semitones := semitones * -1 ; Convert negative numbers to positive
                        SendEvent("!{Down " . semitones . "}")
                    }
                    SendEvent("^v")
                    SendEvent("!{Left}")
                }
            default:
                if semitones != 0 {

                    SendEvent("^c")
                    if semitones > 0 {
                        SendEvent("{Up " . semitones . "}")
                    } else if semitones < 0 {
                        semitones := semitones * -1 ; Convert negative numbers to positive
                        SendEvent("{Down " . semitones . "}")
                    }
                    SendEvent("^v")
                }
        }
    }
    ; Tooltip
    if currentToolTipDuration > 0 {
        thisHotkey := ReplaceShortCutSymbols(thisHotkey)
        toolTipText := CenterTextInTooltip(thisHotkey . "`t" . chordTypeName . "`t" . notesInterval)
        ToolTip(toolTipText, 9999, 9999) ; Show the tooltip with the chord name
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
    ;OutputDebug("ChordsIniArray: " . chordsArray.Length)
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
    If !WinExist(currentDawExeClass) {
        global StatusEnabled := false
        DynamicIniMapping(OnOff := "Off")
        ;OutputDebug(currentDaw . " seems to be closed`n")
        TraySetIcon("Images\ICO\Icon.ico")
        ToolTip CenterTextInTooltip(currentDaw . " seems to be close"), 9999, 9999
        SetTimer () => ToolTip(), -3000 ; Clear the tooltip after 1.5 seconds
    } else {

        If (WinActive(currentDawExeClass) and GetKeyState("CapsLock", "T")) {
            global StatusEnabled := true
            DynamicIniMapping(OnOff := "On")
            ToolTip CenterTextInTooltip(currentChordsIniSet), 9999, 9999
            ToggleTraySetIcon()
        } else {
            global StatusEnabled := false
            DynamicIniMapping(OnOff := "Off")
            ToolTip CenterTextInTooltip("O F F"), 9999, 9999
            ToggleOSDGui()
            ToggleTraySetIcon()
        }
        SetTimer () => ToolTip(), -1500 ; Clear the tooltip after 1.5 seconds
    }
}

ReasonPianoRollFinder() {
    WinActivate(currentDawExeClass)

    CoordMode "Pixel"  ; Interprets the coordinates below as relative to the screen rather than the active window's client area.
    try {
        if (ImageSearch(&FoundX, &FoundY, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "Images\PNG\ReasonPianoRoll1.png")) or (ImageSearch(&FoundX, &FoundY, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "Images\PNG\ReasonPianoRoll2.png")) {

            ; MsgBox "The icon was found at " FoundX "x" FoundY
            Send "+{Click " . FoundX - 20 . " " . FoundY . "}"
            return true
        }
        else
            MsgBox "I can't find the piano roll", "Error", 16
        return false
    } catch as exc {
    MsgBox "Could not conduct the search due to the following error:`n" exc.Message
    }
}

CenterTextInTooltip(text) {
    centeredText := ""
    centeredText := "`n " . text . " `n "
    return centeredText
}

~CapsLock:: ToggleEnable


#HotIf WinActive(currentDawExeClass) and GetKeyState("CapsLock", "T")
; Octave change
; Page Down Select all and move an octave DOWN
PgDn:: {
    SendEvent("^a")
    SendEvent("+{Down}")
}

; Page Up Select all and move an octave UP
PgUp:: {
    SendEvent("^a")
    SendEvent("+{Up}")
}

SC029:: { ; Scan code for backtick or \
    ToggleOSDGui()
}

^SC029:: {
    ChordsMenu()
}
#HotIf