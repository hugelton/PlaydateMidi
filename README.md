# Playdate MIDI Library and Interface

This repository contains a Lua library and interface for exchanging MIDI data with the Playdate console.

**Note: This project is still experimental and currently only supports clock synchronization.**

## Lua Library for Playdate

The Playdate console can only exchange serial text data, so MIDI commands need to be converted to text for communication. As a result, a separate pdMidi host is required to exchange pure MIDI data (USB/DIN/TRS).

Conceptual diagram:
[Playdate] <---USB---> [pdMidi host] <---USB/MIDI--->

### Features
- Initialization of the pdMidi library
- Setting a callback function for receiving MIDI Clock messages
- Sending MIDI Clock messages from the Playdate console

### Usage
1. Import the `pd-midi` library in your Playdate project.
2. Call `pdMidi.begin()` to initialize the library.
3. Set a callback function using `pdMidi.setClockCallback(callback)` to handle received MIDI Clock messages.
4. Use `pdMidi.clockSend()` to send MIDI Clock messages from the Playdate console.

Example:
```lua
import "pd-midi"

function midiClockReceived()
    print("MIDI Clock received")
end

pdMidi.begin()
pdMidi.setClockCallback(midiClockReceived)
pdMidi.clockSend()
```

## pdMidi Host
The pdMidi host is built using an RP2040 microcontroller and acts as a USB host. This device converts pdMIDI's MIDI over serial messages to actual MIDI commands.
The RP2040 emulates a USB host port using its Programmable I/O (PIO) functionality.
### Features

USB host functionality using the RP2040 microcontroller
Conversion of pdMIDI's MIDI over serial messages to MIDI commands
Support for USB, DIN, and TRS MIDI interfaces

### Hardware Requirements

RP2040 microcontroller board
USB host shield or custom USB host circuitry
MIDI interface (USB, DIN, or TRS)

### Firmware
The firmware for the pdMidi host will be provided in a separate repository.

## Contributing
Contributions to this project are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License
This project is licensed under the MIT License.
