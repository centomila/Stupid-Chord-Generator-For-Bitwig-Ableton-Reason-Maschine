# Autohotkey Chord Generator

Writing chords in a DAW's piano roll is a repetetive task and repetetive tasks are for machines. This script automates the process of generating chords from a single note. It is designed to be used with Bitwig Studio, but works well also in Ableton Live and can be adapted to be used with any DAW that allows for keyboard shortcuts.

Feel free to contribute to this repository to make it work with other DAWs ☺️

- Bitwig Studio 4.4
- Ableton Live 10

## This repository contains:

1. [This Readme](Readme.md) you are reading right now.
2. [The Chord Generator script](ChordGenerator.ahk) to automate the chord generation.
3. [The Icon for the BitwigChordsGenerator](FChordsGen.ico) to make it look pretty.

## Table of Contents
<!-- TOC -->

- [Autohotkey Chord Generator](#autohotkey-chord-generator)
    - [This repository contains:](#this-repository-contains)
    - [Table of Contents](#table-of-contents)
    - [Background](#background)
    - [Dependencies](#dependencies)
    - [Install](#install)
    - [Usage](#usage)
        - [Generator](#generator)
            - [Triads](#triads)
            - [Seventh 7th Chords](#seventh-7th-chords)
            - [Ninth 9th Chords](#ninth-9th-chords)
            - [Suspended Chords](#suspended-chords)
            - [Octave change](#octave-change)
        - [Limitations](#limitations)
        - [TODO](#todo)
    - [Maintainers](#maintainers)
    - [Contributing](#contributing)
    - [License](#license)

<!-- /TOC -->


## Background


## Dependencies

To run this script you need to install [Autohotkey](https://www.autohotkey.com/). The script has been tested with Autohotkey version 2.0.0.

## Install

Download the contents of this repository to a folder of your choice.

---

## Usage

Run the `Launch.ahk` to start the scripts. You will see two new icons in the system tray.

If you don't need the chord generator script, but you like the F13-F24 keys, you can run the `F13-F24-CAPSLOCK.ahk` script and use it for anything else 😊.

### Generator
1. Select one ore more notes in the piano roll.
3. Press a function key from F1 to F4 to transform the note in a chord
    - F1 TO F4 Triads
    - CTRL+F1 TO CTRL+F4 (CTRL+F13 TO CTRL+F16) 7ths
    - ALT+F1 TO ALT+F4 (ALT+F13 TO ALT+F16) 9ths
    - F11 TO F12 (F23 TO F24) OCTAVE DOWN/UP for **all notes in the clip**
        - It's a faster alternative to CTRL+A->SHIFT+DOWN / SHIFT+UP

#### Triads
- **F1** (F13) - MAJOR Chords 1-4-7
- **F2** (F14) - MINOR Chords 1-3-7
- **F3** (F15) - AUGMENTED Chords 1-4-8
- **F4** (F16) - DIMINISHED Chords 1-3-6
#### Seventh (7th) Chords
- **CTRL+F1** (CTRL+F13) - MAJOR 7th Chords 1-4-7-11
- **CTRL+F2** (CTRL+F14) - MINOR 7th Chords 1-3-7-10
- **CTRL+F3** (CTRL+F15) - AUGMENTED 7th Chords 1-4-8-11
- **CTRL+F4** (CTRL+F16) - DIMINISHED 7th Chords 1-3-6-9
#### Ninth (9th) Chords
- **ALT+F1** (ALT+F13) - MAJOR 9th Chords 1-4-7-11-14
- **ALT+F2** (ALT+F14) - MINOR 9th Chords 1-3-7-10-13
- **ALT+F3** (ALT+F15) - AUGMENTED 9th Chords 1-4-8-11-14
- **ALT+F4** (ALT+F16) - DIMINISHED 9th Chords 1-3-6-9-12
#### Suspended Chords
- **F5** (F17) - Sus2 Chords - 1-2-7
- **F6** (F18) - Sus4 Chords - 1-5-7
#### Octave change
- **F11** (F23) Select all notes in the clip and move an octave DOWN
- **F12** (F24) Select all notes in the clip and move an octave UP

---

### Limitations
- The script don't know if you are in the piano roll or in other parts of the DAW. If you try to use it outside the piano roll can cause unexpected results.
- The script imitate a sequence of keyboard shortcuts. Multiple history entries will be created. If you want to undo the chord generation you need to undo multiple times.
- If you customize this script, don't use the SHIFT modifier. It is commonly used by the DAWs to move octaves and can cause unexpected results.


### TODO
- [ ] Add settings.ini file for customization
- [ ] Add support for Maschine
- [ ] Add support for FL Studio
- [ ] Add support for Reason Studio
- [ ] Add support for Reaper

---

## Contributing

Feel free to dive in! [Open an issue](https://github.com/centomila/standard-readme/issues/new) or submit PRs.

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) Code of Conduct.

## License

MIT License

Copyright (c) [2022] [Franco Baccarini]

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

## Support this project
