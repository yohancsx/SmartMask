/**
 * Written to collect data from the smart mask clip
 * written by Yohan Sequeira, Feb 2021
 */

#include <SPI.h>
#include <SD.h>

//define the LED pins
#define RED 22     
#define BLUE 24     
#define GREEN 23
#define LED_PWR 25
 
//initialize the SD card and initialize the sensors, 
//then wait for some time and start to take the data after turning the light off
void setup(){
  //start the serial
  Serial.begin(112500);

  //initialize the LEDs
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(LED_PWR, OUTPUT);
  digitalWrite(RED, HIGH);
  
  //initialize the sensors
  initializeAllSensors();

  //take a random rms value and set the random seed
  randomSeed(audioLevel);

  //get the random value to create the filename
  int fileNameNum = random(300);

  //try to initialize the sd card, if not, just wait
  if(!initSDCard(String(fileNameNum),myFile)){
    while(1);
  }

  //wait for the user
  delay(10000);

  //set the led to be on and blue in color
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  //change
  
}

//collect some data, then write it to the SD card, make sure to delay properly for the breathing
void loop(){
  
}
