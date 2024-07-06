#Requires AutoHotkey v2.0

DrawGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {

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
            OSDLabel := OSDGui.AddText("Center Y10 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 1)), TextForLabel)           
        }

        if A_Index > 12 and A_Index <= 24 {
            OSDLabel := OSDGui.AddText("Center Y90 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 13)), TextForLabel)           
        }
        if A_Index > 24 and A_Index <= 36 {
            OSDLabel := OSDGui.AddText("Center Y160 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 25)), TextForLabel)
        }
        if A_Index > 36 {
            OSDLabel := OSDGui.AddText("Center Y230 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 37)), TextForLabel)
        }
        OSDLabel.SetFont("s11 q5")

    }

}

ToggleOSDGui(OnOff := "Off") {
    static OSDGui := 0
    if (OnOff == "On" && !OSDGui) {
        ; Calculate the screen width and height
        screenWidth := A_ScreenWidth
        screenHeight := A_ScreenHeight

        ; Calculate the width and height of the GUI
        guiWidth := screenWidth * 1
        guiHeight := 300

        ; Calculate the horizontal position to center the GUI
        guiX := (screenWidth - guiWidth) / 2
        guiY := 0

        ; Create the GUI
        OSDGui := Gui("+AlwaysOnTop -Caption")

        ; Number of columns and rows
        columns := 12
        rows := 4

        ; Calculate the width of each column
        columnWidth := guiWidth / columns
        rowHeight := guiHeight / rows

        ; Add the GUI elements
        DrawGUIElements(OSDGui, columns, rows, columnWidth, rowHeight)
        WinSetTransparent(200, OSDGui.Hwnd)

        OSDGui.OnEvent('Close', (*) => OSDGui.Hide())
        ; Show the GUI
        OSDGui.Show("NA " . "W" . guiWidth . "xCenter " . "Y" . guiY)

    } else if (OnOff == "Off") {
        try {
            OSDGui.Hide()
            
            OSDGui := 0
        }
    }
}
