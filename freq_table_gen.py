#!/usr/bin/env python3

import math

CLOCK = 96_000_000
BIT_DEPTH = 8

NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
A4_INDEX = NOTES.index('A') + 4 * 12  # = 57
A4_FREQ = 440.0

def get_frequency(note_index):
    return round(A4_FREQ * (2 ** ((note_index - A4_INDEX) / 12)), 2)

def print_clkdiv():
    notes_table = list()
    for octave in range(0, 9+1):
        for note in NOTES:
            note_index = NOTES.index(note) + octave * 12
            notes_table.append((f"{note}{octave}", get_frequency(note_index)))

    for i, (name, freq) in enumerate(notes_table):
        clock_divider = int(round((CLOCK * 2) / (2**BIT_DEPTH * freq)))
        print(f"\t\t{i} => to_unsigned({clock_divider}, 16), -- {name} {freq}Hz")

if __name__ == "__main__":
    print_clkdiv()