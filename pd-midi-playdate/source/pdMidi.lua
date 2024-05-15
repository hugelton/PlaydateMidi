-- pdMidi
-- v0.1
-- library for exchanging MIDI data with the Playdate console.
-- [Playdate] <---USB---> [pdMidi host] <---USB/MIDI---> [MIDI device]

pdMidi = {}
local isInitialized = false
local isReady = false
local clockCallback = nil
local outputDevice = nil

-- Initialize pdMidi
function pdMidi.begin()
    if not isInitialized then
        isInitialized = true
    end
end

-- Set the callback function to be called when MIDI Clock is received
function pdMidi.setClockCallback(callback)
    clockCallback = callback
end

-- Send MIDI Clock
function pdMidi.clockSend()
    if isInitialized and isReady then
        print("pdmidi_clock")
    end
end

-- Get the current MIDI output device
function pdMidi.getOutput()
    if isInitialized and isReady then
        print("pdmidi_getoutput")
    end
    return outputDevice
end

-- Send a heartbeat message to check if the device is alive
function pdMidi.heartbeat()
    if isInitialized and isReady then
        print("pdmidi_heartbeat")
    end
end

-- Send a MIDI Note On message
function pdMidi.noteOn(noteNumber, velocity)
    if isInitialized and isReady then
        print("pdmidi_noteon", noteNumber, velocity)
    end
end

-- Send a MIDI Note Off message
function pdMidi.noteOff(noteNumber, velocity)
    if isInitialized and isReady then
        print("pdmidi_noteoff", noteNumber, velocity)
    end
end

-- Callback function called when a serial message is received
function playdate.serialMessageReceived(message)
    if message == "pdmidi_ready" then
        isReady = true
        print("pdmidi_init")
    elseif message == "pdmidi_clock" then
        if clockCallback then
            clockCallback()
        end
    elseif message == "din" or message == "host" or message == "usb" then
        outputDevice = message
    end
end

return pdMidi
