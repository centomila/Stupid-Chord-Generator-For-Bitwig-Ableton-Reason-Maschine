#Requires AutoHotkey v2.0

; Function to Draw the GUI elements
DrawGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {

    for i, sections in ChordsIni {
        if (i > 12) {
            break
        }
        section := IniRead("Chords.ini", sections)
        ChordName := StrSplit(StrSplit(section, "`n")[1], "=")[2]
        ChordInterval := StrSplit(StrSplit(section, "`n")[2], "=")[2]
        ShortCutKey := StrSplit(StrSplit(section, "`n")[3], "=")[2]
        OSDLabel := OSDGui.AddText("Center X" . (columnWidth * (A_Index - 1)) . " Y0" . " W" . columnWidth - 2 . " H" . rowHeight, ChordName . "`n(" . ChordInterval . ")`n" . ShortCutKey)
        OSDLabel.SetFont("s12 q5 w800")
        OSDLabel.MarginX := 50
        OSDLabel.MarginY := 50
    }
}

ToggleOSDGui(OnOff := "Off") {
    static OSDGui := 0
    if (OnOff == "On") {
        ; Calculate the screen width and height
        screenWidth := A_ScreenWidth
        screenHeight := A_ScreenHeight

        ; Calculate the width and height of the GUI
        guiWidth := screenWidth * 0.95
        guiHeight := 60

        ; Calculate the horizontal position to center the GUI
        guiX := (screenWidth - guiWidth) / 2
        guiY := 10

        ; Create the GUI
        OSDGui := Gui("+AlwaysOnTop -Caption")

        ; Number of columns and rows
        columns := 12
        rows := 1

        ; Calculate the width of each column
        columnWidth := guiWidth / columns
        rowHeight := guiHeight / rows

        ; Add the GUI elements
        DrawGUIElements(OSDGui, columns, rows, columnWidth, rowHeight)
        WinSetTransparent(155, OSDGui.Hwnd)

        OSDGui.OnEvent('Close', (*) => OSDGui := 0)
        ; Show the GUI
        OSDGui.Show("NA AutoSize " "W" guiWidth "xCenter " "Y" guiY)

    } else if (OnOff == "Off" and OSDGui != 0) {
        OSDGui.Destroy()
        OSDGui := 0
    }
}