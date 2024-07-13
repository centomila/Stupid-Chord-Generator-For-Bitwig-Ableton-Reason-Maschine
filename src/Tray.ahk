#Requires AutoHotkey v2.0


global tray := A_TrayMenu
global trayGui := 0

global labelAbout := "About"
global labelTitle := APP_NAME . " - Version " . APP_VERSION
global labelTooltip := "Tooltip Duration (ms)"
global labelDaw := "DAW"


ToggleTraySetIcon() {
    if WinActive(currentDawExeClass) {
        if StatusEnabled {
            TraySetIcon("Images\ICO\Icon-On.ico")
        } else {
            TraySetIcon("Images\ICO\Icon-Off.ico")
        }
    } else {
        TraySetIcon("Images\ICO\Icon.ico")
    }
}


; Create the submenu for DAWs
dawMenu := Menu()
for DAWs in DAW_LIST_EXE_CLASS_MAP {
    dawMenu.Add(DAWs, SelectDaw, "Radio")
}

tooltipMenu := Menu()
for tooltipValues in TOOLTIP_DURATION_LIST {
    tooltipMenu.Add(tooltipValues, SelectToolTipDuration, "Radio")
}

chordsIniListMenu := Menu()
for chordsIniFiles in CHORDS_INI_LIST {
    chordsIniListMenu.Add(chordsIniFiles, SelectChordsIniSet, "Radio")
}

GenerateTrayMenu() {

    global labelDaw := "DAW - " . currentDaw
    global labelTooltip := "Tooltip Duration - " . currentToolTipDuration . " ms"

    trayGui := Gui("+DPIScale")
    trayGui.SetDarkMenu()
    tray.Delete() ; empty the menu
    tray.Add(labelTitle, OpenAbout)  ; Title
    tray.Add(labelAbout, OpenAbout) ; About  
    tray.Add("License", OpenLicense) ; License
    tray.Add("Help", NoAction) ; License

    tray.Add() ; ------------------------------
    tray.Add(labelDaw, dawMenu) ; Add the DAW submenu
    
    tray.Add(labelTooltip, tooltipMenu) ; Add the ToolTipDuration submenu
    tray.Add() ; ------------------------------
    tray.Add("Chord Presets", chordsIniListMenu) ; Add the ToolTipDuration submenu
    tray.Add()

    tray.Add("Open Chords Preset Folder", OpenChordsFolder)

    tray.Add() ; ------------------------------
    tray.Add("Top Info OSD`tKey Left of 1 (`` or \)", OpenOSDGui)  
    tray.Add() ; ------------------------------

    
    tray.Add() ; ------------------------------

    tray.Add("Reload", ReloadApp)  
    tray.Add("Quit", ExitApp)

    tray.ClickCount := 1
    tray.Default := labelAbout
    A_IconTip :=  APP_NAME . " - v" . APP_VERSION . " - " . currentDaw

    AddChordsToTray()
    AddIconsToTray()
    ResetCheckboxes()
}

AddIconsToTray() {
    tray.SetIcon(labelTitle, "Images\ICO\Icon.ico")
    tray.SetIcon(labelAbout, "Images\ICO\Info.ico")
    tray.SetIcon("Open Chords Preset Folder", "Images\ICO\Folder.ico")
    
    tray.SetIcon("Quit", "Images\ICO\Close.ico")

    switch currentDaw {
        case "Bitwig Studio":
            tray.SetIcon(labelDaw, "Images\ICO\Bitwig.ico")
        case "Ableton Live":
            tray.SetIcon(labelDaw, "Images\ICO\AbletonLive.ico")
        case "Reason":
            tray.SetIcon(labelDaw, "Images\ICO\Reason.ico")
        case "NI Maschine 2":
            tray.SetIcon(labelDaw, "Images\ICO\Maschine2.ico")
    }

    dawMenu.SetIcon("Bitwig Studio", "Images\ICO\Bitwig.ico")
    dawMenu.SetIcon("Ableton Live", "Images\ICO\AbletonLive.ico")
    dawMenu.SetIcon("Reason", "Images\ICO\Reason.ico")
    dawMenu.SetIcon("NI Maschine 2", "Images\ICO\Maschine2.ico")
}

