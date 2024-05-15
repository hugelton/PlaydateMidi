#include "Adafruit_TinyUSB.h"
#include <MIDI.h>

#define VENDOR_ID   0x1331
#define PRODUCT_ID  0x5740

Adafruit_USBH_Host USBHost;
MIDI_CREATE_DEFAULT_INSTANCE();

void setup() {
  Serial1.begin(115200);
  
  // USB Hostの初期化
  USBHost.begin(0);
  
  // MIDIの初期化
  MIDI.begin(MIDI_CHANNEL_OMNI);
}

void loop() {
  USBHost.task();
  
  if (Serial1.available()) {
    String message = Serial1.readStringUntil('\n');
    processMessage(message);
  }
  
  MIDI.read();
}

void processMessage(String message) {
  if (message == "pdmidi_init") {
    Serial1.println("pdmidi_ready");
  } else if (message == "pdmidi_clock") {
    MIDI.sendRealTime(midi::Clock);
  } else if (message == "pdmidi_getoutput") {
    Serial1.println("host");
  } else if (message == "pdmidi_heartbeat") {
    Serial1.println("pdmidi_heartbeat");
  } else if (message.startsWith("pdmidi_noteon")) {
    int noteNumber = message.substring(14, message.indexOf(' ', 14)).toInt();
    int velocity = message.substring(message.lastIndexOf(' ') + 1).toInt();
    MIDI.sendNoteOn(noteNumber, velocity, 1);
  } else if (message.startsWith("pdmidi_noteoff")) {
    int noteNumber = message.substring(15, message.indexOf(' ', 15)).toInt();
    int velocity = message.substring(message.lastIndexOf(' ') + 1).toInt();
    MIDI.sendNoteOff(noteNumber, velocity, 1);
  }
}

void tuh_mount_cb(uint8_t daddr) {
  Serial1.printf("Device attached, address = %d\r\n", daddr);
}

void tuh_umount_cb(uint8_t daddr) {
  Serial1.printf("Device removed, address = %d\r\n", daddr);
}