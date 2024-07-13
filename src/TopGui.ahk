#Requires AutoHotkey v2.0

global topGuiOSD := 0

ToggleOSDGui() {
    global topGuiOSD
    if (topGuiOSD == 0 && WinActive(currentDawExeClass) && GetKeyState("CapsLock", "T")) {
        topGuiOSD := BuildDeleteOSDGui()
    } else {
        closeTopGuiOSD()
    }
}

BuildDeleteOSDGui() {
        ; Create the GUI without button in the taskbar
        topGuiOSD := Gui("+AlwaysOnTop -Caption +ToolWindow +DPIScale ")
        ; Calculate the screen width and height
        

        OutputDebug("DPI:" . A_ScreenDPI)
        ; Number of columns and rows
        columns := 12
        rows := 4

        guiWidth := Ceil(SCREEN_WIDTH)
        if (DPI = 192) {
            guiWidth := Ceil(SCREEN_WIDTH) / 2
        }
        guiHeight := 280


        ; Calculate the width of each column
        columnWidth := guiWidth / columns
        rowHeight := guiHeight / rows


        topGuiOSD.BackColor := "0x111111"

        ; Add the GUI elements
        AddGUIElements(topGuiOSD, columns, rows, columnWidth, rowHeight)

        ; Set the transparency
        WinSetTransparent(230, topGuiOSD.Hwnd)
        topGuiOSD.Title := currentChordsIniSet
        topGuiOSD.OnEvent('Close', (*) => topGuiOSD.Hide())
        ; Show the GUI
        topGuiOSD.SetDarkTitle()
        topGuiOSD.SetDarkMenu()

        topGuiOSD.Show("NA AutoSize " . "W" . guiWidth . " xCenter Y0")
        return topGuiOSD
}


AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
    for chords in chordsArray {
        chordName := StrReplace(chords[1], "(", "`n(")
        chordInterval := chords[2]
        shortcutKey := chords[3]

        textForLabel := ChordName . "`n" . chordInterval . "`n" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        if A_Index <= 12 {
            OSDLabel := OSDGui.AddText("Center Y20 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 1)), textForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 13)), textForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight * 2 + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 25)), textForLabel)
        } else if A_Index > 36 {
            OSDLabel := OSDGui.AddText("Center Y" . rowHeight * 3 + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 37)), textForLabel)
        }
        OSDLabel.SetFont("s10 q5 w800 c0xFFFFFF")
    }
}


closeTopGuiOSD(*) {
    try {
        topGuiOSD.Destroy()
    }
    global topGuiOSD := 0
    return
}