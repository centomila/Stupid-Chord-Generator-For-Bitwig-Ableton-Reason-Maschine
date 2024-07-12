#Requires AutoHotkey v2.0

global osd := false

ToggleOSDGui() {
    static OSDGui := 0
    if (osd == false && !OSDGui) {
        OSDGui := BuildDeleteOSDGui()
        global osd := true
    } else if (osd = true) {
        OSDGui := BuildDeleteOSDGui()
        global osd := false
    }
}

BuildDeleteOSDGui() {
    static osdGui := 0
    if (osd == false && !osdGui && WinActive(currentDawExeClass) && GetKeyState("CapsLock", "T")) {
        ; Calculate the screen width and height
        screenWidth := A_ScreenWidth
        screenHeight := A_ScreenHeight
        DPI := A_ScreenDPI

        OutputDebug("DPI:" . A_ScreenDPI)
        ; Number of columns and rows
        columns := 12
        rows := 4

        guiWidth := Ceil(screenWidth)
        if (DPI = 192) {
            guiWidth := Ceil(screenWidth) / 2
        }
        guiHeight := 350

        ; Calculate the horizontal position to center the GUI
        guiX := (screenWidth - guiWidth) / 2
        guiY := 0

        ; Calculate the width of each column
        columnWidth := guiWidth / columns
        rowHeight := guiHeight / rows

        ; Create the GUI without button in the taskbar
        osdGui := Gui("+AlwaysOnTop -Caption +ToolWindow +DPIScale")

        osdGui.BackColor := "0x111111"

        ; Add the GUI elements
        AddGUIElements(osdGui, columns, rows, columnWidth, rowHeight)

        ; Set the transparency
        WinSetTransparent(230, osdGui.Hwnd)
        osdGui.Title := currentChordsIniSet
        osdGui.OnEvent('Close', (*) => osdGui.Hide())
        ; Show the GUI
        osdGui.SetDarkTitle()

        osdGui.Show("NA AutoSize " . "W" . guiWidth . "xCenter Y0")
        return osdGui
    } else {
        try {
            osdGui.Hide() ; Hide the GUI before destroying it
            osdGui.Destroy() ; Destroy the GUI
            osdGui := 0
            global osd := false
        }
    }
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