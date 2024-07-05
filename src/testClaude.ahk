#Requires AutoHotkey v2.0

; Your original functions (simplified for testing)
GenerateChord(interval) {
    MsgBox("GenerateChord called with interval: " . interval)
}

ToolTipChord(message) {
    ToolTip(message)
    SetTimer(() => ToolTip(), -2000)  ; Remove tooltip after 2 seconds
}

; Function to create a single hotkey
CreateHotkey(key, interval, name) {
    Hotkey(key, ChordCallback.Bind(interval, name))
}

; Callback function for the hotkeys
ChordCallback(interval, name, *) {
    MsgBox("Chord triggered: " . name . " with interval " . interval)
    GenerateChord(interval)
    ToolTipChord(name . " Chords " . interval)
}

; Function to create hotkeys from the INI file
CreateChordHotkeys(section) {
    chords := IniRead("chords.ini", section)
    
    Loop Parse, chords, "`n", "`r"
    {
        parts := StrSplit(A_LoopField, "=")
        if (parts.Length != 2)
            continue
        
        chordName := parts[1]
        chordData := StrSplit(parts[2], ",")
        if (chordData.Length != 3)
            continue
        
        interval := chordData[2]
        shortcut := chordData[3]
        
        try {
            CreateHotkey(shortcut, interval, chordName)
            MsgBox("Hotkey created: " . shortcut . " for " . chordName)
        } catch as err {
            MsgBox("Error creating hotkey: " . shortcut . "`nError: " . err.Message)
        }
    }
}

; Create hotkeys for each section in the INI file
sections := ["TRIADS", "7TH_CHORDS", "9TH_CHORDS", "SUSPENDED_CHORDS"]
for section in sections {
    CreateChordHotkeys(section)
}

; Keep the script running
Persistent