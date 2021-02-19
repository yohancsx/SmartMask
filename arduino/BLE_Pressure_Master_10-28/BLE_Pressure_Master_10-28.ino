#include <Arduino_LPS22HB.h>      //library for pressure sensor
#include <Servo.h>                //library for servo
#include <Arduino_APDS9960.h>     //library for gesture, color, and proximity sensor

unsigned long lastRead = 0;
unsigned long lastReadCough = 0;
//TODO check if this is right data type
double pressureMultiplyer = 1000;  //1000 for Pascals, 100 for decapas
double pressureRawOffset = 99000;    //The offset to make pressure zero (this can be calculated automatically by calling the function "zeroThePressure"
double pressurePascals;             //Pressure after calibration and in unit of pressureMultiplyer
double pressureList[10];            //List which stores last 10 pressure reads
double medianPressure;              //The median Pressure from all of the previous reads
int numCoughs = 0;                  //The amount of time the user has coughed
int timeBetweenPressureReads = 50;  //The amount of time between each time the pressure is read (miliseconds)
double pressureSlope;               //The slope of the pressure vs time graph (= derivative of pressure with respect to t)
double lastPressureRead;            //The previous reading of the pressure

//Code for the Servo motor
Servo servo1;             //Create a servo object
const int servo1Pin = 3;  //The pin for the servo motor

//Code for the button
const int buttonPin = 4;
int buttonMode = 0;

//SETUP FUNCTION________________________________________
void setup() {
  Serial.begin(9600);
  while (!Serial);  // while the serial stream is not open, do nothing:
  BARO.begin();

  // waitMillis(3000); //code to loop printing zero to catch the start

//  //Servo
//  servo1.attach(servo1Pin);
//  sweepServo1To(6);
//  delay(500);
//  sweepServo1To(105);

  //Gesture, Color, and Proximity sensor
  if (!APDS.begin()) {
    Serial.println("Error initializing APDS9960 sensor!");
  }



  //  Serial.println("Zeroing the pressure");
  //  zeroThePressure(5000);  //call to function to zero the pressure measurements
  //  Serial.println("Finished zeroing the pressure");
  //  Serial.println(pressureRawOffset);
  lastRead = millis();
  lastPressureRead = (pressureMultiplyer * BARO.readPressure(KILOPASCAL)) - pressureRawOffset;


}

//LOOP_________________________________________________
void loop() {


  if (buttonMode == 0) {
    if (millis() - lastRead >= timeBetweenPressureReads) {
      lastRead = millis();

      pressurePascals = (pressureMultiplyer * BARO.readPressure(KILOPASCAL)) - pressureRawOffset; //displays pressure in Pascals
      Serial.print(pressurePascals, 6 ); 
      Serial.println(","); 
      //last number after the comma is for number of decimal points (was 6 originally)    //Comment for cough sensing only
      //    listThePressure();

      pressureSlope = (pressurePascals - lastPressureRead)/timeBetweenPressureReads;   //the pressure slop (or differential pressure)
          //Serial.print("slope = ");
          //Serial.println(pressureSlope, 6);
      lastPressureRead = pressurePascals;

      //  // Detect Coughing
      //    if (pressurePascals >= .03 * pressureMultiplyer) {
      //      if (millis() - lastReadCough >= 300) {
      //        lastReadCough = millis();
      //        numCoughs++;
      //        Serial.print("Number of coughs = ");
      //        Serial.println(numCoughs);
      //      }
      //    }
    }
  }

  else if (buttonMode == 1) {
    // check if a proximity reading is available
    if (APDS.proximityAvailable()) {
      // read the proximity
      // - 0   => close
      // - 255 => far
      // - -1  => error
      int proximity = APDS.readProximity();

      // print value to the Serial Monitor
      Serial.println(proximity);
    }
    delay(20);
  }


  else if (buttonMode == 2) {

  }


}

void waitMillis(int t) {
  long endTime = millis() + t;

  while (endTime >= millis()) {
    Serial.println(0);
    delay(100);
  }
}


void zeroThePressure(int t) {

  long endTime = millis() + t;  //calibrate for t miliseconds
  // double pressureRawArray[100]; //instead of using an array, I will be using a total
  double pressureRaw;
  double pressureRawTotal = 0.0;
  int numberOfPressureRawDataPoints = 0;

  while (endTime >= millis()) {

    if (millis() - lastRead >= timeBetweenPressureReads) {
      lastRead = millis();

      pressureRaw = pressureMultiplyer * BARO.readPressure(KILOPASCAL);
      Serial.println(pressureRaw);   //if this is printed then you cannot see the rest of the plot
      pressureRawTotal = pressureRawTotal + pressureRaw;
      numberOfPressureRawDataPoints++;
    }
  }
  pressureRawOffset = pressureRawTotal / numberOfPressureRawDataPoints;
}

void sweepServo1To(int destination) {

  //Check to make sure you are not moving the servo outside of the hardware range
  if (destination > 120) {
    return;
  }
  if (destination < 0) {
    return;
  }

  if (servo1.read() < destination) {
    for (int currentPos = servo1.read(); currentPos <= destination; currentPos++) { // gently sweeps from current position to 45 degrees
      servo1.write(currentPos);   // tell servo to go to position 'pos'
      delay(10);                       // waits 15ms for the servo to reach the position
    }
  } else if (servo1.read() > destination) {
    for (int currentPos = servo1.read(); currentPos >= destination; currentPos--) { // gently sweeps from current position to 45 degrees
      servo1.write(currentPos);   // tell servo to go to position 'pos'
      delay(10);                       // waits 15ms for the servo to reach the position
    }
  }
}

//void listThePressure() {
//
//  pressureList[10] = pressureList[9];
//  pressureList[9] = pressureList[8];
//  pressureList[8] = pressureList[7];
//  pressureList[7] = pressureList[6];
//  pressureList[6] = pressureList[5];
//  pressureList[5] = pressureList[4];
//  pressureList[4] = pressureList[3];
//  pressureList[3] = pressureList[2];
//  pressureList[2] = pressureList[1];
//
//  pressureList[10] = pressurePascals;
//
//  //    int totalElements = pressureList.leseringth;
//
//  //    medianPressure = findMedian(double x[]);
//}
//void findMedian(double list[]) {
//
//}
