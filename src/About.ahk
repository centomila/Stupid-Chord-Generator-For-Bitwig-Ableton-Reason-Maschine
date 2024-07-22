#Requires AutoHotkey v2.0
#Include Strings\ABOUT.ahk
global aboutGui := 0

OpenUrl(url := 'https://centomila.com') {
    return (*) => Run(url)
}

AboutGuiToggle() {
    aboutGuiWidth := 800
    aboutGuiHeight := -1
    leftColumnWidth := 200
    rightColumnWidth := aboutGuiWidth - leftColumnWidth - 30  ; Subtracting 30 for margins

    if (aboutGui == 0) {
        global aboutGui := Gui(' +DPIScale')
        aboutGui.SetDarkTitle()
        aboutGui.Title := APP_NAME . ' ' . APP_VERSION . ' - About'

        aboutGui.BackColor := '0x202020'
        aboutGui.MarginX := +50
        aboutGui.MarginY := +50


        logoCentomilaHref := aboutGui.Add('Link', 'y55 h60 x50 w' . leftColumnWidth, '<a>CENTOMILA.COM</a>')
        logoCentomilaHref.SetFont('s14 ')
        logoCentomila := aboutGui.Add('Pic', 'y50 x50 w' . leftColumnWidth / 1.2 . ' h-1 ', 'Images\PNG\centomila-Logo.png')
        logoCentomila.OnEvent('Click', OpenUrl())


        ; Left column (links)
        linksHeader := aboutGui.Add('Text', 'y+30 h30 w' . leftColumnWidth . ' c0xf4f4f4 ', 'Listen on 🎧')
        linksHeader.SetFont('c0xf4f4f4 s14 bold', 'Segoe UI')

        linksAbout := [{ name: 'YouTube', url: 'https://www.youtube.com/@centomila' }, { name: 'Spotify', url: 'https://open.spotify.com/intl-it/artist/6bdrEk5R3Ic7nZUufyUfsE' }, { name: 'Apple Music', url: 'https://music.apple.com/us/artist/centomila/962423083' }, { name: 'Tidal', url: 'https://tidal.com/browse/artist/32065687/' }, { name: 'Qobuz', url: 'https://play.qobuz.com/artist/9728524' }, { name: 'Zvuk', url: 'https://zvuk.com/artist/3300399' }, { name: 'Deezer', url: 'https://www.deezer.com/it/artist/7463204' }, { name: 'Amazon Music', url: 'https://music.amazon.com/artists/B0B12FQRKF/centomila' }, { name: 'Soundcloud', url: 'https://soundcloud.com/centomila' }, { name: 'Beatport', url: 'https://www.beatport.com/artist/centomila/1136112' }
        ]

        for link in linksAbout {
            linkTextHref := aboutGui.Add('Link', 'y+20 h20 w' . leftColumnWidth . ' c0xf4f4f4', '<a href="' . link.url . '">' . link.name . '</a>')
            linkTextHref.SetFont('c0xf4f4f4 s12 underline', 'Segoe UI')
            linkText := aboutGui.Add('Text', 'y+-20 h20 w' . leftColumnWidth . ' c0xf4f4f4', link.name)
            linkText.SetFont('c0xf4f4f4 s12 underline', 'Segoe UI')
        }

        ; Add image Buy Me a Coffee bmc-brand-logo.png
        buyMeACoffeeHref := aboutGui.Add('Link', 'y+100 h50 w' . leftColumnWidth, '<a href="https://www.buymeacoffee.com/centomila">BUY ME A COFFEE</a>')
        buyMeACoffeeHref.SetFont(' s16 ')
        buyMeACoffee := aboutGui.Add('Pic', 'y+-60 h-1 w' . leftColumnWidth . ' c0xf4f4f4 ', 'Images\PNG\bmc-brand-logo.png')


        ; Right column (existing content)
        xRight := leftColumnWidth + 30

        ; aboutCentomilaLogo := aboutGui.Add('Pic', 'w' . leftColumnWidth . ' h-1 ', 'Images\PNG\centomila-logo.png')

        appLogo := aboutGui.Add('Pic', 'y' . aboutGui.MarginY . ' w' . rightColumnWidth . ' h-1 ', 'Images\PNG\SCG-Banner-Logo.png')

        aboutTextGui := aboutGui.Add(
            'Link',
            'w' . rightColumnWidth . ' r30 ',
            ABOUT_EN
        )
        aboutTextGui.SetFont('c0xf4f4f4 s16', 'Segoe UI')


        versionText := aboutGui.Add(
            'Text',
            'w' . rightColumnWidth . ' +Right r2',
            'Version: ' . APP_VERSION
        )
        versionText.SetFont('c0xf4f4f4 s12', 'Segoe UI')


        aboutGui.OnEvent('Close', (*) => closeAboutGui())
        aboutGui.Show('NA AutoSize xCenter w' . aboutGuiWidth . ' h' . aboutGuiHeight)

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