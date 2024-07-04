#Requires AutoHotkey v2.0

; Get the screen width and height
screenWidth := A_ScreenWidth
screenHeight := A_ScreenHeight

; Calculate the width of the GUI (80% of screen width)
guiWidth := screenWidth * 0.8
guiHeight := 100  ; Adjust the height as necessary to fit your content

; Calculate the horizontal position to center the GUI
guiX := (screenWidth - guiWidth) / 2
guiY := 0  ; Top of the screen

; Create the GUI
TopGui := Gui("+AlwaysOnTop -Caption")
; TopGui("X" guiX "Y" guiY "W" guiWidth "H" guiHeight)

; Row 1 texts
row1 := [
    "F1 - Major - 0-4-7",
    "F2 - Minor - 0-3-7",
    "F3 - Augmented - 0-4-8",
    "F4 - Diminished - 0-3-6",
    "F5 - Major 7th - 0-4-7-11",
    "F6 - Minor 7th - 0-3-7-10",
    "F7 - Augmented 7th - 0-4-8-11",
    "F8 - Diminished 7th - 0-3-6-9",
    "F9 - Major 9th - 0-4-7-11-14",
    "F10 - Minor 9th - 0-3-7-10-13",
    "F11 - Augmented 9th - 0-4-8-11-14",
    "F12 - Diminished 9th - 0-3-6-9-12"
]

; Row 2 texts
row2 := [
    "CTRL+F1 - Sus2 - 0-2-7",
    "CTRL+F2 - Sus4 - 0-5-7",
    "CTRL+F3 - DOMINANT 7th - 0-4-7-10",
    "CTRL+F4 - Half-Diminished - 0-3-6-10"
]

; Number of columns and rows
columns := 12
rows := 2

; Calculate the width of each column
columnWidth := guiWidth / columns
rowHeight := guiHeight / rows

; Show the GUI
TopGui.Show( "W" guiWidth "H" guiHeight "X" guiX "Y" guiY )
return TopGui