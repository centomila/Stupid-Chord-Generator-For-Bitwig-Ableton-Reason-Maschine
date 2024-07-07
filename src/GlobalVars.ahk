#Requires AutoHotkey v2.0

APP_NAME := "Centomila's Stupid Universal Chord Generator"
APP_VERSION := "1.0.0"

chordsIni := StrSplit(IniRead("Chords.ini"), "`n")

; Tooltip Duration
toolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
toolTipDurationOptions := [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]

; DAWs
DAW_LIST := ["Bitwig Studio", "Ableton Live", "Reason", "NI Maschine 2"]
currentDaw := ""

DAW_LIST_EXE_CLASS_MAP := Map(
    "Bitwig Studio", "ahk_class bitwig",
    "Ableton Live", "ahk_class Ableton Live Window Class",
    "Reason", "ahk_exe Reason.exe",
    "NI Maschine 2", "ahk_exe Maschine 2.exe")

dawHotFixString := "" ; Empty until the script has loaded the correct DAW

ReplaceShortCutSymbols(shortcutKeyString) {
    shortcutKeyString := StrReplace(shortcutKeyString, "+", "SHIFT - ")
    shortcutKeyString := StrReplace(shortcutKeyString, "^", "CTRL - ")
    shortcutKeyString := StrReplace(shortcutKeyString, "!", "ALT - ")
    return shortcutKeyString
}