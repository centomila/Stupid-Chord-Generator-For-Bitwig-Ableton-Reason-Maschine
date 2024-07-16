#Requires AutoHotkey v2.0
Loop Files, "Chords\*.ini", "R"  ; Recurse into subfolders.
{
    OutputDebug("File: " . A_LoopFileName . "`n")
}

; If the app is compiled, install all ini file resources in the Chords folder
InstallBasicResources() {
    ChordsFolder := A_WorkingDir . "\Chords"
    IcoFolder := A_WorkingDir . "\Images\ICO"
    PngFolder := A_WorkingDir . "\Images\PNG"
    OutputDebug(ChordsFolder)

    if A_IsCompiled { ; This actions are only executed when the script is compiled (executable).
        
        if not FileExist(IcoFolder) {
            DirCreate(IcoFolder)
        }

        if not FileExist(PngFolder) {
            DirCreate(PngFolder)
        }
        
        if not FileExist(ChordsFolder) {
            DirCreate(ChordsFolder)
        }
        
        FileInstall("Chords\How to create your chords presets.txt", A_WorkingDir . "\Chords\How to create your chords presets.txt", 1)

        FileInstall("Chords\All Chords.ini", A_WorkingDir . "\Chords\All Chords.ini", 1)
        FileInstall("Chords\Common Inversions.ini", A_WorkingDir . "\Chords\Common Inversions.ini", 1)
        FileInstall("Chords\Common.ini", A_WorkingDir . "\Chords\Common.ini", 1)
        FileInstall("Chords\Majors.ini", A_WorkingDir . "\Chords\Majors.ini", 1)
        FileInstall("Chords\Minors.ini", A_WorkingDir . "\Chords\Minors.ini", 1)

        FileInstall("Images\ICO\AbletonLive.ico", A_WorkingDir . "\Images\ICO\AbletonLive.ico", 1)
        FileInstall("Images\ICO\Bitwig.ico", A_WorkingDir . "\Images\ICO\Bitwig.ico", 1)
        FileInstall("Images\ICO\Close.ico", A_WorkingDir . "\Images\ICO\Close.ico", 1)
        FileInstall("Images\ICO\Done.ico", A_WorkingDir . "\Images\ICO\Done.ico", 1)
        FileInstall("Images\ICO\Folder.ico", A_WorkingDir . "\Images\ICO\Folder.ico", 1)
        FileInstall("Images\ICO\Icon.ico", A_WorkingDir . "\Images\ICO\Icon.ico", 1)
        FileInstall("Images\ICO\Icon-Off.ico", A_WorkingDir . "\Images\ICO\Icon-Off.ico", 1)
        FileInstall("Images\ICO\Icon-On.ico", A_WorkingDir . "\Images\ICO\Icon-On.ico", 1)
        FileInstall("Images\ICO\Info.ico", A_WorkingDir . "\Images\ICO\Info.ico", 1)
        FileInstall("Images\ICO\Maschine2.ico", A_WorkingDir . "\Images\ICO\Maschine2.ico", 1)
        FileInstall("Images\ICO\Reason.ico", A_WorkingDir . "\Images\ICO\Reason.ico", 1)
        FileInstall("Images\ICO\Settings.ico", A_WorkingDir . "\Images\ICO\Settings.ico", 1)


        ;Images\PNG\centomila-logo.png
        FileInstall("Images\PNG\centomila-logo.png", A_WorkingDir . "\Images\PNG\centomila-logo.png", 1)

        ;Images\PNG\SCG-Banner-Logo.png
        FileInstall("Images\PNG\SCG-Banner-Logo.png", A_WorkingDir . "\Images\PNG\SCG-Banner-Logo.png", 1) 

        ;Install license
        FileInstall("LICENSE", A_WorkingDir . "\LICENSE", 1)

    }
    return
}

InstallAdditionalChordPresets(*) {
    ; MsgBox that explain what is going to be installed and ask for confirmation before installing
    InstallChordsYesNo := MsgBox("Do you want to install additional Chord Presets?", "Install Additional Chord Presets", "Icon? YesNo")
    if (InstallChordsYesNo  = "No") {
        return
    } else {
        FileInstall("Chords\Cinematic Dark.ini", A_WorkingDir . "\Chords\Cinematic Dark.ini", 1)
        FileInstall("Chords\Cinematic Epic.ini", A_WorkingDir . "\Chords\Cinematic Epic.ini", 1)
        FileInstall("Chords\Jazzy.ini", A_WorkingDir . "\Chords\Jazzy.ini", 1)
        FileInstall("Chords\My-Custom-Chords.ini", A_WorkingDir . "\Chords\My-Custom-Chords.ini", 1)
        Reload
    }
}