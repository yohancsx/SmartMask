//use some custom libraries for RMS audio data
#include <Arduino_LPS22HB.h>
#include "Nano33BLEPressure.h"
#include "Nano33BLEMicrophoneRMS.h"
#include "Nano33BLEProximity.h"

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
int timeBetweenProximityReads = 10;

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


//initializes all the sensors
void initializeAllSensors(){

  //initialize the microphone
  MicrophoneRMS.begin();

  //init the pressure sensor
  Pressure.begin();

  //init the proximity sensor
  Proximity.begin();

   //delay for sensors to warm up
   delay(3000);
}



//takes all the sensor readings, and updates the variables including the sensor data and buffer data
void takeSensorReadings() {
  //pressure read
  if (millis() - lastPressureRead >= timeBetweenPressureReads) {
  if(Pressure.pop(pressureData))
    {
      pressurePascals = pressureData.barometricPressure;
      lastPressureRead = millis();
    }
  }
      
  //proximity read
  if (millis() - lastProximityRead >= timeBetweenProximityReads) {
    if(Proximity.pop(proximityData))
    {
      proximity = proximityData.proximity;
      lastProximityRead = millis();
    }
  }

  //mic read
  if (millis() - lastMicRead >= timeBetweenMicReads) {
    if(MicrophoneRMS.pop(microphoneData)){
      intermediateAudio = microphoneData.RMSValue;
      lastMicRead = millis();
     //if above threshold
     if(intermediateAudio > audioThresh){
      audioLevel = microphoneData.RMSValue;
     } else {
      audioLevel = audioLevel/1.1;
     }
    }
  }
}
