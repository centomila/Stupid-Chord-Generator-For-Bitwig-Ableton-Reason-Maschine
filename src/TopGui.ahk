#Requires AutoHotkey v2.0

global topGuiOSDButtons := 0
global topGuiOSDBarOnly := true


BuildTopOSDGui() {
    global topGuiOSDBarOnly
    global DISPLAY_OSD
    global topGuiOSDButtons

    CloseTopGuiOSD() ; Force the redraw of the GUI

    topGuiOSDButtons := GuiExt("+AlwaysOnTop -Caption +ToolWindow -DPIScale ")
    topGuiOSDButtons.Title := APP_NAME_OSD
    topGuiOSDButtons.SetDarkTitle()
    topGuiOSDButtons.SetDarkMenu()
    topGuiOSDButtons.BackColor := 0x202020
    if (VerCompare(A_OSVersion, "10.0.22600") >= 0) {
        topGuiOSDButtons.SetWindowColor(, topGuiOSDButtons.BackColor, topGuiOSDButtons.BackColor)
    }

    topGuiOSDButtons.MarginX := 10
    topGuiOSDButtons.MarginY := 10

    columns := 12
    rows := 4

    ; Get the monitor info based on DISPLAY_OSD
    monitorInfo := GetMonitorInfo(DISPLAY_OSD)

    guiHeight := SCREEN_HEIGHT / 3 + topGuiOSDButtons.MarginY * 4

    ; Calculate the width of each column
    columnWidth := ((SCREEN_WIDTH) / columns) - (topGuiOSDButtons.MarginX)
    rowHeight := 180

    if topGuiOSDBarOnly {
        topGuiOSDBarWidth := SCREEN_WIDTH / 3
    } else {
        topGuiOSDBarWidth := SCREEN_WIDTH
    }


    textCurrentSet := topGuiOSDButtons.AddText(" r2 Center W" . topGuiOSDBarWidth . " ", "Current Chord Set: " currentChordsIniSet)
    textCurrentSet.SetFont("s12 c49BCC5  w800", "Segoe UI")
    textCurrentSet.OnEvent("Click", (*) => ToggleBarTopGuiOSD())
    textCurrentSet.OnEvent("ContextMenu", (*) => ChordsMenu())


    if topGuiOSDBarOnly {
        topGuiOSDButtons.MarginY := 2
        topGuiOSDButtons.Show("NoActivate AutoSize x" . monitorInfo.workCenterWidth - textCurrentSet.w / 2 . " y" . monitorInfo.workTop)
    } else {
        AddGUIElements(topGuiOSDButtons, columns, rows, columnWidth, rowHeight)
        topGuiOSDButtons.MarginY := 15
        topGuiOSDButtons.Show("NoActivate x" . monitorInfo.workLeft . " y" . monitorInfo.workTop . " w" . topGuiOSDBarWidth)
    }

    ; Set the transparency
    ; WinSetTransparent(200, topGuiOSDButtons.Hwnd)


    topGuiOSDButtons.OnEvent('Close', (*) => topGuiOSDButtons.Hide())

    return topGuiOSDButtons
}

AddGUIElements(OSDGui, columns, rows, columnWidth, rowHeight) {
    buttonWidth := columnWidth - 5
    buttonHeight := rowHeight - 10

    for i, chords in chordsArray {
        chordName := StrReplace(chords[1], "(", "`n(")
        chordInterval := chords[2]
        shortcutKey := chords[3]

        textForLabel := chordName . "`n" . chordInterval . "`n" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        rowIndex := Ceil(i / columns) - 1
        colIndex := Mod(i - 1, columns)

        if (colIndex == 0) {
            if (rowIndex == 0) {
                xOption := "XM" . topGuiOSDButtons.MarginX * 3 - 1
                yOption := "YP+" . topGuiOSDButtons.MarginY * 6
            } else {
                xOption := "XM" . topGuiOSDButtons.MarginX * 3 - 1
                yOption := "YP+" . buttonHeight + topGuiOSDButtons.MarginY
            }
        } else {
            xOption := "X+" . topGuiOSDButtons.MarginX - 1
            yOption := "YP"  ; Same Y as the previous control in the row
        }

        options := Format("{} {} w{} h{}", xOption, yOption, buttonWidth, buttonHeight)

        OSDButton := OSDGui.AddButton(options, textForLabel)

        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        OSDButton.SetFont("s10 c0xFFFFFF q5", "Segoe UI")

        ; Create a closure to capture the current values
        OSDButton.OnEvent("Click", ((intervalCopy, nameCopy) => (*) => GenerateChord(intervalCopy, nameCopy, , , true))(chordInterval, chordName))
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