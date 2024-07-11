#Requires AutoHotkey v2.0
#Include ControlColor.ahk

global aboutGui := 0
global aboutGuiWidth := 800
global aboutGuiHeight := 600
global leftColumnWidth := 200
global rightColumnWidth := aboutGuiWidth - leftColumnWidth - 30  ; Subtracting 30 for margins

OpenUrl(url := "https://centomila.com") {
    return (*) => Run(url)
}

aboutGuiToggle() {
    if (aboutGui == 0) {
        global aboutGui := Gui()
        aboutGui.BackColor := "0x111111"
        aboutGui.MarginX := +30
        aboutGui.MarginY := +30

        aboutLogo := aboutGui.Add("Pic", "w" . leftColumnWidth . " h-1 +Center", "centomila-logo.png")

        ; Left column (links)
        linksHeader := aboutGui.Add("Text", "y+0 h20 w" . leftColumnWidth . " c0xf4f4f4 +Center", "🎧")
        linksHeader.SetFont("c0xf4f4f4 s14 bold")

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
            linkText := aboutGui.Add("Text", "y+20 h20 w" . leftColumnWidth . " c0xf4f4f4 +Center", links)
            linkText.OnEvent("Click", OpenUrl(url))
            linkText.SetFont("c0xf4f4f4 s12 underline")
        }


        linkCentomila := aboutGui.Add(
            "Text",
            "y+20 h20 w" . leftColumnWidth . " c0xf4f4f4 +Center",
            "centomila.com"
        )
        linkCentomila.SetFont("s14 bold underline")
        linkCentomila.OnEvent("Click", (*) => OpenCentomila())

        ; ControlColor(aboutButton, aboutGui, 0x111111)

        ; Right column (existing content)
        xRight := leftColumnWidth + 30

        aboutLogo2 := aboutGui.Add("Pic", "y15 w" . rightColumnWidth . " h-1 +Center", "centomila-logo.png")

        aboutGui.SetFont("c0xf4f4f4 s20 bold")
        appTitleAboutText := aboutGui.Add(
            "Text",
            " y+10 w" . rightColumnWidth . " +Center",
            StrUpper(APP_NAME)
        )

        aboutGui.SetFont("c0xf4f4f4 s12")
        aboutText := aboutGui.Add(
            "Text",
            " y+40 w" . rightColumnWidth . " +Center",
            "Thank you for using this application.`n`n" .
            "I hope you enjoy it!`n`n" .
            "I don't want money, but if you find it useful, please consider listening or sharing my music. " .
            "Your support means a lot to me!`n`n" .
            "Would you like to visit my website? It's completely free from cookies, ads, newsletters, and popups!"
        )

        versionText := aboutGui.Add(
            "Text",
            " y+50 w" . rightColumnWidth . " +Center",
            "Version: " . APP_VERSION
        )

        ; Empty space at the bottom
        emptySpace := aboutGui.Add(
            "Text",
            " y+20 w" . rightColumnWidth . " +Center",
            " "
        )


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