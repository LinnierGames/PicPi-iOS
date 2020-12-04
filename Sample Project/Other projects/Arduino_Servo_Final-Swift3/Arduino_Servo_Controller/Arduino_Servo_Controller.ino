// Arduino Bluetooth LE Servo Controlled by iOS

#include <Servo.h> 
#include <SoftwareSerial.h>

int LED = 13;  // Most Arduino boards have an onboard LED on pin 13
Servo myservo;    // Create servo object to control the servo

SoftwareSerial BLE_Shield(4,5);  // Configure the Serial port to be on pins D4 and D5. This
                                 // will match the jumpers on the BLE Shield (RX -> D4 & TX /> D5).

void setup()  // Called only once per startup
{
  pinMode(LED, OUTPUT);     // Set pin as an output
  digitalWrite(LED, HIGH);  // Turn on LED (ie set to HIGH voltage)
  
  myservo.attach(9);        // Attach the servo object to pin 9
  myservo.write(0);         // Initialize servo position to 0
  BLE_Shield.begin(9600);   // Setup the serial port at 9600 bps. This is the BLE Shield default baud rate.
}

void loop()  // Continuous loop
{
  // See if new position data is available
  if(BLE_Shield.available()) {
    myservo.write(BLE_Shield.read());  // Write position to servo
  }
}

