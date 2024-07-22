#Requires AutoHotkey v2.0
#Include Strings\ABOUT.ahk
global aboutGui := 0

OpenUrl(url := "https://centomila.com") {
    return (*) => Run(url)
}

AboutGuiToggle() {
    aboutGuiWidth := 800
    aboutGuiHeight := 600
    leftColumnWidth := 200
    rightColumnWidth := aboutGuiWidth - leftColumnWidth - 30  ; Subtracting 30 for margins
    
    if (aboutGui == 0) {
        global aboutGui := Gui("+ToolWindow +DPIScale")
        aboutGui.SetDarkTitle()
        aboutGui.Title := APP_NAME . " " . APP_VERSION . " - About"

        aboutGui.BackColor := "0x202020"
        aboutGui.MarginX := +50
        aboutGui.MarginY := +50


        logoCentomila := aboutGui.Add("Pic", " w" . leftColumnWidth/1.2 . " h-1 ", "Images\PNG\centomila-Logo.png")
        logoCentomila.OnEvent("Click", OpenUrl())


        ; Left column (links)
        linksHeader := aboutGui.Add("Text", "y+30 h30 w" . leftColumnWidth . " c0xf4f4f4 ", "Listen on 🎧")
        linksHeader.SetFont("c0xf4f4f4 s14 bold", "Segoe UI")

        linksAbout := Map(
            "YouTube", "https://www.youtube.com/@centomila",
            "Spotify", "https://open.spotify.com/intl-it/artist/6bdrEk5R3Ic7nZUufyUfsE",
            "Apple Music", "https://music.apple.com/us/artist/centomila/962423083",
            "Tidal", "https://tidal.com/browse/artist/32065687/",
            "Qobuz", "https://play.qobuz.com/artist/9728524",
            "Zvuk", "https://zvuk.com/artist/3300399",
            "Deezer", "https://www.deezer.com/it/artist/7463204",
            "Amazon Music", "https://music.amazon.com/artists/B0B12FQRKF/centomila",
            "Soundcloud", "https://soundcloud.com/centomila",
            "Beatport", "https://www.beatport.com/artist/centomila/1136112"
        )


        for links, url in linksAbout {
            linkText := aboutGui.Add("Text", "y+20 h20 w" . leftColumnWidth . " c0xf4f4f4", links)
            linkText.OnEvent("Click", OpenUrl(url))
            linkText.SetFont("c0xf4f4f4 s12 underline", "Segoe UI")
        }

        ; Add image Buy Me a Coffee bmc-brand-logo.png
        buyMeACoffeeHand := aboutGui.Add("Link", 'y+40 h40 w' . leftColumnWidth,  '<a href="https://www.buymeacoffee.com/centomila">🔗🔗🔗🔗🔗🔗</a>')
        buyMeACoffeeHand.SetFont(" s40 ")
         buyMeACoffee := aboutGui.Add("Pic", "y+-40 h-1 w" . leftColumnWidth . " c0xf4f4f4 ", "Images\PNG\bmc-brand-logo.png")
         buyMeACoffee.OnEvent("Click", OpenUrl("https://www.buymeacoffee.com/centomila"))




        ; Right column (existing content)
        xRight := leftColumnWidth + 30

        ; aboutCentomilaLogo := aboutGui.Add("Pic", "w" . leftColumnWidth . " h-1 ", "Images\PNG\centomila-logo.png")

        appLogo := aboutGui.Add("Pic",  "y" . aboutGui.MarginY . " w" . rightColumnWidth . " h-1 ", "Images\PNG\SCG-Banner-Logo.png")

        aboutTextGui := aboutGui.Add(
            "Link",
            "w" . rightColumnWidth . " r25 ",
            ABOUT_EN
        )
        aboutTextGui.SetFont("c0xf4f4f4 s16", "Segoe UI")



        versionText := aboutGui.Add(
            "Text",
            "w" . rightColumnWidth . " +Right r2",
            "Version: " . APP_VERSION
        )
        versionText.SetFont("c0xf4f4f4 s12", "Segoe UI")
        ; Empty space at the bottom
        ; emptySpace := aboutGui.Add(
        ;     "Text",
        ;     " y+20 w" . rightColumnWidth . " +Center",
        ;     " "
        ; )


        aboutGui.OnEvent('Close', (*) => closeAboutGui())
        

        aboutGui.Show("NA AutoSize xCenter w" . aboutGuiWidth . " h" . aboutGuiHeight)

        return aboutGui
    } else {
        closeAboutGui()
    }
}


closeAboutGui(*) {
    aboutGui.Destroy()
    global aboutGui := 0
    return
}
