#Requires AutoHotkey v2.0

GetMonitorInfo(displayIndex) {
    monitorCount := MonitorGetCount()
    
    if (displayIndex < 0 || displayIndex >= monitorCount) {
        displayIndex := 0  ; Default to primary monitor if invalid index
    }

    ; Get the monitor boundaries
    MonitorGet(displayIndex + 1, &L, &T, &R, &B)
    
    ; Get the work area (excludes taskbar)
    MonitorGetWorkArea(displayIndex + 1, &WL, &WT, &WR, &WB)

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

OutputDebug("`n`nMonitor Info for display " . DISPLAY_OSD . ":`n"
    . "Name: " . monitorInfo.name . "`n"
    . "Left: " . monitorInfo.left . " (Work: " . monitorInfo.workLeft . ")`n"
    . "Top: " . monitorInfo.top . " (Work: " . monitorInfo.workTop . ")`n"
    . "Width: " . monitorInfo.width . " (Work: " . monitorInfo.workWidth . ")`n"
    . "Height: " . monitorInfo.height . " (Work: " . monitorInfo.workHeight . ")`n`n")