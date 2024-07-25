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
    global topGuiOSD := GuiExt("+AlwaysOnTop -Caption +ToolWindow +DPIScale ")

    topGuiOSD.SetDarkTitle()
    topGuiOSD.SetDarkMenu()
    topGuiOSD.BackColor := 0x202020
    topGuiOSD.SetWindowColor(, topGuiOSD.BackColor, topGuiOSD.BackColor)
    topGuiOSD.MarginX := 15
    topGuiOSD.MarginY := 15


    OutputDebug("DPI:" . A_ScreenDPI)
    ; Number of columns and rows
    columns := 12
    rows := 4

    guiWidth := SCREEN_WIDTH - topGuiOSD.MarginX
    if (DPI = 192) {
        guiWidth := SCREEN_WIDTH / 2 - topGuiOSD.MarginX
    }
    guiHeight := 400


    ; Calculate the width of each column
    columnWidth := guiWidth / columns
    rowHeight := guiHeight / rows

    ; Add the GUI elements
    AddGUIElements(topGuiOSD, columns, rows, columnWidth, rowHeight)

    ; Set the transparency
    WinSetTransparent(250, topGuiOSD.Hwnd)

    ; topGuiOSD.SetFont("cWhite s16", "Segoe UI")

    topGuiOSD.Title := currentChordsIniSet
    topGuiOSD.OnEvent('Close', (*) => topGuiOSD.Hide())
    topGuiOSD.Show("NA AutoSize " . "W" . guiWidth . " xCenter Y0")
    return topGuiOSD
}


AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
    for chords in chordsArray {
        chordName := StrReplace(chords[1], "(", "`n(")
        chordInterval := chords[2]
        shortcutKey := chords[3]

        textForLabel := chordName . "`n" . chordInterval . "`n" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        if A_Index <= 12 {
            OSDButton := OSDGui.AddButton("Center Y" . topGuiOSD.MarginY  .   " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 1) + topGuiOSD.MarginX), textForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)+topGuiOSD.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 13)+ topGuiOSD.MarginX), textForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*2+topGuiOSD.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 25)+ topGuiOSD.MarginX), textForLabel)
        } else if A_Index > 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*3+topGuiOSD.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 37)+ topGuiOSD.MarginX), textForLabel)
        }
        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        ; OSDButton.BackColor := 0x202020
        ; OSDButton.Color := 0xFFFFFF
        OSDButton.SetFont("s10 c0xFFFFFF q5", "Segoe UI")


        ; Create a closure to capture the current values
        OSDButton.OnEvent("Click", ((intervalCopy, nameCopy) => (*) => GenerateChord(intervalCopy, nameCopy,,,true))(chordInterval, chordName))
    }
}


closeTopGuiOSD(*) {
    try {
        topGuiOSD.Destroy()
    }
    global topGuiOSD := 0
    return
}


ToggleCurrentChordOsdBar() {
    static osdCapsLockOnGUI := 0

    if (osdCapsLockOnGUI) or !WinActive(currentDawExeClass) or !GetKeyState("CapsLock", "T") {
        try osdCapsLockOnGUI.Destroy()
        osdCapsLockOnGUI := 0
        return
    }
    if GetKeyState("CapsLock", "T") {
    osdCapsLockOnGUI := GuiExt()
    osdCapsLockOnGUI.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    osdCapsLockOnGUI.MarginX := 0
    osdCapsLockOnGUI.MarginY := 0
    osdCapsLockOnGUI.SetWindowColor(, osdCapsLockOnGUI.BackColor, osdCapsLockOnGUI.BackColor)
    osdCapsLockOnGUI.SetDarkTitle()
    osdCapsLockOnGUI.SetDarkMenu()
    osdCapsLockOnGUI.BackColor := 0x202020
    
    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    width := SCREEN_WIDTH - osdCapsLockOnGUI.MarginX
    if (DPI = 192) {
        width := SCREEN_WIDTH / 2 - osdCapsLockOnGUI.MarginX
    }
    height := 32

    textCurrentSet := osdCapsLockOnGUI.AddText("y3 Center r3 w" . width/2 ,"Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    
    WinSetTransparent(250, osdCapsLockOnGUI.Hwnd)
    osdCapsLockOnGUI.Show(Format("x{} y{} w{} h{} NoActivate", (left+width/2), top, width/2, height))
    }
}