#!/usr/bin/env python3

import asyncio
import time
from bleak import BleakClient

HM10_ADDRESS = "68:5E:1C:26:EC:65" # Mine
UART_TX_CHAR_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb"

data_to_send = [item for i in range(24, 119+1) for item in (i, 255)]

async def send_data():
    async with BleakClient(HM10_ADDRESS) as client:
        print("Connected:", client.is_connected)

        for num in data_to_send:
            byte_data = bytes([num])
            await client.write_gatt_char(UART_TX_CHAR_UUID, byte_data)
            print(f"Sent: {num}")
            if num != 255:
                await asyncio.sleep(0.250)

if __name__ == "__main__":
    asyncio.run(send_data())
