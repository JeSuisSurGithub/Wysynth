#!/usr/bin/env python3
import math

note_names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

A4_index = note_names.index('A') + 4 * 12  # = 57
A4_freq = 440.0

def get_frequency(note_index):
    return round(A4_freq * (2 ** ((note_index - A4_index) / 12)), 2)

notes_table = []
for octave in range(1, 6 + 1):
    for name in note_names:
        note_index = note_names.index(name) + octave * 12
        notes_table.append((f"{name}{octave}", get_frequency(note_index)))

i = 0
for name,freq in notes_table:
    print(f"\t\t{i} => to_unsigned({int((27000000 * 2) / (256 * freq))}, 16), -- {name} {freq}")
    i += 1
