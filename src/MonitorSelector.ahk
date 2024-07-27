#Requires AutoHotkey v2.0

SCREEN_WIDTH := A_ScreenWidth
SCREEN_HEIGHT := A_ScreenHeight
DPI := A_ScreenDPI
DISPLAY_OSD := 0
try {
    DISPLAY_OSD := IniRead("Settings.ini", "Settings", "Display")
}

monitorInfo := GetMonitorInfo(DISPLAY_OSD)
monitorInfoScaling := GetMonitorScaling(DISPLAY_OSD)  ; 0 for primary monitor, 1 for secondary, etc.
scalingPercentage := monitorInfoScaling.scaleFactor

GetMonitorInfo(displayIndex) {
    global DISPLAY_OSD, SCREEN_WIDTH, SCREEN_HEIGHT

    monitorCount := MonitorGetCount()

    if (displayIndex < 0 || displayIndex >= monitorCount) {
        displayIndex := 0  ; Default to primary monitor if invalid index
    }

    ; Get the monitor boundaries
    MonitorGet(displayIndex + 1, &L, &T, &R, &B)

    ; Get the work area (excludes taskbar)
    MonitorGetWorkArea(displayIndex + 1, &WL, &WT, &WR, &WB)

    SCREEN_WIDTH := WR - WL
    SCREEN_HEIGHT := WB - WT


    return {
        name: MonitorGetName(displayIndex + 1),
        left: L,
        top: T,
        right: R,
        bottom: B,
        width: R - L,
        height: B - T,
        workLeft: WL,
        workTop: WT,
        workRight: WR,
        workBottom: WB,
        workWidth: WR - WL,
        workHeight: WB - WT,
        workCenterWidth: (WR - WL) / 2 + WL,
        workCenterHeight: (WB - WT) / 2 + WT
    }

}


FindHorizontalCenter(objectWidth := monitorInfo.width) {
    return monitorInfo.left + (monitorInfo.width / 2) - (objectWidth / 2)
}

OutputDebugMonitorInfo() {

    OutputDebug("`n`nMonitor Info for display " . DISPLAY_OSD . ":`n"
        . "Name: " . monitorInfo.name . "`n"
        . "Left: " . monitorInfo.left . " (Work: " . monitorInfo.workLeft . ")`n"
        . "Top: " . monitorInfo.top . " (Work: " . monitorInfo.workTop . ")`n"
        . "Width: " . monitorInfo.width . " (Work: " . monitorInfo.workWidth . ")`n"
        . "Height: " . monitorInfo.height . " (Work: " . monitorInfo.workHeight . ")`n`n")

    OutputDebug("GLOBAL VARS DISPLAY:`n"
        . "`nDISPLAY_OSD: " . DISPLAY_OSD
        . "`nSCREEN_WIDTH: " . SCREEN_WIDTH
        . "`nSCREEN_HEIGHT: " . SCREEN_HEIGHT
        . "`nSCALING PERCENTAGE: " . scalingPercentage)
}


GetMonitorScaling(displayIndex := 0) {
    monitorCount := MonitorGetCount()

    if (displayIndex < 0 || displayIndex >= monitorCount) {
        displayIndex := 0  ; Default to primary monitor if invalid index
    }

    ; Get the monitor boundaries
    MonitorGet(displayIndex + 1, &L, &T, &R, &B)

    ; Get the monitor handle
    hMonitor := DllCall("User32.dll\MonitorFromRect", "Ptr", Buffer(16, 0)
        , "Int", L, "Int", T, "Int", R, "Int", B
        , "Ptr", 2)  ; MONITOR_DEFAULTTONEAREST

    ; Get the scaling factor
    scaleFactor := GetScaleFactorForMonitor(hMonitor)

    return {
        index: displayIndex,
        name: MonitorGetName(displayIndex + 1),
        scaleFactor: scaleFactor
    }
}

GetScaleFactorForMonitor(hMonitor) {
    ; Load Shcore.dll
    if !(hShcore := DllCall("LoadLibrary", "Str", "Shcore.dll", "Ptr")) {
        MsgBox("Failed to load Shcore.dll")
        return 0
    }

    ; Get the GetScaleFactorForMonitor function address
    if !(GetScaleFactorForMonitor := DllCall("GetProcAddress", "Ptr", hShcore, "AStr", "GetScaleFactorForMonitor", "Ptr")) {
        MsgBox("Failed to get GetScaleFactorForMonitor address")
        DllCall("FreeLibrary", "Ptr", hShcore)
        return 0
    }

    ; Call GetScaleFactorForMonitor
    scale := 0
    result := DllCall(GetScaleFactorForMonitor, "Ptr", hMonitor, "Int*", &scale)

    ; Free the library
    DllCall("FreeLibrary", "Ptr", hShcore)

    if (result != 0) {
        MsgBox("Failed to get scale factor. Error code: " . result)
        return 0
    }

    return scale
}