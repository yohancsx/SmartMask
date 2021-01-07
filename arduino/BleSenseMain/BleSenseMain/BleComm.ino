#include <ArduinoBLE.h>
#include "Nano33BLEPressure.h"

//bluetooth buffer size
#define BLE_BUFFER_SIZES             20

//the bluetooth device name
#define BLE_DEVICE_NAME                "Arduino Nano 33 BLE Sense"

//the local device name
#define BLE_LOCAL_NAME                "BleSmartMask"

//where we store the pressure data
Nano33BLEPressureData pressureData;

//set up the basic ble service for the sensors
BLEService BLESensors("590d65c7-3a0a-4023-a05a-6aaf2f22441c");

//set up the characteristic for the pressure
BLECharacteristic pressureBLE("000B", BLERead | BLENotify | BLEBroadcast, BLE_BUFFER_SIZES);

//set up the characteristic for the proximity
BLECharacteristic proximityBLE("000C", BLERead | BLENotify | BLEBroadcast, BLE_BUFFER_SIZES);

//ble buffer for pressure
char blePressureBuffer[BLE_BUFFER_SIZES];

//ble buffer for proximity
char blePressureBuffer[BLE_BUFFER_SIZES];

//initializes all the BLE sensors
void initializeBleSensors(){

  //wait for BLE to turn on
  if (!BLE.begin()) 
    {
        while (1);    
    }
    
  //set all the BLE data
  BLE.setDeviceName(BLE_DEVICE_NAME);
  BLE.setLocalName(BLE_LOCAL_NAME);
  BLE.setAdvertisedService(BLESensors);
  BLESensors.addCharacteristic(pressureBLE);
  BLESensors.addCharacteristic(proximityBLE);
  BLE.addService(BLESensors);
  BLE.advertise();
}


void sendBleData(double pressureRead, int proximityRead){
  BLEDevice central = BLE.central();
  if(central){
    int writeLength;
  
    //if we are connected
    while(central.connected()){
          
      //convert pressure data and send
      writeLength = sprintf(blePressureBuffer, "%f", (float)pressureRead );
      pressureBLE.writeValue(blePressureBuffer, writeLength);

      //convert proximity data and send
      writeLength = sprintf(bleProximityBuffer, "%f", (float)proximityRead );
      proximityBLE.writeValue(bleProximityBuffer, writeLength);
    }
  }
}
