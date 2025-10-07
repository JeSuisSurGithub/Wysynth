#!/usr/bin/env python3

import asyncio
from bleak import BleakClient

HM10_ADDRESS = "68:5E:1C:26:EC:65" # My HM-10 MAC
UART_TX_CHAR_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb"
PAUSE_TIME = 0.150
NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

def notes_to_int(name):
    if name == "XX":
        return 255
    if "#" in name:
        return NOTES.index(name[0:2]) + int(name[2:]) * 12
    else:
        return NOTES.index(name[0]) + int(name[1:]) * 12

NOTE_LIST = ["C4", "XX", "C4", "XX", "G4", "B4", "C5", "XX", "C4", "XX", "C4", "XX", "G4", "F4", "E4", "XX"]*3
SEND_NOTE = [item for note in NOTE_LIST for item in (notes_to_int(note), 255)]
RECV_NOTE = list()

def notification(_sender, data):
    note = int.from_bytes(data, byteorder='big')
    print(f"Received[{len(RECV_NOTE)}]: {note}")
    RECV_NOTE.append(note)

async def send_data():
    async with BleakClient(HM10_ADDRESS) as client:
        print("Connected:", client.is_connected)

        await client.start_notify(UART_TX_CHAR_UUID, notification)

        for idx, note in enumerate(SEND_NOTE):
            raw_note = bytes([note])
            print(f"Sending[{idx}]: {note}")
            await client.write_gatt_char(UART_TX_CHAR_UUID, raw_note)
            await asyncio.sleep(PAUSE_TIME)

        await asyncio.sleep(PAUSE_TIME)

        await client.stop_notify(UART_TX_CHAR_UUID)

if __name__ == "__main__":
    print("Going to send:")
    print([data for data in SEND_NOTE])
    asyncio.run(send_data())
    print("\nHas received:")
    print([data for data in RECV_NOTE])
    if SEND_NOTE == RECV_NOTE:
        print("Transmission successful")
    else:
        print("Transmission failure")
