#Requires AutoHotkey v2.0
Loop Files, "Chords\*.ini", "R"  ; Recurse into subfolders.
{
    OutputDebug("File: " . A_LoopFileName . "`n")
}

; If the app is compiled, install all ini file resources in the Chords folder
InstallBasicResources() {
    ChordsFolder := A_WorkingDir . "\Chords"
    OutputDebug(ChordsFolder)

    if A_IsCompiled { ; This actions are only executed when the script is compiled (executable).

        FileInstall("Icon-Off.ico", A_WorkingDir . "Images\ICO\Icon-Off.ico", 1)
        FileInstall("Icon-On.ico", A_WorkingDir . "Images\ICO\Icon-On.ico", 1)


        if not FileExist(ChordsFolder) {
            DirCreate(ChordsFolder)
        }

        FileInstall("Chords\All Chords.ini", A_WorkingDir . "\Chords\All Chords.ini", 1)
        FileInstall("Chords\Cinematic Dark.ini", A_WorkingDir . "\Chords\Cinematic Dark.ini", 1)
        FileInstall("Chords\Cinematic Epic.ini", A_WorkingDir . "\Chords\Cinematic Epic.ini", 1)
        FileInstall("Chords\Common Inversions.ini", A_WorkingDir . "\Chords\Common Inversions.ini", 1)
        FileInstall("Chords\Common.ini", A_WorkingDir . "\Chords\Common.ini", 1)
        FileInstall("Chords\How to create your chords presets.txt", A_WorkingDir . "\Chords\How to create your chords presets.txt", 1)
        FileInstall("Chords\Jazzy.ini", A_WorkingDir . "\Chords\Jazzy.ini", 1)
        FileInstall("Chords\Majors.ini", A_WorkingDir . "\Chords\Majors.ini", 1)
        FileInstall("Chords\Minors.ini", A_WorkingDir . "\Chords\Minors.ini", 1)
        FileInstall("Chords\My-Custom-Chords.ini", A_WorkingDir . "\Chords\My-Custom-Chords.ini", 1)
        

    }


    return
}