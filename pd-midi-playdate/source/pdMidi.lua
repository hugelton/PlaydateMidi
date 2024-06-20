-- pdMidi
-- v0.3
-- library for exchanging MIDI data with the Playdate console.
-- [Playdate] <---USB---> [pdMidi host] <---USB/MIDI---> [MIDI device]


pdMidi = {}

local isInitialized = false
local clockCallback = nil
local noteCallback = nil
local startCallback = nil
local stopCallback = nil
local continueCallback = nil
local ccCallback = nil
local outputDevice = nil

-- Initialize pdMidi
function pdMidi.begin(channel)
    if not isInitialized then
        isInitialized = true
    end
end

-- Set the callback function to be called when MIDI Clock is received
function pdMidi.setClockCallback(callback)
    clockCallback = callback
end

-- Set the callback function to be called when Note On/Off is received
function pdMidi.setNoteCallback(callback)
    noteCallback = callback
end

-- Set the callback function to be called when Start is received
function pdMidi.setStartCallback(callback)
    startCallback = callback
end

-- Set the callback function to be called when Stop is received
function pdMidi.setStopCallback(callback)
    stopCallback = callback
end

-- Set the callback function to be called when Continue is received
function pdMidi.setContinueCallback(callback)
    continueCallback = callback
end

-- Set the callback function to be called when Control Change is received
function pdMidi.setCCCallback(callback)
    ccCallback = callback
end

-- Send MIDI Clock
function pdMidi.clockSend()
    if isInitialized then
        print("/pdmidi/clock/")
    end
end

-- send start
function pdMidi.startSend()
    if isInitialized then
        print("/pdmidi/start/")
    end
end

-- send stop
function pdMidi.stopSend()
    if isInitialized then
        print("/pdmidi/stop/")
    end
end

-- send continue
function pdMidi.continueSend()
    if isInitialized then
        print("/pdmidi/continue/")
    end
end

-- Get the current MIDI output device
function pdMidi.getOutput()
    if isInitialized then
        print("/pdmidi/getoutput/")
    end
    return outputDevice
end

-- Send a heartbeat message to check if the device is alive
function pdMidi.heartbeat()
    if isInitialized then
        print("/pdmidi/heartbeat/")
    end
end

-- Program change
function pdMidi.programChange(channel, value)
    if isInitialized then
        print(string.format("/pdmidi/programchange/%d/ %d", channel, value))
    end
end

-- Pitch Wheel
function pdMidi.pitchWheelChange(channel, value)
    if isInitialized then
        print(string.format("/pdmidi/pitchwheel/%d/ %d", channel, value))
    end
end

-- CC
function pdMidi.controlChange(channel, type, value)
    if isInitialized then
        print(string.format("/pdmidi/cc/%d/ %d %d", channel, type, value))
    end
end

-- Send a MIDI Note On message
function pdMidi.noteOn(channel, noteNumber, velocity)
    if isInitialized then
        print(string.format("/pdmidi/noteon/%d/%d/ %d", channel, noteNumber, velocity))
    end
end

-- Send a MIDI Note Off message
function pdMidi.noteOff(channel, noteNumber, velocity)
    if isInitialized then
        print(string.format("/pdmidi/noteoff/%d/%d/ %d", channel, noteNumber, velocity))
    end
end

-- Callback function called when a serial message is received
function playdate.serialMessageReceived(message)
    if message == "pdmidi_ready" then
        print("/pdmidi/init/")
    elseif message == "/pdmidi/clock/" then
        if clockCallback then
            clockCallback()
        end
    elseif message:match("^/pdmidi/noteon/") then
        local _, _, channel, noteNumber, velocity = message:find("^/pdmidi/noteon/(%d+)/(%d+) (%d+)")
        if channel and noteNumber and velocity then
            if noteCallback then
                noteCallback("noteon", tonumber(channel), tonumber(noteNumber), tonumber(velocity))
            end
        end
    elseif message:match("^/pdmidi/noteoff/") then
        local _, _, channel, noteNumber, velocity = message:find("^/pdmidi/noteoff/(%d+)/(%d+) (%d+)")
        if channel and noteNumber and velocity then
            if noteCallback then
                noteCallback("noteoff", tonumber(channel), tonumber(noteNumber), tonumber(velocity))
            end
        end
    elseif message == "/pdmidi/start/" then
        if startCallback then
            startCallback()
        end
    elseif message == "/pdmidi/stop/" then
        if stopCallback then
            stopCallback()
        end
    elseif message == "/pdmidi/continue/" then
        if continueCallback then
            continueCallback()
        end
    elseif message:match("^/pdmidi/control/") then
        local _, _, channel, controlNumber, controlValue = message:find("^/pdmidi/control/(%d+)/(%d+)/(%d+)")
        if channel and controlNumber and controlValue then
            if ccCallback then
                ccCallback(tonumber(channel), tonumber(controlNumber), tonumber(controlValue))
            end
        end
    elseif message == "/pdmidi/heartbeat/" then
        pdMidi.heartbeat()
    elseif message:match("^/pdmidi/getoutput/") then
        pdMidi.getOutput()
    elseif message == "din" or message == "host" or message == "usb" then
        outputDevice = message
    end
end

return pdMidi
