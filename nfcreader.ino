#include <SPI.h>
#include <MFRC522.h>

// Definisci i pin collegati al modulo NFC
#define SS_PIN 21   // Pin SDA
#define RST_PIN 22  // Pin RST

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Crea un'istanza del lettore NFC

void setup() {
  Serial.begin(115200);  // Avvia la comunicazione seriale
  SPI.begin();           // Inizializza SPI
  mfrc522.PCD_Init();    // Inizializza il modulo MFRC522

  Serial.println("Pronto per leggere il tag NFC");
}

void loop() {
  // Se un tag NFC viene avvicinato al lettore
  if (mfrc522.PICC_IsNewCardPresent()) {
    if (mfrc522.PICC_ReadCardSerial()) {
      Serial.println("Tag NFC trovato!");
      
      // Stampa l'ID del tag NFC
      Serial.print("ID del tag: ");
      for (byte i = 0; i < mfrc522.uid.size; i++) {
        Serial.print(mfrc522.uid.uidByte[i], HEX);
        Serial.print(" ");
      }
      Serial.println();
      
      // Termina la lettura del tag NFC
      mfrc522.PICC_HaltA();
    }
  }
}
