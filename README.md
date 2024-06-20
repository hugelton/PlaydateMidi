# pdMidi

pdMidi is a Lua library and interface for exchanging MIDI data between the Playdate console and MIDI devices using a separate pdMidi host device.
Since playdate does not support direct serial or MIDI communication, it communicates OSC-like messages via text serial.

**For the host device, it was branched out into a separate project.**
[pdMidi-host](https://github.com/hugelton/pdMidi-host)

## Features

- Initialization of the pdMidi library on the Playdate console
- Setting a callback function for receiving MIDI Clock messages
- Sending MIDI Clock messages from the Playdate console
- Sending MIDI Note On/Off messages from the Playdate console

## Architecture

The pdMidi system consists of two main components:

1. Playdate Console:

- Runs the Lua library for pdMidi
- Communicates with the pdMidi host device via USB serial communication
- Sends and receives MIDI commands as text messages

2. pdMidi Host Device:

For the host device, it was branched out into a separate project.
[pdMidi-host](https://github.com/hugelton/pdMidi-host)

```
[Playdate] <---USB---> [pdMidi Host] <---USB/MIDI---> [MIDI Device]
```

## Lua Library

1. Import the pdMidi library in your Playdate project.
2. Call pdMidi.begin() to initialize the library.
3. Set a callback function using pdMidi.setClockCallback(callback) to handle received MIDI Clock messages.

### Example

Please compile and run main.lua on Playdate.

### Send Functions

| Function                                        | /pdmidi/ Message                                    | Payload Data Content and Types                                                                                                   | Parsed MIDI Example                    |
| ----------------------------------------------- | --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `pdMidi.clockSend()`                            | `/pdmidi/clock/`                                    | None                                                                                                                             | [0xF8]                                 |
| `pdMidi.startSend()`                            | `/pdmidi/start/`                                    | None                                                                                                                             | [0xFA]                                 |
| `pdMidi.stopSend()`                             | `/pdmidi/stop/`                                     | None                                                                                                                             | [0xFC]                                 |
| `pdMidi.continueSend()`                         | `/pdmidi/continue/`                                 | None                                                                                                                             | [0xFB]                                 |
| `pdMidi.programChange(channel, value)`          | `/pdmidi/programchange/[channel]/ [value]`          | `channel`: MIDI channel number (integer) <br> `value`: Program change value (integer)                                            | [0xC0 + channel, value]                |
| `pdMidi.pitchWheelChange(channel, value)`       | `/pdmidi/pitchwheel/[channel]/ [value]`             | `channel`: MIDI channel number (integer) <br> `value`: Pitch wheel value (integer)                                               | [0xE0 + channel, value]                |
| `pdMidi.controlChange(channel, type, value)`    | `/pdmidi/cc/[channel]/ [type] [value]`              | `channel`: MIDI channel number (integer) <br> `type`: Control change type (integer) <br> `value`: Control change value (integer) | [0xB0 + channel, type, value]          |
| `pdMidi.noteOn(channel, noteNumber, velocity)`  | `/pdmidi/noteon/[channel]/[noteNumber] [velocity]`  | `channel`: MIDI channel number (integer) <br> `noteNumber`: Note number (integer) <br> `velocity`: Velocity value (integer)      | [0x90 + channel, noteNumber, velocity] |
| `pdMidi.noteOff(channel, noteNumber, velocity)` | `/pdmidi/noteoff/[channel]/[noteNumber] [velocity]` | `channel`: MIDI channel number (integer) <br> `noteNumber`: Note number (integer) <br> `velocity`: Velocity value (integer)      | [0x80 + channel, noteNumber, velocity] |

## Callback Functions

| Function                               | Description                                                                        |
| -------------------------------------- | ---------------------------------------------------------------------------------- |
| `pdMidi.setClockCallback(callback)`    | Sets the callback function to be called when a MIDI clock message is received.     |
| `pdMidi.setNoteCallback(callback)`     | Sets the callback function to be called when a Note On/Off message is received.    |
| `pdMidi.setStartCallback(callback)`    | Sets the callback function to be called when a Start message is received.          |
| `pdMidi.setStopCallback(callback)`     | Sets the callback function to be called when a Stop message is received.           |
| `pdMidi.setContinueCallback(callback)` | Sets the callback function to be called when a Continue message is received.       |
| `pdMidi.setCCCallback(callback)`       | Sets the callback function to be called when a Control Change message is received. |

## Contributing

Contributions to this project are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.

## Acknowledgments

- [Pico-PIO-USB](https://github.com/sekigon-gonnoc/Pico-PIO-USB/tree/main)
- [PD-Camera project](https://github.com/t0mg/pd-camera)