ReloadApp(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Reload
}

OpenChordsFolder(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    Run "Explorer.exe /e," . A_ScriptDir . "\Chords"
}

SelectToolTipDuration(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for tooltipValues in TOOLTIP_DURATION_LIST {
        tooltipMenu.Uncheck(tooltipValues)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ToolTipDuration")
    currentToolTipDuration := A_ThisMenuItem
    tooltipMenu.Check(IniRead("Settings.ini", "Settings", "ToolTipDuration"))
    LoadSettings()
    return
}

SelectChordsIniSet(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for chordsIniFiles in CHORDS_INI_LIST {
        chordsIniListMenu.Uncheck(chordsIniFiles)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "ChordIniSet")
    chordsIniListMenu.Check(IniRead("Settings.ini", "Settings", "ChordIniSet"))

    LoadSettings()
    GenerateTrayMenu()
    return
}

SelectDaw(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    ; Uncheck all items
    for DAWs in DAW_LIST_EXE_CLASS_MAP {
        dawMenu.Uncheck(DAWs)
    }
    IniWrite(A_ThisMenuItem, "Settings.ini", "Settings", "DAW")
    dawMenu.Check(IniRead("Settings.ini", "Settings", "DAW"))
    currentDaw := A_ThisMenuItem

    switch currentDaw {
        case "NI Maschine 2":
            MsgBox(
                "Instructions:`n`n" .
                "Right Click on the piano roll and select`n`n" .
                "NUDGE GRID > STEP", currentDaw)
            LoadSettings()
            return
        default:
            LoadSettings()
            return
    }

}

OpenAbout(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    aboutGui := AboutGuiToggle()
}

OpenLicense(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{
    licenseGui := LicenseGuiToggle()
}

OpenOSDGui(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu) {
    if WinExist(currentDawExeClass) {
        if GetKeyState("CapsLock") == 0 {
            try {
                OutputDebug("`nCapslock is off. I will activate the app and enable capslock then OSD.")
                WinActivate(currentDawExeClass)
                SendEvent("{CapsLock}")
                ToggleEnable()
            }
        } else {
            try {
                OutputDebug("`nCapslock is off. I will activate the app and OSD.")
                WinActivate(currentDawExeClass)
                ToggleEnable()
            }
        }
        ToggleOSDGui()
    } else {
        MsgBox("Error: " . currentDaw . " is not running.`n`n " .
        "The OSD is shown only when the selected DAW is the active window.", "Error", 16)
    }
}

NoAction(*) {
    return
}

ExitApp(*)
{
    ExitApp()
}

AddChordsToTray() {
    chordGroupSize := 12
    currentGroup := 1
    groupMenu := Menu()

    for index, chords in chordsArray {
        chordName := chords[1]
        chordInterval := chords[2]
        shortcutKey := chords[3]
        textForLabel := chordName . " [" . chordInterval . "]" . "`t" . shortcutKey
        textForLabel := ReplaceShortCutSymbols(textForLabel)

        if (Mod(index - 1, chordGroupSize) == 0) {
            if (index > 1) {
                tray.Insert("Chord Presets","Chords`t" . ((currentGroup - 1) * chordGroupSize + 1) . "-" . (currentGroup * chordGroupSize), groupMenu, "")
                currentGroup++
            }
            groupMenu := Menu()
        }

        groupMenu.Add(textForLabel, NoAction)

        if (index == chordsArray.Length) {
            tray.Insert("Chord Presets","Chords`t" . ((currentGroup - 1) * chordGroupSize + 1) . "-" . index, groupMenu, "")
        }
    }
}


ResetCheckboxes() {
    ; checkboxes for the tray menu items
    dawMenu.Check(currentDaw)
    tooltipMenu.Check(currentToolTipDuration)
    chordsIniListMenu.Check(currentChordsIniSet)
}

ChordsMenu() {
    ; show the "Chord Preset" menu on the cursor location
    chordsIniListMenu.Show()
    if topGuiOSD != 0 {
        ToggleOSDGui()
        ToggleOSDGui()
    }
}

try {
    ResetCheckboxes()
}