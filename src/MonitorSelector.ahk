#Requires AutoHotkey v2.0

SCREEN_WIDTH := A_ScreenWidth
SCREEN_HEIGHT := A_ScreenHeight
DPI := A_ScreenDPI
DISPLAY_OSD := 0

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

    SCREEN_WIDTH := R - L
    SCREEN_HEIGHT := B - T

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
        workHeight: WB - WT
    }
}
monitorInfo := GetMonitorInfo(DISPLAY_OSD)

FindHorizontalCenter(objectWidth := monitorInfo.width) {
    return monitorInfo.left + (monitorInfo.width / 2) - (objectWidth / 2)
}

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
    . "`nDPI: " . DPI . "`n`n")