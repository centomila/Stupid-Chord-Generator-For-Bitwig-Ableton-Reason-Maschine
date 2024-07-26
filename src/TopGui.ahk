#Requires AutoHotkey v2.0

global topGuiOSDButtons := 0
global topGuiOSDBarOnly := true


BuildTopOSDGui() {
    global topGuiOSDBarOnly
    ; Create the GUI without button in the taskbar
    CloseTopGuiOSD() ; Force the redraw of the GUI
    global topGuiOSDButtons := GuiExt("+AlwaysOnTop -Caption +ToolWindow -DPIScale ")

    topGuiOSDButtons.Title := APP_NAME_OSD
    topGuiOSDButtons.SetDarkTitle()
    topGuiOSDButtons.SetDarkMenu()
    topGuiOSDButtons.BackColor := 0x202020
    topGuiOSDButtons.SetWindowColor(, topGuiOSDButtons.BackColor, topGuiOSDButtons.BackColor)
    topGuiOSDButtons.MarginX := 16
    topGuiOSDButtons.MarginY := 10

    columns := 12
    rows := 4
    
    guiWidth := SCREEN_WIDTH
    guiHeight := SCREEN_HEIGHT/3 + topGuiOSDButtons.MarginY*4
    
        OutputDebug("DPI:" . A_ScreenDPI . "`nGUI Width:" . guiWidth . "`nGUI Height:" . guiHeight)

    ; Calculate the width of each column
    columnWidth := ((guiWidth-topGuiOSDButtons.MarginX) / columns)
    rowHeight := (guiHeight+topGuiOSDButtons.MarginY*rows) / rows
    
    if topGuiOSDBarOnly {
        topGuiOSDBarWidth := guiWidth / 3
    } else {
        topGuiOSDBarWidth := guiWidth
    }


    textCurrentSet := topGuiOSDButtons.AddText(" r2 Center W" . topGuiOSDBarWidth . " " , "Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    textCurrentSet.OnEvent("Click", (*) => ToggleBarTopGuiOSD())
    textCurrentSet.OnEvent("ContextMenu", (*) => ChordsMenu())
    
    

    ; Add the chord buttons
    if topGuiOSDBarOnly {
        topGuiOSDButtons.MarginY := 2
        topGuiOSDButtons.Show("NoActivate " . " xCenter Y0")
    } else {
        AddGUIElements(topGuiOSDButtons, columns, rows, columnWidth, rowHeight)
        topGuiOSDButtons.MarginY := 15
        topGuiOSDButtons.Show("NoActivate " . "  Y0")
    }

    ; Set the transparency
    ; WinSetTransparent(200, topGuiOSDButtons.Hwnd)

    
    topGuiOSDButtons.OnEvent('Close', (*) => topGuiOSDButtons.Hide())

    return topGuiOSDButtons
}

AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
    ; Calculate total width of buttons in a row
    buttonWidth := columnWidth - 25
    totalButtonsWidth := buttonWidth * columns
    
    ; Calculate left margin to center buttons
    ; leftMargin := (SCREEN_WIDTH - totalButtonsWidth) / 2
    leftMargin := (topGuiOSDButtons.MarginX)*1.5

    for chords in chordsArray {
        chordName := StrReplace(chords[1], "(", "`n(")
        chordInterval := chords[2]
        shortcutKey := chords[3]

        textForLabel := chordName . "`n" . chordInterval . "`n" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        rowIndex := Ceil(A_Index / columns) - 1
        colIndex := Mod(A_Index - 1, columns)

        x := leftMargin + (colIndex * columnWidth)
        y := (rowIndex * rowHeight) + topGuiOSDButtons.MarginY * 7

        OSDButton := OSDGui.AddButton(Format("x{} y{} w{} h{}", x, y, buttonWidth, rowHeight-20), textForLabel)

        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        OSDButton.SetFont("s12 c0xFFFFFF q5", "Segoe UI")

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

ShowToolTipOSD(*)
{
    ToolTip("This is a tooltip for the text control")
}

; Function to remove the tooltip
RemoveToolTipOSD(*)
{
    ToolTip()
}