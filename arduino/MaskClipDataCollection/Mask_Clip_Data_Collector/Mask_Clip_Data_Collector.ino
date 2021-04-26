/**
 * Written to collect data from the smart mask clip
 * written by Yohan Sequeira, Feb 2021
 */

#include <SPI.h>
#include <SD.h>

//the file to open and write to
File myFile;

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
 
//initialize the SD card and initialize the sensors, 
//then wait for some time and start to take the data after turning the light off
void setup(){
  //start the serial
  Serial.begin(112500);

  //initialize the sensors
  initializeAllSensors();

  //take a random rms value and set the random seed
  randomSeed(audioLevel);
  delay(5*1000);

  Serial.println("initialization success! Waiting for user to put on mask");

  //wait for the user (10s)
  delay(10*1000);
  
}

//collect some data, then write it to the SD card, make sure to delay properly for the breathing
void loop(){
  //initialize the sd card file
  //get the random value to create the filename
  int fileNameNum = random(300);

  //try to initialize the sd card, if not, just wait
  if (!SD.begin()) {
    Serial.println("SD initialization failed!");
    while(1);
  }
  Serial.println("SD initialization done.");
  
  //open the file
  myFile = SD.open("mdata.txt", FILE_WRITE);
 
  //extra delay for 5s
  delay(5*1000);
  
  //the float for the timer value
  unsigned long startTime = millis();
  //**************************************************************************************************************//
  //collect data for breathing for 30s
  Serial.println("collecting breathing data for 30s");
  while((millis() - startTime) < 30*1000){
    takeSensorReadings();
    myFile.print(String(pressurePascals));
    myFile.print(",");
    myFile.print(String(proximity));
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(0);
    //tiny delay
    delay(10);
    
  }
  
  Serial.println("pausing");
  delay(5*1000);
  startTime = millis();
  
  //**************************************************************************************************************//
  //collect coughing data for ten seconds
  Serial.println("collecting coughing data for 10s");
  while((millis() - startTime) < 10*1000){
    takeSensorReadings();
    myFile.print(pressurePascals);
    myFile.print(",");
    myFile.print(proximity);
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(1);
    //tiny delay
    delay(10);
  }

  Serial.println("pausing");
  delay(5*1000);
  startTime = millis();
  
  //**************************************************************************************************************//
  //collect talking data for 30 seconds
  Serial.println("collecting talking data for 30s");
  while((millis() - startTime) < 30*1000){
    takeSensorReadings();
    myFile.print(pressurePascals);
    myFile.print(",");
    myFile.print(proximity);
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(2);
    //tiny delay
    delay(10);
  }

  Serial.println("pausing");
  delay(5*1000);
  startTime = millis();
  
  //**************************************************************************************************************//
  //collect coughing data for 10 seconds
  Serial.println("collecting coughing data for 10s");
  while((millis() - startTime) < 10*1000){
    takeSensorReadings();
    myFile.print(pressurePascals);
    myFile.print(",");
    myFile.print(proximity);
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(1);
    //tiny delay
    delay(10);
  }

  Serial.println("pausing");
  delay(5*1000);
  startTime = millis();
  
  //**************************************************************************************************************//
  //collect deep breathing data for 30 seconds
  Serial.println("collecting deep breathing data for 30s");
  while((millis() - startTime) < 30*1000){
    takeSensorReadings();
    myFile.print(pressurePascals);
    myFile.print(",");
    myFile.print(proximity);
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(3);
    //tiny delay
    delay(10);
  }
  
  Serial.println("Please Wait");
  //save the data
  myFile.close();
  delay(30*1000);
  Serial.println("finished, please unplug the device");
  delay(5*1000);
  //now we can turn off
  startTime = millis();
 
  delay(30*1000);
  
}
