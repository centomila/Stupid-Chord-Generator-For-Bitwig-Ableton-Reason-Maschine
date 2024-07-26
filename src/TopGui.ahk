#Requires AutoHotkey v2.0

global topGuiOSDButtons := 0
global topGUIOsdStatusBar := 0


ToggleOSDGui() {
    global topGuiOSDButtons
    if (topGuiOSDButtons == 0 && WinExist(currentDawExeClass) && GetKeyState("CapsLock", "T")) {
        topGuiOSDButtons := BuildDeleteOSDGui()
    } else {
        closeTopGuiOSD()
    }
    ToggleCurrentChordOsdBar()
}

BuildDeleteOSDGui() {
    ; Create the GUI without button in the taskbar
    global topGuiOSDButtons := GuiExt("+AlwaysOnTop -Caption +ToolWindow +DPIScale ")

    topGuiOSDButtons.SetDarkTitle()
    topGuiOSDButtons.SetDarkMenu()
    topGuiOSDButtons.BackColor := 0x202020
    topGuiOSDButtons.SetWindowColor(, topGuiOSDButtons.BackColor, topGuiOSDButtons.BackColor)
    topGuiOSDButtons.MarginX := 15
    topGuiOSDButtons.MarginY := 15


    OutputDebug("DPI:" . A_ScreenDPI)
    ; Number of columns and rows
    columns := 12
    rows := 4

    guiWidth := SCREEN_WIDTH - topGuiOSDButtons.MarginX
    if (DPI = 192) {
        guiWidth := SCREEN_WIDTH / 2 - topGuiOSDButtons.MarginX
    }
    guiHeight := 400


    ; Calculate the width of each column
    columnWidth := guiWidth / columns
    rowHeight := guiHeight / rows

    ; Add the GUI elements
    AddGUIElements(topGuiOSDButtons, columns, rows, columnWidth, rowHeight)


    textCurrentSet := topGuiOSDButtons.AddText("X0 Y+7 Center W" . guiWidth . " H" . 18, "Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    textCurrentSet.OnEvent("Click", (*) => ToggleOSDGui())
    textCurrentSet.OnEvent("ContextMenu", (*) => ChordsMenu())

    ; Set the transparency
    WinSetTransparent(250, topGuiOSDButtons.Hwnd)

    topGuiOSDButtons.Title := currentChordsIniSet
    topGuiOSDButtons.OnEvent('Close', (*) => topGuiOSDButtons.Hide())
    topGuiOSDButtons.Show("NA AutoSize " . "W" . guiWidth . " xCenter Y0")
    return topGuiOSDButtons
}


AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
    for chords in chordsArray {
        chordName := StrReplace(chords[1], "(", "`n(")
        chordInterval := chords[2]
        shortcutKey := chords[3]

        textForLabel := chordName . "`n" . chordInterval . "`n" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        if A_Index <= 12 {
            OSDButton := OSDGui.AddButton("Center Y" . topGuiOSDButtons.MarginY  .   " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 1) + topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)+topGuiOSDButtons.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 13)+ topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*2+topGuiOSDButtons.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 25)+ topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*3+topGuiOSDButtons.MarginY . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 37)+ topGuiOSDButtons.MarginX), textForLabel)
        }
        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        OSDButton.SetFont("s10 c0xFFFFFF q5", "Segoe UI")

        ; Create a closure to capture the current values
        OSDButton.OnEvent("Click", ((intervalCopy, nameCopy) => (*) => GenerateChord(intervalCopy, nameCopy,,,true))(chordInterval, chordName))
    }
    
}


closeTopGuiOSD(*) {
    try {
        topGuiOSDButtons.Destroy()
    }
    global topGuiOSDButtons := 0
    return
}


ToggleCurrentChordOsdBar() {
    global topGUIOsdStatusBar

    if (topGUIOsdStatusBar) or !WinExist(currentDawExeClass) or !GetKeyState("CapsLock", "T") {
        try topGUIOsdStatusBar.Destroy()
        topGUIOsdStatusBar := 0
        return
    }
    if GetKeyState("CapsLock", "T") {
    topGUIOsdStatusBar := GuiExt()
    topGUIOsdStatusBar.Opt("+AlwaysOnTop -Caption +ToolWindow")
    topGUIOsdStatusBar.MarginX := 0
    topGUIOsdStatusBar.MarginY := 0
    topGUIOsdStatusBar.SetWindowColor(, topGUIOsdStatusBar.BackColor, topGUIOsdStatusBar.BackColor)
    topGUIOsdStatusBar.SetDarkTitle()
    topGUIOsdStatusBar.SetDarkMenu()
    topGUIOsdStatusBar.BackColor := 0x202020
    
    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    width := SCREEN_WIDTH - topGUIOsdStatusBar.MarginX
    if (DPI = 192) {
        width := SCREEN_WIDTH / 2 - topGUIOsdStatusBar.MarginX
    }
    height := 32

    textCurrentSet := topGUIOsdStatusBar.AddText("Y3 Center h20 w" . width/2 ,"Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    textCurrentSet.OnEvent("Click", (*) => ToggleOSDGui())
    textCurrentSet.OnEvent("ContextMenu", (*) => ChordsMenu())

    btnOpenCurrentSet := topGUIOsdStatusBar.AddButton("Y3 Right h20 w" . width/2 ,"Open")
    
    WinSetTransparent(250, topGUIOsdStatusBar.Hwnd)
    topGUIOsdStatusBar.Show(Format("x{} y{} w{} h{} NoActivate", (left+width/2), top, width/2, height))
    }
}