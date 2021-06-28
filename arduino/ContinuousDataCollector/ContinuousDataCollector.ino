/*
 * Written to collect data from the smart mask clip
 * written by Yohan Sequeira, May 2021
 */

#include <SPI.h>
#include <SD.h>

#define RED 22     
#define BLUE 24     
#define GREEN 23
#define LED_PWR 25

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

   // intitialize the digital Pin as an output
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(LED_PWR, OUTPUT);

  digitalWrite(RED, HIGH);
  digitalWrite(GREEN, HIGH);
  digitalWrite(BLUE, HIGH);

  //initialize the sensors
  initializeAllSensors();

  //take a random rms value and set the random seed
  randomSeed(audioLevel);

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
  myFile = SD.open("mdata.csv", FILE_WRITE);
  delay(5*1000);

  Serial.println("initialization success! Waiting for user to put on mask");
  digitalWrite(RED, LOW);
  digitalWrite(GREEN, HIGH);
  digitalWrite(BLUE, HIGH);
  
  //wait for the user (10s)
  delay(10*1000);
  
  Serial.println("Start collecting Data Now");

  //data delimiter
  myFile.println("-1,-1,-1,-1");
  myFile.close();
}

//collect some data, then write it to the SD card, make sure to delay properly for the breathing
void loop(){
  
  //open the file
  myFile = SD.open("mdata.csv", FILE_WRITE);
  
  //the float for the timer value
  unsigned long startTime = millis();

  //collect data for breathing for 30s
  Serial.println("collecting breathing data for 30s");
  while((millis() - startTime) < 30*1000){
    takeSensorReadings();
    myFile.print(pressurePascals);
    myFile.print(",");
    myFile.print(proximity);
    myFile.print(",");
    myFile.print(audioLevel);
    myFile.print(",");
    myFile.println(0);
    //tiny delay
    delay(10);
  }

  //close the file to save the data
  myFile.close();
}
