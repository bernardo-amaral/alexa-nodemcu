#include <Arduino.h>
#include <ESP8266WiFi.h>
#include "fauxmoESP.h"
#include "credentials.h"

#define SERIAL_BAUDRATE 115200
 
fauxmoESP fauxmo;

void wifiSetup() {
    WiFi.mode(WIFI_STA);
    Serial.printf("[WIFI] Connecting to %s ", WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
 
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(100);
    }
    Serial.println();
    Serial.printf("[WIFI] STATION Mode, SSID: %s, IP address: %s\n", WiFi.SSID().c_str(), WiFi.localIP().toString().c_str());
}

void devicesSetup() {
  fauxmo.addDevice("Luz quarto");
  fauxmo.addDevice("Luz escritório");
  fauxmo.setPort(80); 
  fauxmo.enable(true);
  fauxmo.onSetState([](unsigned char device_id, const char * device_name, bool state, unsigned char value) {
    Serial.printf("[MAIN] Device #%d (%s) state: %s value: %d\n", device_id, device_name, state ? "ON" : "OFF", value);
    
    boolean device_state = (state) ? HIGH : LOW;
    
    if (device_id == 0) {
      digitalWrite(D3, device_state);
    }
    if (device_id == 1) {
      digitalWrite(D4, device_state);
    }    
  }); 
}

void pinsSetup() {
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
}
 
void setup() {
  Serial.begin(SERIAL_BAUDRATE);
  Serial.println("FauxMo demo sketch");
  Serial.println("After connection, ask Alexa/Echo to 'turn <devicename> on' or 'off'");

  pinsSetup();
  wifiSetup();
  devicesSetup();
}
 
void loop() {
  fauxmo.handle();

  static unsigned long last = millis();
  if (millis() - last > 5000) {
      last = millis();
      Serial.printf("[MAIN] Free heap: %d bytes\n", ESP.getFreeHeap());
  }
}
