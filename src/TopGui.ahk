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

    /* Set Mica (Alt) background. (Supported starting with Windows 11 Build 22000.) */
    ; if (VerCompare(A_OSVersion, "10.0.22600") >= 0)
    ;     topGuiOSD.SetWindowAttribute(38, 4)

    ; topGuiOSD.SetBorderless(6, (g, x, y) => (y <= g['Titlebar'].GetWindowRect().bottom), 500, 500, 500, 500)


    OutputDebug("DPI:" . A_ScreenDPI)
    ; Number of columns and rows
    columns := 12
    rows := 4

    guiWidth := Ceil(SCREEN_WIDTH)
    if (DPI = 192) {
        guiWidth := Ceil(SCREEN_WIDTH) / 2
    }
    guiHeight := 320


    ; Calculate the width of each column
    columnWidth := guiWidth / columns
    rowHeight := guiHeight / rows

    ; Add the GUI elements
    AddGUIElements(topGuiOSD, columns, rows, columnWidth, rowHeight)

    ; Set the transparency
    WinSetTransparent(250, topGuiOSD.Hwnd)

    topGuiOSD.SetFont("cWhite s16", "Segoe UI")

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
            OSDButton := OSDGui.AddButton("Center Y20 W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 1)), textForLabel)
        } else if A_Index > 12 and A_Index <= 24 {
            OSDButton := OSDGui.AddButton("Center Y" . rowHeight + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 13)), textForLabel)
        } else if A_Index > 24 and A_Index <= 36 {
            OSDButton := OSDGui.AddButton("Center Y" . rowHeight * 2 + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 25)), textForLabel)
        } else if A_Index > 36 {
            OSDButton := OSDGui.AddButton("Center Y" . rowHeight * 3 + 20 . " W" . columnWidth . " H" . rowHeight . " X" . (columnWidth * (A_Index - 37)), textForLabel)
        }
        OSDButton.SetRounded()
        OSDButton.SetTheme("DarkMode_Explorer")
        OSDButton.BackColor := 0x202020
        OSDButton.Color := 0xFFFFFF
        OSDButton.SetFont("s10 c0xFFFFFF q5", "Segoe UI")


        ; Create a closure to capture the current values
        OSDButton.OnEvent("Click", ((intervalCopy, nameCopy) => (*) => GenerateChord(intervalCopy, nameCopy))(chordInterval, chordName))
    }
}


closeTopGuiOSD(*) {
    try {
        topGuiOSD.Destroy()
    }
    global topGuiOSD := 0
    return
}