#Requires AutoHotkey v2.0


aboutGuiToggle() {
    static aboutGui := 0

    if (aboutGui == 0) {
        
        aboutGui := Gui()
        aboutGui.BackColor := "0x111111"

        ; Set the font for the application title
        aboutGui.SetFont("c0xf4f4f4 s20 bold")
        appTitleAboutText := aboutGui.Add(
            "Text",
            "x20 y20 w460 h100 +Center",
            StrUpper(APP_NAME . " - " . APP_VERSION)
        )

        ; Set the font for the about text
        aboutGui.SetFont("c0xf4f4f4 s12")
        aboutText := aboutGui.Add(
            "Text",
            "x20 y170 w460 h360 +Center",
            "Thank you for using this application.`n`n" .
            "I hope you enjoy it!`n`n" .
            "I don't want money, but if you find it useful, please consider listening or sharing my music. " .
            "Your support means a lot to me!`n`n" .
            "Would you like to visit my website? It's completely free from cookies, ads, newsletters, and popups!"
        )

        ; Add the button to the website
        aboutButton := aboutGui.Add(
            "Button",
            "x150 y440 w200 h30 +Center",
            "CENTOMILA.COM"
        )
        aboutButton.OnEvent("Click", (*) => OpenCentomila())
        aboutButton.BackColor := "0x333333"
        aboutButton.SetFont("c0xf4f4f4")

        ; Event handler for closing the GUI
        aboutGui.OnEvent('Close', (*) => aboutGui.Destroy())
        aboutGui.Title := APP_NAME

        aboutGui.Show()

        return aboutGui
    } else {
        aboutGui.Destroy()
        aboutGui := 0
    }
}

OpenCentomila() {
    Run "https://centomila.com"
}