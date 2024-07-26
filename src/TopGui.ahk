#Requires AutoHotkey v2.0

global topGuiOSDButtons := 0
global topGuiOSDBarOnly := true

BuildTopOSDGui() {
    global topGuiOSDBarOnly
    ; Create the GUI without button in the taskbar
    CloseTopGuiOSD()
    global topGuiOSDButtons := GuiExt("+AlwaysOnTop -Caption +ToolWindow +DPIScale ")

    topGuiOSDButtons.SetDarkTitle()
    topGuiOSDButtons.SetDarkMenu()
    topGuiOSDButtons.BackColor := 0x202020
    topGuiOSDButtons.SetWindowColor(, topGuiOSDButtons.BackColor, topGuiOSDButtons.BackColor)
    topGuiOSDButtons.MarginX := 15
  

    OutputDebug("DPI:" . A_ScreenDPI)
    ; Number of columns and rows
    columns := 12
    rows := 4

    guiWidth := SCREEN_WIDTH - topGuiOSDButtons.MarginX
    if (DPI = 192) {
        guiWidth := SCREEN_WIDTH / 2 - topGuiOSDButtons.MarginX
    }
    guiHeight := 420

    ; Calculate the width of each column
    columnWidth := guiWidth / columns
    rowHeight := guiHeight / rows
    
    if topGuiOSDBarOnly {
        topGuiOSDBarWidth := guiWidth / 3
    } else {
        topGuiOSDBarWidth := guiWidth
    }


    textCurrentSet := topGuiOSDButtons.AddText(" r2 Center W" . topGuiOSDBarWidth . " y1" , "Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    textCurrentSet.OnEvent("Click", (*) => ToggleBarTopGuiOSD())
    textCurrentSet.OnEvent("ContextMenu", (*) => ChordsMenu())

    ; Add the chord buttons
    if !topGuiOSDBarOnly {
        AddGUIElements(topGuiOSDButtons, columns, rows, columnWidth, rowHeight)
    }

    ; Set the transparency
    ; WinSetTransparent(200, topGuiOSDButtons.Hwnd)

    topGuiOSDButtons.Title := APP_NAME_OSD
    topGuiOSDButtons.OnEvent('Close', (*) => topGuiOSDButtons.Hide())
    
    if topGuiOSDBarOnly {
        topGuiOSDButtons.MarginY := 2
        topGuiOSDButtons.Show("NA AutoSize " . "W" . guiWidth/4 . " xCenter Y0")
    } else
    {
        topGuiOSDButtons.MarginY := 15
        topGuiOSDButtons.Show("NA AutoSize " . "W" . guiWidth . " xCenter Y0")
    }

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
            OSDButton := OSDGui.AddButton("Center Y" . topGuiOSDButtons.MarginY*5  .   " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 1) + topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)+topGuiOSDButtons.MarginY*5 . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 13)+ topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*2+topGuiOSDButtons.MarginY*5 . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 25)+ topGuiOSDButtons.MarginX), textForLabel)
        } else if A_Index > 36 {
            OSDButton := OSDGui.AddButton("Center Y" . (rowHeight)*3+topGuiOSDButtons.MarginY*5 . " W" . columnWidth-5 . " H" . rowHeight-10 . " X" . (columnWidth * (A_Index - 37)+ topGuiOSDButtons.MarginX), textForLabel)
        }
        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        OSDButton.SetFont("s10 c0xFFFFFF q5", "Segoe UI")

        ; Create a closure to capture the current values
        OSDButton.OnEvent("Click", ((intervalCopy, nameCopy) => (*) => GenerateChord(intervalCopy, nameCopy,,,true))(chordInterval, chordName))
    }
    
}

CloseTopGuiOSD(*) {
    try {
        topGuiOSDButtons.Destroy()
    }
    global topGuiOSDButtons := 0
    return
}

RedrawTopGuiOSD(*) {
    try {
        topGuiOSDButtons.Redraw()
    }
    return
}

ToggleBarTopGuiOSD(*) {
    global topGuiOSDBarOnly
    if (topGuiOSDBarOnly == 0) {
        topGuiOSDBarOnly := 1
    } else {
        topGuiOSDBarOnly := 0
    }
    BuildTopOSDGui()
    return
}