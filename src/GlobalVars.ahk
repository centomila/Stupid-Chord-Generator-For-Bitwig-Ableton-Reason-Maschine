#Requires AutoHotkey v2.0

AppName := "Centomila's Stupid Universal Chord Generator"
AppVersion := "1.0.0"

ChordsIni := StrSplit(IniRead("Chords.ini"), "`n")

; Tooltip Duration
ToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")
ToolTipDurationOptions := [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]

; DAWs
DawList := ["Bitwig Studio", "Ableton Live", "Reason", "NI Maschine 2"]
CurrentDaw := ""

MapHotFixStrings := Map(
    "Bitwig Studio", "ahk_class bitwig",
    "Ableton Live", "ahk_class Ableton Live Window Class",
    "Reason", "ahk_exe Reason.exe",
    "NI Maschine 2", "ahk_exe Maschine 2.exe")

DawHotFixString := "" ; Empty until the script has loaded the correct DAW