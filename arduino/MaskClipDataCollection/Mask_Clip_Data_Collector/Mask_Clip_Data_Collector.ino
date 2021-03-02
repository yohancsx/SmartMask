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

  //set to red
  digitalWrite(RED, HIGH);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, LOW);
  
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

  //wait for the user (10s)
  delay(10*1000);

  //set the led to be on and green in color
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);

  //extra delay for 5s
  delay(5*1000);
  
}

//collect some data, then write it to the SD card, make sure to delay properly for the breathing
void loop(){
  //the float for the timer value
  unsigned long startTime = millis();
  //**************************************************************************************************************//
  //collect data for breathing for 30s
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
  
  //reset the timer, and wait, while changing the colors of the LED to blue for wait
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  digitalWrite(GREEN, LOW);
  delay(5*1000);
  startTime = millis();
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);
  
  //**************************************************************************************************************//
  //collect coughing data for ten seconds
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

  //reset the timer, and wait, while changing the colors of the LED to blue for wait
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  digitalWrite(GREEN, LOW);
  delay(5*1000);
  startTime = millis();
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);
  
  //**************************************************************************************************************//
  //collect talking data for 30 seconds
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

  //reset the timer, and wait, while changing the colors of the LED to blue for wait
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  digitalWrite(GREEN, LOW);
  delay(5*1000);
  startTime = millis();
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);
  
  //**************************************************************************************************************//
  //collect coughing data for 10 seconds
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

  //reset the timer, and wait, while changing the colors of the LED to blue for wait
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  digitalWrite(GREEN, LOW);
  delay(5*1000);
  startTime = millis();
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);
  
  //**************************************************************************************************************//
  //collect deep breathing data for 30 seconds
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

  
  //reset the timer, and wait, while changing the colors of the LED to red for done
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, HIGH);
  digitalWrite(GREEN, LOW);
  //save the data
  closeSdCard(myFile);
  delay(5*1000);
  //now we can turn off
  startTime = millis();
  digitalWrite(RED, HIGH);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, LOW);
  delay(30*1000);
  
}
