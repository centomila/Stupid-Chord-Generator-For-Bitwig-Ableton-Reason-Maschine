#Requires AutoHotkey v2.0

global OSD := false

ToggleOSDGui() {
    static OSDGui := 0
    if (OSD == false && !OSDGui) {
        OSDGui := BuildDeleteOSDGui()
        global OSD := true
    } else if (OSD = true) {
        OSDGui := BuildDeleteOSDGui()
        global OSD := false
    }
}

BuildDeleteOSDGui() {
    static OSDGui := 0
    if (OSD == false && !OSDGui && GetKeyState("CapsLock", "T")) {
        ; Calculate the screen width and height
        screenWidth := A_ScreenWidth
        screenHeight := A_ScreenHeight

        ; Calculate the width and height of the GUI
        guiWidth := screenWidth * 1
        guiHeight := screenHeight / 2.5

        ; Calculate the horizontal position to center the GUI
        guiX := (screenWidth - guiWidth) / 2
        guiY := 0

        ; Create the GUI without button in the taskbar
        OSDGui := Gui("+AlwaysOnTop -Caption")

        ; Number of columns and rows
        columns := 12
        rows := 4

        ; Calculate the width of each column
        columnWidth := guiWidth / columns
        rowHeight := guiHeight / rows

        ; Add the GUI elements
        AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight)

        ; Set the transparency
        WinSetTransparent(230, OSDGui.Hwnd)

        OSDGui.OnEvent('Close', (*) => OSDGui.Hide())
        ; Show the GUI
        OSDGui.Show("NA AutoSize " . "W" . guiWidth . "xCenter Y0 H" . guiHeight)
        return OSDGui
    } else {
        try {
            OSDGui.Hide() ; Hide the GUI before destroying it
            OSDGui.Destroy() ; Destroy the GUI
            OSDGui := 0
            global OSD := false
        }
    }
}


AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
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

        if A_Index <= 12 {
            OSDLabel := OSDGui.AddText("Center Y20 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 1)), TextForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 13)), TextForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight*2 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 25)), TextForLabel)
        } else if A_Index > 36 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight*3 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 37)), TextForLabel)
        }
        OSDLabel.SetFont("s10 q5")
    }
}