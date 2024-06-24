# Centomila's Stupid Universal Chord Generator
<!-- vscode-markdown-toc -->
* 1. [What is Centomila's Stupid Universal Chord Generator?](#WhatisCentomilasStupidUniversalChordGenerator)
	* 1.1. [Why is stupid?](#Whyisstupid)
* 2. [This repository contains](#Thisrepositorycontains)
* 3. [Install and Usage](#InstallandUsage)
	* 3.1. [Run from source](#Runfromsource)
	* 3.2. [Run from build](#Runfrombuild)
* 4. [Usage](#Usage)
	* 4.1. [Chord Generation](#ChordGeneration)
		* 4.1.1. [Triads](#Triads)
		* 4.1.2. [Seventh (7th) Chords](#Seventh7thChords)
		* 4.1.3. [Ninth (9th) Chords](#Ninth9thChords)
		* 4.1.4. [Suspended Chords](#SuspendedChords)
	* 4.2. [Limitations](#Limitations)
	* 4.3. [Before You Contribute](#BeforeYouContribute)
	* 4.4. [TODO](#TODO)
* 5. [Contributing](#Contributing)
* 6. [License](#License)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='WhatisCentomilasStupidUniversalChordGenerator'></a>What is Centomila's Stupid Universal Chord Generator?

Writing chords in a DAW's piano roll is a repetitive task, and repetitive tasks are for machines 🤖.

This script automates the process of copy pasting notes and **generate chords from a selected note**.

It is designed to be used with **Bitwig Studio, Ableton Live, Reason Studio, and NI Maschine**.

The script is enabled only when CAPS LOCK is active, leaving your original F1-F12 shortcuts untouched 😊.

Tested with:
- Bitwig Studio 5.1.9 / Bitwig Studio 5.2 Beta 8
- Ableton Live 12 Lite
- Reason Studio 12
  - The loop handles LR will be moved at the start and end of the selected notes.
- Native Instruments Maschine 2

###  1.1. <a name='Whyisstupid'></a>Why is stupid?
The script don't know in which part of the DAW you are working. If you are not in the piano roll with a note selected, it will start copy/pasting wathever it can.
It will never do anything outside the selected DAW, even if CAPS LOCK is enabled.

##  2. <a name='Thisrepositorycontains'></a>This repository contains
1. [This Readme](Readme.md)
2. [The application in Autohotkey v2 (AHK) format](<src/StupidUniversalChordGenerator.ahk>) to automate the chord generation.
3. [The systray icon](<src/FChordsGen.ico>) to make it look pretty.
4. [Settings.ini file](Settings.ini) to save preferences (if deleted, will be recreated on next launch with _Bitwig Studio_ as the default DAW).

##  3. <a name='InstallandUsage'></a>Install and Usage

###  3.1. <a name='Runfromsource'></a>Run from source

Download the content of the [src folder](src) and run the .ahk file.

To run from source, you must have AutoHotKey 2.0 or higher installed. The script has been tested with AutoHotKey 2.0.17.

###  3.2. <a name='Runfrombuild'></a>Run from build

Download [Stupid Universal Chord Generator.exe](<bin/Stupid Universal Chord Generator.exe>) from the [bin folder](bin).

The script has been compiled as an executable and has no dependencies. Any modern Windows machine should be able to run it.

---

##  4. <a name='Usage'></a>Usage

Run the `Stupid-Universal-Chord-Generator.exe` file. The application will open in the system tray. Right-click on the application icon in the system tray to view the list of shortcuts and change the preferences. The preferences will be automatically saved in the `settings.ini` file upon changes.

###  4.1. <a name='ChordGeneration'></a>Chord Generation

1. Select one or more notes in the piano roll.
2. Enable CAPS LOCK. The script works only if CAPS LOCK is enabled; this way, your original shortcuts (F1-F12) will not be overwritten.
3. With CAPS LOCK enabled and a note selected, press a function key from F1 to F4 to transform the note into a chord.

####  4.1.1. <a name='Triads'></a>Triads
- **F1** - Major Chords (0-4-7)
- **F2** - Minor Chords (0-3-7)
- **F3** - Augmented Chords (0-4-8)
- **F4** - Diminished Chords (0-3-6)

####  4.1.2. <a name='Seventh7thChords'></a>Seventh (7th) Chords
- **F5** - Major 7th Chords (0-4-7-11)
- **F6** - Minor 7th Chords (0-3-7-10)
- **F7** - Augmented 7th Chords (0-4-8-11)
- **F8** - Diminished 7th Chords (0-3-6-9)

####  4.1.3. <a name='Ninth9thChords'></a>Ninth (9th) Chords
- **F9** - Major 9th Chords (0-4-7-11-14)
- **F10** - Minor 9th Chords (0-3-7-10-13)
- **F11** - Augmented 9th Chords (0-4-8-11-14)
- **F12** - Diminished 9th Chords (0-3-6-9-12)

####  4.1.4. <a name='SuspendedChords'></a>Suspended Chords
- **CTRL+F1** - Sus2 Chords (0-2-7)
- **CTRL+F2** - Sus4 Chords (0-5-7)
- **CTRL+F3** - Dominant 7th Chords (0-4-7-10)
- **CTRL+F4** - Half-Diminished Chords (0-3-6-10)

---

###  4.2. <a name='Limitations'></a>Limitations

- The script does not know if you are in the piano roll or in other parts of the DAW. Using it outside the piano roll can cause unexpected results.
- The script imitates a sequence of keyboard shortcuts, which creates multiple history entries. To undo chord generation, you need to undo multiple times.

###  4.3. <a name='BeforeYouContribute'></a>Before You Contribute

- If you want to contribute, please follow the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) Code of Conduct.
- Attempts to make it work with Cockos Reaper and FL Studio were inconsistent due to the way the note cursor works in those DAWs. There may be better ways to achieve this using the DAWs' script engines.
- Compatibility with Steinberg Cubase was not pursued as it already has a Chord Assistant functionality.

###  4.4. <a name='TODO'></a>TODO

- [ ] Add settings menu to change or disable tooltips
- [ ] Customizable chords and shortcuts in an external JSON file
- [ ] GUI Always visible
- [ ] Super UNDO (count the actions then undo X times)

---

##  5. <a name='Contributing'></a>Contributing

Feel free to dive in! [Open an issue](https://github.com/centomila/standard-readme/issues/new) or submit PRs.

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) Code of Conduct.

##  6. <a name='License'></a>License

MIT License
Copyright <2024> <Franco Baccarini / Centomila>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
