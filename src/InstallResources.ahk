#Requires AutoHotkey v2.0

; If the app is compiled, install all ini file resources in the Chords folder
InstallBasicResources() {
    if A_IsCompiled { ; This actions are only executed when the script is compiled (executable).
        ChordsFolder := A_WorkingDir . "\Chords"

        if not FileExist(ChordsFolder) {
            DirCreate(ChordsFolder)
        }

        FileInstall("FChordsGen.ico", ChordsFolder . "\FChordsGen.ico", 1)
        ; FileInstall("F13-ON.ico", ChordsFolder . "\F13-ON.ico", 1)

        ; Install every ini file in the Chords folder
        Loop Files, "Chords\*.ini"
        {
            FileInstall(A_LoopFilePath, ChordsFolder . "\" . A_LoopFileName, 1)
        }
    }
}