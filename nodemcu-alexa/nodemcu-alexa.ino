#include <Arduino.h>
#include <ESP8266WiFi.h>
#include "fauxmoESP.h"
 
#define WIFI_SSID "NightShade 2.4G"
#define WIFI_PASS "*****"
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
  fauxmo.addDevice("Lâmpada quarto");
  fauxmo.addDevice("Lâmpada sala");
  fauxmo.setPort(80); 
  fauxmo.enable(true);
  fauxmo.onSetState([](unsigned char device_id, const char * device_name, bool state, unsigned char value) {
    Serial.printf("[MAIN] Device #%d (%s) state: %s value: %d\n", device_id, device_name, state ? "ON" : "OFF", value);
  }); 
}
 
void setup() {
  Serial.begin(SERIAL_BAUDRATE);
  Serial.println("FauxMo demo sketch");
  Serial.println("After connection, ask Alexa/Echo to 'turn <devicename> on' or 'off'");
 
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