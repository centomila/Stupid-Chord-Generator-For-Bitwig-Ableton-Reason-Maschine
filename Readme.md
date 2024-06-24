# Centomila's Stupid Universal Chord Generator
<!-- vscode-markdown-toc -->
* 1. [What is Centomila's Stupid Universal Chord Generator?](#WhatisCentomilasStupidUniversalChordGenerator)
* 2. [This repository contains:](#Thisrepositorycontains:)
* 3. [Dependencies](#Dependencies)
* 4. [Install](#Install)
* 5. [Usage](#Usage)
	* 5.1. [Generator](#Generator)
		* 5.1.1. [Triads](#Triads)
		* 5.1.2. [Seventh (7th) Chords](#Seventh7thChords)
		* 5.1.3. [Ninth (9th) Chords](#Ninth9thChords)
		* 5.1.4. [Suspended Chords](#SuspendedChords)
	* 5.2. [Limitations](#Limitations)
	* 5.3. [Before you contribute](#Beforeyoucontribute)
	* 5.4. [TODO](#TODO)
* 6. [Contributing](#Contributing)
* 7. [License](#License)
* 8. [Support this project](#Supportthisproject)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='WhatisCentomilasStupidUniversalChordGenerator'></a>What is Centomila's Stupid Universal Chord Generator?
Writing chords in a DAW's piano roll is a repetetive task and repetetive tasks are for machines. This script automates the process of generating chords from a single note. It is designed to be used with Bitwig Studio, Ableton Live, Reason Studio and NI Maschine.

Tested with:
- Bitwig Studio 5.1.9
- Ableton Live 12 Lite
- Reason Studio 12
-- The loop handles LR will be moved at start and end of the selected notes.
- Native Instruments Maschine 2

##  2. <a name='Thisrepositorycontains:'></a>This repository contains:

1. [This Readme](Readme.md) you are reading right now.
2. [The Chord Generator script](ChordGenerator.ahk) to automate the chord generation.
3. [The Icon for the BitwigChordsGenerator](FChordsGen.ico) to make it look pretty.
4. [Settings.ini file](Settings.ini) to save the preferences (if deleted will be recreated on next launch with Bitwig Studio as default DAW).

##  3. <a name='Dependencies'></a>Dependencies
### Run from source
The script has been written with AutoHotKey (https://www.autohotkey.com/) 2.0.

### Run from build
The script has been compiled as an executable and has no dependencies. Any modern Windows machine should be able to run it.

##  4. <a name='Install'></a>Install

Download the contents of this repository to a folder of your choice.

---

##  5. <a name='Usage'></a>Usage

Run the `Stupid-Universal-Chord-Generator.exe` file. The application will be opened in the system tray.
Right-click on the application icon in the system tray to view the list of shortcuts and change the preferences. The preferences will be automatically saved on change in the `settings.ini` file.

###  5.1. <a name='Generator'></a>Generator
1. Select one ore more notes in the piano roll.
2. Enable CAPS LOCK. The script work only if the CAPS LOCK is enabled, in this way your original shortcuts F1-12 will not be overwritten.
3. With CAPS Lock enabled and a note selected, press a function key from F1 to F4 to transform the note into a chord
####  5.1.1. <a name='Triads'></a>Triads
- "F1 - Major Chords - 0-4-7"
- "F2 - Minor Chords - 0-3-7"
- "F3 - Augmented Chords - 0-4-8"
- "F4 - Diminished Chords - 0-3-6"

####  5.1.2. <a name='Seventh7thChords'></a>Seventh (7th) Chords
- "F5 - Major 7th Chords - 0-4-7-11"
- "F6 - Minor 7th Chords - 0-3-7-10"
- "F7 - Augmented 7th Chords - 0-4-8-11"
- "F8 - Diminished 7th Chords - 0-3-6-9"

####  5.1.3. <a name='Ninth9thChords'></a>Ninth (9th) Chords
- "F9 - Major 9th Chords - 0-4-7-11-14"
- "F10 - Minor 9th Chords - 0-3-7-10-13"
- "F11 - Augmented 9th Chords - 0-4-8-11-14"
- "F12 - Diminished 9th Chords - 0-3-6-9-12"

####  5.1.4. <a name='SuspendedChords'></a>Suspended Chords
- "CTRL+F1 - Sus2 Chords - 0-2-7"
- "CTRL+F2 - Sus4 Chords - 0-5-7"
- "CTRL+F3 - DOMINANT 7th Chords - 0-4-7-10"
- "CTRL+F4 - Half-Diminished Chords - 0-3-6-10"

---

###  5.2. <a name='Limitations'></a>Limitations
- The script don't know if you are in the piano roll or in other parts of the DAW. If you try to use it outside the piano roll can cause unexpected results.
- The script imitate a sequence of keyboard shortcuts. Multiple history entries will be created. If you want to undo the chord generation you need to undo multiple times.

###  5.3. <a name='Beforeyoucontribute'></a>Before you contribute
- If you want to contribute, please follow the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) Code of Conduct.
- I have already tried to make it work with Cockos Reaper and FL Studio, but the results were not consistent because the way the note cursor works in those DAWs. Moreover, there may be better ways to achieve this using the script engines of the DAWs.
- I didn't tried to make it work with Steinberg Cubase because it already has a functionality called Chord Assistant.


###  5.4. <a name='TODO'></a>TODO
- [ ] Add settings.ini for tooltip
- [ ] Customizable chords and shortcuts in external json file

---

##  6. <a name='Contributing'></a>Contributing

Feel free to dive in! [Open an issue](https://github.com/centomila/standard-readme/issues/new) or submit PRs.

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) Code of Conduct.

##  7. <a name='License'></a>License

MIT License

Copyright (c) [2024] [Franco Baccarini / Centomila]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

##  8. <a name='Supportthisproject'></a>Support this project
I don't want money. Listen and share my music!