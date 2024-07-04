#Requires AutoHotkey v2.0

aboutGui := Gui()
aboutGui.BackColor := "0x111111"    

; Set the font for the application title
aboutGui.SetFont("c0xf4f4f4 s20 bold")
appTitleAboutText := aboutGui.Add(
    "Text",
    "x20 y20 w460 h100 +Center",  ; Increased height to accommodate longer title
    StrUpper(AppName . " - " . AppVersion)
)

; Set the font for the about text
aboutGui.SetFont("c0xf4f4f4 s12")
aboutText := aboutGui.Add(
    "Text",
    "x20 y170 w460 h360 +Center",  ; Moved down to y100
    "Thank you for using this application.`n`n" .
    "I hope you enjoy it!`n`n" .
    "I don't want money, but if you find it useful, please consider listening or sharing my music. " .
    "Your support means a lot to me!`n`n" .
    "Would you like to visit my website? It's completely free from cookies, ads, newsletters, and popups!"
)

; Add the button to the website
aboutButton := aboutGui.Add(
    "Button",
    "x150 y440 w200 h30 +Center",  ; Moved down to y280
    "CENTOMILA.COM"
)
aboutButton.OnEvent("Click", (*) => OpenWebsite())
aboutButton.BackColor := "0x333333"  ; Dark button background
aboutButton.SetFont("c0xf4f4f4")     ; Light button text

; Event handler for closing the GUI
aboutGui.OnEvent('Close', (*) => aboutGui.Destroy())
aboutGui.Title := AppName

; Show the GUI
aboutGui.Show("w500 h500 Center")  ; Set the window to be square

return aboutGui