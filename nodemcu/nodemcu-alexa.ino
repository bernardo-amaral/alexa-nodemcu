#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>

ESP8266WiFiMulti WiFiMulti;
const String baseUrl = "http://us-central1-fir-api-2ab96.cloudfunctions.net/app/api";

void setup() {

  Serial.begin(115200);
  Serial.setDebugOutput(true);

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP("NightShade 2.4G", "");
}

void loop() {
  // wait for WiFi connection
  if ((WiFiMulti.run() == WL_CONNECTED)) {
    Serial.println("");
    Serial.println("WiFi conectado");
    Serial.println("Endereco IP : ");
    Serial.println(WiFi.localIP());

    HTTPClient https;

    char* endPoint = "/device/ilumina%C3%A7%C3%A3o%20da%20sala";

    Serial.print("[HTTP] begin...\n");
    if (https.begin(baseUrl + endPoint)) {
      https.addHeader("Content-Type", "application/json");

      char message[40];
      sprintf(message, "[HTTP] GET... %s\n", endPoint);

      Serial.print(message);
      int httpCode = https.GET();

      if (httpCode > 0) {
        Serial.printf("[HTTP] GET RESPONSE... code: %d\n", httpCode);
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          DynamicJsonDocument doc(1024);
          DeserializationError error = deserializeJson(doc, https.getString());

          const char* deviceName = doc["id"];
          const boolean deviceStatus = doc["on"];
          const char* deviceUpdated = doc["updated"];

          Serial.print("Device: ");
          Serial.print(deviceName);
          Serial.print(" Status: ");
          Serial.print(deviceStatus);
          Serial.print(" Updated: ");
          Serial.print(deviceUpdated);
          Serial.print("\n");
        }
      } else {
        Serial.printf("[HTTPS] GET... failed, error: %s\n", https.errorToString(httpCode).c_str());
      }

      https.end();
    } else {
      Serial.printf("[HTTPS] Unable to connect\n");
    }
  }

  Serial.println("Wait 10s before next round...");
  delay(1000);
}
