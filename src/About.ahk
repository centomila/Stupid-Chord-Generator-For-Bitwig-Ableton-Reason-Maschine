#Requires AutoHotkey v2.0
#Include ControlColor.ahk

global aboutGui := 0
global aboutGuiWidth := 300
global aboutGuiHeight := 600

aboutGuiToggle() {

    if (aboutGui == 0) {

        global aboutGui := Gui()
        aboutGui.BackColor := "0x111111"
        aboutGui.MarginX := 30
        aboutGui.MarginY := 30

        ;Handle := LoadPicture(Filename , Options, &OutImageType)
        ; aboutLogo := LoadPicture("centomila-logo.png", "w48 h-1 GDI+ ")
        aboutLogo := aboutGui.Add("Pic", "w" . aboutGuiWidth/.9 . " h-1 +Center", "centomila-logo.png")

        ; Set the font for the application title
        aboutGui.SetFont("c0xf4f4f4 s20 bold")
        
        appTitleAboutText := aboutGui.Add(
            "Text",
            "w" . aboutGuiWidth / .9 . "  +Center",
            StrUpper(APP_NAME . "`n`n V. " . APP_VERSION)
        )

        ; Set the font for the about text
        aboutGui.SetFont("c0xf4f4f4 s12")
        aboutText := aboutGui.Add(
            "Text",
            "w" . aboutGuiWidth / .9 . " +Center",
            "Thank you for using this application.`n`n" .
            "I hope you enjoy it!`n`n" .
            "I don't want money, but if you find it useful, please consider listening or sharing my music. " .
            "Your support means a lot to me!`n`n" .
            "Would you like to visit my website? It's completely free from cookies, ads, newsletters, and popups!"
        )

        ; White space
        aboutGui.Add("Text", "w" . aboutGuiWidth / .9 . " h10 +Center", " ")
        

        ; Add the button to the website
        aboutButton := aboutGui.Add(
            "Button",
            "w" . aboutGuiWidth / .9 . " h40 +Center",
            "CENTOMILA.COM"
        )
        aboutButton.SetFont("s20 bold")

        

        aboutButton.OnEvent("Click", (*) => OpenCentomila())

        ControlColor(aboutButton, aboutGui, 0x111111)

        ; Event handler for closing the GUI
        aboutGui.OnEvent('Close', (*) => aboutGui.Destroy())
        aboutGui.Title := APP_NAME

        
        aboutGui.Show("NA AutoSize xCenter w" . aboutGuiWidth . " h" . aboutGuiHeight)
        

        return aboutGui
    } else {
        aboutGui.Destroy()
        aboutGui := 0
    }
}

OpenCentomila() {
    Run "https://centomila.com"
}
