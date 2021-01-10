#include <Arduino_LPS22HB.h>  
#include <Arduino_APDS9960.h>

/**
 * Main code for the Smart Mask with the Arduino nano Iot Ble Sense
 * Utilizes the pressure and proximity sensors and outputs the readings to bluetooth
 * Written by Yohan Sequeira and Karl Frolich - Jan 2021
 */
 
//time between pressure reads
int timeBetweenPressureReads = 50;

//time which last pressure read happened
unsigned long lastPressureRead;

//time between proximity reads
int timeBetweenProximityReads = 200;

//time which last proximity read happened
unsigned long lastProximityRead;

//the pressure in pascals
double pressurePascals;

//the proximity
int proximity;

//an array of 400 pressure values to hold the most recent pressure readings
double pressureList[400];

//an array of the proximity data to hold the most recent proximity data
int proximityList[100];



void setup() {
  //initialize the proximity sensor
  if (!APDS.begin()) {
    Serial.println("Error initializing APDS9960 sensor!");
  }
  
  //initialize ble sensors
  initializeBleSensors();
}

void loop() {
  //pressure read
  if (millis() - lastPressureRead >= timeBetweenPressureReads) {
    lastPressureRead = millis();
    pressurePascals =  BARO.readPressure(KILOPASCAL);
  }
      
  //proximity read
  if (millis() - lastProximityRead >= timeBetweenProximityReads) {
    lastProximityRead = millis();
    if (APDS.proximityAvailable()) {
      proximity = APDS.readProximity();
    }
  }

  Serial.println(pressurePascals);

  //push the pressure and proximity data to the bluetooth
  sendBleData(pressurePascals,proximity);
}
