//use some custom libraries for RMS audio data
#include <Arduino_LPS22HB.h>
#include "Nano33BLEPressure.h"
#include "Nano33BLEMicrophoneRMS.h"
#include "Nano33BLEProximity.h"
//#include "model.h"

/**
 * Main code for the Smart Mask with the Arduino nano Iot Ble Sense
 * Utilizes the pressure and proximity sensors and outputs the readings to bluetooth
 * Written by Yohan Sequeira and Karl Frolich - Jan 2021
 */
 
//define some numbers for the audio aquisition
#define GAIN (1.0f/50)
#define SOUND_THRESHOLD 1000

//the mic interface object
Nano33BLEMicrophoneRMSData microphoneData;

//the pressure interface object
Nano33BLEPressureData pressureData;

//the proximity interface object
Nano33BLEProximityData proximityData;

//time between pressure reads
int timeBetweenPressureReads = 10;

//time which last pressure read happened
unsigned long lastPressureRead;

//time between proximity reads
int timeBetweenProximityReads = 20;

//time which last proximity read happened
unsigned long lastProximityRead;

//time between mic reads
int timeBetweenMicReads = 10;

//time which last Mic read happened
unsigned long lastMicRead;

//the pressure in pascals
float pressurePascals;

//the proximity
float proximity;

//the mic value
int audioLevel;

//the intermediate audio value
int intermediateAudio;

//the audio threshold
int audioThresh = 10000;

//an array of 400 pressure values to hold the most recent pressure readings
float pressureList[200];

//an array of the proximity data to hold the most recent proximity data
float proximityList[100];

//an array of the audio features to hold the most recent audio data
int audioList[100];

void setup() {
  Serial.begin(115200);
  
  //initialize ble for sending sensor data
  initializeBleSensors();

  //initialize the microphone
  MicrophoneRMS.begin();

  //init the pressure sensor
  Pressure.begin();

  //init the proximity sensor
  Proximity.begin();

   //delay for sensors to warm up
   delay(3000);
}

void loop() {
  //pressure read
  if (millis() - lastPressureRead >= timeBetweenPressureReads) {
  if(Pressure.pop(pressureData))
    {
      pressurePascals = pressureData.barometricPressure;
    }
  }
      
  //proximity read
  if (millis() - lastProximityRead >= timeBetweenProximityReads) {
    if(Proximity.pop(proximityData))
    {
      proximity = proximityData.proximity;
    }
  }

  //mic read
  if (millis() - lastMicRead >= timeBetweenMicReads) {
    if(MicrophoneRMS.pop(microphoneData)){
      intermediateAudio = microphoneData.RMSValue;
     //if above threshold
     if(intermediateAudio > audioThresh){
      audioLevel = microphoneData.RMSValue;
     } else {
      audioLevel = audioLevel/1.1;
     }
    }
  }
  



  // print the sensor value 
  //print values for debugging
  Serial.print(pressurePascals);
  //Serial.print(",");
  //Serial.print(proximity);
  Serial.print(",");
  Serial.println(audioLevel);
  
  
  //add value to pressure array, by copying things in
  //then adding the value
  for(int i = 0; i < 198; i++){
    pressureList[i] = pressureList[i+1];
  }
  pressureList[199] = pressurePascals;

  //do the same for the audio
  

  //push the pressure, audio and proximity data to the bluetooth
  sendBleData(pressurePascals,proximity);
}



//classify some data using the classifier we have
void classify() {
    Serial.print("Predicted class: ");
}
