#Requires AutoHotkey v2.0

APP_NAME := "Centomila's Stupid Universal Chord Generator"
APP_VERSION := "1.0.0"

StatusEnabled := false

GenerateChordsMap() {
    chordsMap := Map()
    Loop Files, "Chords\*.ini"
    {
        filePath := A_LoopFilePath
        fileName := A_LoopFileName
        nameKey := StrReplace(StrReplace(fileName, ".ini"), "-", " ")
        chordsMap[nameKey] := filePath
        debugText := nameKey . " - " . filePath
        OutputDebug(debugText)
    }
    return chordsMap
}

; Usage:
CHORDS_INI_LIST := GenerateChordsMap()
currentChordsIniSet := ""
currentChordsIniSetFile := ""

chordsArray := []

; Tooltip Duration
TOOLTIP_DURATION_LIST := [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
currentToolTipDuration := 0

; DAWs
DEFAULT_DAW := "Bitwig Studio"
DAW_LIST_EXE_CLASS_MAP := Map(
    "Bitwig Studio", "ahk_class bitwig",
    "Ableton Live", "ahk_class Ableton Live Window Class",
    "Reason", "ahk_exe Reason.exe",
    "NI Maschine 2", "ahk_exe Maschine 2.exe")
currentDaw := ""
currentDawExeClass := "" ; Empty until the script has loaded the correct DAW

ZWSP := Chr(0x200B) ; Zero Width Space