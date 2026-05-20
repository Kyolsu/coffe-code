#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <ArduinoJson.h>
#include <USB.h>
#include <USBHIDKeyboard.h>

// Instancia del teclado USB
USBHIDKeyboard Keyboard;

// --- Configuración WiFi y Servidor ---
const char* ssid = "Mega-2.4G-63AF";
const char* password = "m3q7WwJdct";
const char* serverUrl = "http://192.168.100.39:3000/api"; 

// --- Configuración Pines ---
#define SS_PIN 10     // RFID SDA
#define RST_PIN 9     // RFID Reset
#define BTN_OK 4      // Botón Completar Orden -> Mandará ENTER
#define BTN_BACK 5    // Botón Regresar -> Mandará ESCAPE
#define JOY_X 1       // Eje X Joystick
#define JOY_Y 2       // Eje Y Joystick

MFRC522 rfid(SS_PIN, RST_PIN);

// Control de tiempos (Debounce)
unsigned long ultimoTiempoBoton = 0;
const unsigned long tiempoDebounce = 250;

// Control RFID anti-duplicados
String lastUid = "";
unsigned long lastRfidTime = 0;
const unsigned long rfidDebounce = 2000; 

void setup() {
  Serial.begin(115200);
 
  Keyboard.begin();
  USB.begin();

  // Configurar botones como entrada Pull-Up (Conectados a GND)
  pinMode(BTN_OK, INPUT_PULLUP);
  pinMode(BTN_BACK, INPUT_PULLUP);

  // Inicializar periféricos físicos (SPI y RFID)
  SPI.begin(); // Usa pines nativos 11, 12, 13
  rfid.PCD_Init();

  // Conectar a la red Huawei de tu casa
  WiFi.disconnect(true);
  delay(1000);
  WiFi.mode(WIFI_STA);
  delay(500);
  WiFi.begin(ssid, password);
  
  Serial.print("Conectando a red Wifi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n¡Conectado con éxito a Megacable!");
  Serial.print("IP asignada: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  leerJoystickTeclado();
  leerBotonesTeclado();
  leerRFIDWiFi();
  delay(10); // Ciclo rápido para respuesta inmediata del joystick
}

////////////
//JOYSTICK
///////////
void leerJoystickTeclado() {
  int yVal = analogRead(JOY_Y);
  int xVal = analogRead(JOY_X);

  // El joystick se mueve en el eje Y para subir y bajar en la lista del Frontend
  if (yVal > 3300) {
    Serial.println("[HID] Mandando: Flecha Abajo");
    Keyboard.press(KEY_DOWN_ARROW);
    delay(50);
    Keyboard.releaseAll();
    delay(180); // Retraso prudente para que no salte 5 órdenes de golpe
  } 
  else if (yVal < 800) {
    Serial.println("[HID] Mandando: Flecha Arriba");
    Keyboard.press(KEY_UP_ARROW);
    delay(50);
    Keyboard.releaseAll();
    delay(180);
  }

  if (xVal > 3300) {
    Serial.println("[HID] Mandando: Flecha Derecha");
    Keyboard.press(KEY_RIGHT_ARROW);
    delay(50);
    Keyboard.releaseAll();
    delay(180);
  } 
  else if (xVal < 800) {
    Serial.println("[HID] Mandando: Flecha Izquierda");
    Keyboard.press(KEY_LEFT_ARROW);
    delay(50);
    Keyboard.releaseAll();
    delay(180);
  }
}


////////////////////
//botones
///////////////////
void leerBotonesTeclado() {
  if ((millis() - ultimoTiempoBoton) > tiempoDebounce) {
    
    // Botón OK -> Envía un 'Enter' a la página web
    if (digitalRead(BTN_OK) == LOW) {
      Serial.println("[HID] Mandando: ENTER");
      Keyboard.press(KEY_RETURN); 
      delay(50);
      Keyboard.releaseAll();
      ultimoTiempoBoton = millis();
    }
    
    // Botón BACK -> Envía un 'Escape' a la página web
    if (digitalRead(BTN_BACK) == LOW) {
      Serial.println("[HID] Mandando: ESCAPE");
      Keyboard.press('R'); 
      delay(50);
      Keyboard.releaseAll();
      ultimoTiempoBoton = millis();
    }
  }
}

// 
// RFID
// 
void leerRFIDWiFi() {
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) return;

  String uidString = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    uidString += String(rfid.uid.uidByte[i] < 0x10 ? "0" : "");
    uidString += String(rfid.uid.uidByte[i], HEX);
  }
  uidString.toUpperCase();

  if (uidString == lastUid && (millis() - lastRfidTime) < rfidDebounce) {
    rfid.PICC_HaltA();
    return;
  }
  lastUid = uidString;
  lastRfidTime = millis();

  Serial.println("\n[WI-FI] Tarjeta detectada: " + uidString);
  ejecutarPeticionRFID(uidString);

  rfid.PICC_HaltA();
}

void ejecutarPeticionRFID(String uid) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String(serverUrl) + "/iot/rfid/" + uid;
    http.begin(url);
    
    int httpResponseCode = http.GET();
    Serial.print("[WI-FI] Código de respuesta HTTP: ");
    Serial.println(httpResponseCode);
    
    if (httpResponseCode > 0) {
      String payload = http.getString();
      Serial.println("[WI-FI] Respuesta del servidor: " + payload);
    }
    http.end();
  } else {
    Serial.println("[WI-FI] Error: Se cayó el Wi-Fi");
  }
}