# pdMidi

pdMidi is a Lua library and interface for exchanging MIDI data between the Playdate console and MIDI devices using a separate pdMidi host device.


## Features

- Initialization of the pdMidi library on the Playdate console
- Setting a callback function for receiving MIDI Clock messages
- Sending MIDI Clock messages from the Playdate console
- Sending MIDI Note On/Off messages from the Playdate console
- Receiving MIDI Clock and Note On/Off messages on the pdMidi host device
- Support for USB, DIN, and TRS MIDI interfaces on the pdMidi host device


## Architecture
The pdMidi system consists of two main components:

1. Playdate Console:

+ Runs the Lua library for pdMidi
+ Communicates with the pdMidi host device via USB serial communication
+ Sends and receives MIDI commands as text messages

2. pdMidi Host Device:

+ Built using an RP2040 microcontroller
+ Acts as a USB host and communicates with the Playdate console via USB serial communication
+ Converts pdMIDI's MIDI over serial messages to actual MIDI commands
+ Supports USB, DIN, and TRS MIDI interfaces for connecting to MIDI devices

```
[Playdate] <---USB---> [pdMidi Host] <---USB/MIDI---> [MIDI Device]
```

## Lua Library

1. Import the pdMidi library in your Playdate project.
2. Call pdMidi.begin() to initialize the library.
3. Set a callback function using pdMidi.setClockCallback(callback) to handle received MIDI Clock messages.
4. Use pdMidi.clockSend() to send MIDI Clock messages from the Playdate console.
5. Use pdMidi.noteOn(noteNumber, velocity) and pdMidi.noteOff(noteNumber, velocity) to send MIDI Note On/Off messages.
6. Use pdMidi.getOutput() to get the current MIDI output device.
7. Use pdMidi.heartbeat() to send a heartbeat message to check if the device is alive.


```
import "pdMidi"

function midiClockReceived()
    print("MIDI Clock received")
end

pdMidi.begin()
pdMidi.setClockCallback(midiClockReceived)
pdMidi.clockSend()
pdMidi.noteOn(60, 127)
pdMidi.noteOff(60, 127)
```

## pdMidi Host

**! DRAFT**

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

## Acknowledgments

+ [Pico-PIO-USB](https://github.com/sekigon-gonnoc/Pico-PIO-USB/tree/main)
+ [PD-Camera project](https://github.com/t0mg/pd-camera)
