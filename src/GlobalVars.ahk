#Requires AutoHotkey v2.0

AppName := "Centomila's Stupid Universal Chord Generator"
AppVersion := "1.0.0"

ChordsIni := StrSplit(IniRead("Chords.ini"), "`n")
ToolTipDuration := IniRead("Settings.ini", "Settings", "ToolTipDuration")

; DAWs
DawList := ["Bitwig Studio", "Ableton Live", "Reason", "NI Maschine 2"]
CurrentDaw := ""

MapHotFixStrings := Map(
    "Bitwig Studio", "ahk_class bitwig",
    "Ableton Live", "ahk_class Ableton Live Window Class",
    "Reason", "ahk_exe Reason.exe",
    "NI Maschine 2", "ahk_exe Maschine 2.exe")

DawHotFixString := "" ; Empty until the script has loaded the correct DAW