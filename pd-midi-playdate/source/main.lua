-- pdMidi example v0.2
-- [receive] MIDI clock to print interval from microsec.
-- host,
--   pdmidi_init : init pdMidi on Playdate
--   pdmidi_clock : receive MIDI clock
-- [send] MIDI clock by Playdate timer. A button : start, D-pad : change BPM
-- [send] MIDI note on/off by Playdate B button.

import "pdMidi"

local isSending = false
local bpm = 120
local interval = 60 / bpm / 24
local lastTick = 0
local noteNumber = 60
local velocity = 127
local crankValue = 0
local crankValueRecent = 0

-- Callback function called when MIDI Clock is received
function midiClockReceived()
    local currentTime = playdate.getCurrentTimeMilliseconds()
    print("MIDI Clock received at " .. currentTime .. " ms")
end

-- Initialize pdMidi
pdMidi.begin()

-- Set the callback function for receiving MIDI Clock
pdMidi.setClockCallback(midiClockReceived)




-- Function to start sending MIDI Clock
function startSending()
    pdMidi.startSend()
    isSending = true
    playdate.resetElapsedTime()
    lastTick = 0
end

-- Function to stop sending MIDI Clock
function stopSending()
    pdMidi.stopSend()
    isSending = false
end

-- Function to update BPM and interval
function updateBPM(delta)
    bpm = bpm + delta
    if bpm < 20 then
        bpm = 20
    elseif bpm > 300 then
        bpm = 300
    end
    interval = 60 / bpm / 24
end

-- Infinite loop
function playdate.update()
    -- Check button presses
    if playdate.buttonJustPressed(playdate.kButtonA) then
        if isSending then
            stopSending()
        else
            startSending()
        end
    end

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        updateBPM(0.5)
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        updateBPM(-0.5)
    end

    -- Send MIDI Note On/Off when B button is pressed/released
    if playdate.buttonJustPressed(playdate.kButtonB) then
        pdMidi.noteOn(1, noteNumber, velocity)
    elseif playdate.buttonJustReleased(playdate.kButtonB) then
        pdMidi.noteOff(1, noteNumber, velocity)
    end


    if playdate.buttonIsPressed(playdate.kButtonRight) then
        noteNumber = math.min(noteNumber + 1, 127)
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        noteNumber = math.max(noteNumber - 1, 1)
    end


    -- Send MIDI Clock if sending is enabled
    if isSending then
        local currentTime = playdate.getElapsedTime()
        if currentTime - lastTick >= interval then
            pdMidi.clockSend()
            lastTick = currentTime
        end
    end

    -- Crank to value
    local change, acceleratedChange = playdate.getCrankChange()


    crankValueRecent = crankValue

    crankValue = math.floor(math.min(127, math.max(0, crankValue + (acceleratedChange * 0.1))))
    if (crankValueRecent ~= crankValue) then
        pdMidi.controlChange(1, 1, crankValue)
    end



    -- Display BPM and sending status
    playdate.graphics.clear()
    playdate.graphics.drawText("*Clock*", 10, 10)
    playdate.graphics.drawText("BPM: " .. bpm, 10, 30)
    if isSending then
        playdate.graphics.drawText("Sending MIDI Clock", 10, 50)
    else
        playdate.graphics.drawText("Not Sending", 10, 50)
    end

    playdate.graphics.drawText("Ⓐ:start/stop  ⬆️⬇️:change the BPM", 10, 70)
    playdate.graphics.drawText("*Note*", 10, 110)
    playdate.graphics.drawText("Number:" .. noteNumber, 10, 130)
    playdate.graphics.drawText("Ⓑ:note on/off ⬅️➡️:change the note number", 10, 150)


    playdate.graphics.drawText("*ControlChange*", 10, 190)
    -- playdate.graphics.drawText("Number:" .. noteNumber, 10, 130)
    playdate.graphics.drawText("🎣:change value to Moduration", 10, 210)
    playdate.graphics.drawText("*" .. crankValue .. "*", 270, 210)
end
