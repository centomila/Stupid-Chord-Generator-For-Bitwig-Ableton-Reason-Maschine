#Requires AutoHotkey v2.0
#Include Strings\ABOUT.ahk
global aboutGui := 0

OpenUrl(url := 'https://centomila.com') {
    ; strreplace part of the url from https://centomila.com with https://localhost:1313/
    if !A_IsCompiled {
        url := strReplace(url, 'centomila.com', 'localhost:1313')
    }
    return (*) => Run(url)
}

AboutGuiToggle() {
    aboutGuiWidth := 800
    aboutGuiHeight := -1
    leftColumnWidth := 200
    rightColumnWidth := aboutGuiWidth - leftColumnWidth - 30  ; Subtracting 30 for margins

    if (aboutGui == 0) {
        global aboutGui := GuiExt(' +DPIScale')
        aboutGui.SetDarkTitle()

        aboutGui.Title := APP_NAME . ' ' . APP_VERSION . ' - About'

        aboutGui.BackColor := '0x202020'
        aboutGui.MarginX := +50
        aboutGui.MarginY := +50

        ; logoCentomilaHref := aboutGui.Add('Link', 'y55 h60 x50 w' . leftColumnWidth, '<a href="https://centomila.com">CENTOMILA.COM</a>')
        logoCentomila := aboutGui.Add('Pic', 'y50 x50 w' . leftColumnWidth  . ' h-1 ', 'Images\PNG\centomila-Logo.png')
        logoCentomila.OnEvent('Click', OpenUrl('https://centomila.com'))

        ; Left column (links)
        linksHeader := aboutGui.Add('Text', 'y+30 h30 w' . leftColumnWidth . ' c0xf4f4f4 Center ', 'Listen on 🎧')
        linksHeader.SetFont('c0xf4f4f4 s14 bold', 'Segoe UI')

        linksAbout := [{ name: 'YouTube', url: 'https://www.youtube.com/@centomila' }, { name: 'Spotify', url: 'https://open.spotify.com/intl-it/artist/6bdrEk5R3Ic7nZUufyUfsE' }, { name: 'Apple Music', url: 'https://music.apple.com/us/artist/centomila/962423083' }, { name: 'Tidal', url: 'https://tidal.com/browse/artist/32065687/' }, { name: 'Qobuz', url: 'https://play.qobuz.com/artist/9728524' }, { name: 'Zvuk', url: 'https://zvuk.com/artist/3300399' }, { name: 'Deezer', url: 'https://www.deezer.com/it/artist/7463204' }, { name: 'Amazon Music', url: 'https://music.amazon.com/artists/B0B12FQRKF/centomila' }, { name: 'Soundcloud', url: 'https://soundcloud.com/centomila' }, { name: 'Beatport', url: 'https://www.beatport.com/artist/centomila/1136112' }
        ]

        for link in linksAbout {
            ; linkTextHref := aboutGui.Add('Link', 'y+20 h20 w' . leftColumnWidth . ' c0xf4f4f4', '<a href="' . link.url . '">' . link.name . '</a>')
            ; linkTextHref.SetFont('c0xf4f4f4 s12 underline', 'Segoe UI')
            linkText := aboutGui.Add('Button', 'y+20 h40 w' . leftColumnWidth . ' c0xf4f4f4', link.name)
            linkText.SetFont('c0xf4f4f4 s12', 'Segoe UI')
            linkText.SetRounded()
            linkText.SetTheme("DarkMode_Explorer")
            linkText.OnEvent('Click', OpenUrl(link.url))
        }


        ; Right column (existing content)
        xRight := leftColumnWidth + 30

        ; aboutCentomilaLogo := aboutGui.Add('Pic', 'w' . leftColumnWidth . ' h-1 ', 'Images\PNG\centomila-logo.png')

        appLogo := aboutGui.Add('Pic', 'y' . aboutGui.MarginY . ' w' . rightColumnWidth . ' h-1 ', 'Images\PNG\SCG-Banner-Logo.png')
        appLogo.OnEvent('Click', OpenUrl('https://centomila.com/software/stupid-chord-generator-for-bitwig-ableton-reason-maschine/'))

        aboutTextGui := aboutGui.Add(
            'Text',
            'Center w' . rightColumnWidth . ' r30  ',
            ABOUT_EN
        )
        aboutTextGui.SetFont('c0xf4f4f4 s16', 'Segoe UI')

        ; Add image Buy Me a Coffee bmc-brand-logo.png
        buyMeACoffee := aboutGui.AddPic('y+25 x' . leftColumnWidth + rightColumnWidth/2  ' w' . rightColumnWidth/3 . ' h-1 ', 'Images\PNG\bmc-brand-logo.png')
        
        
        buyMeACoffee.OnEvent('Click', OpenUrl('https://www.buymeacoffee.com/centomila'))


        versionText := aboutGui.Add(
            'Text','Center x' . leftColumnWidth + aboutGui.MarginX*2 . ' y+60 h30 w' . rightColumnWidth . ' c0xf4f4f4 +Center ',
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