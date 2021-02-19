//the file to open and write to
File myFile;

//initializes the SD card, will return false if there is a failure
//opens the card for a write operation
bool initSDCard(String fileName, File myFile){
  
  //start SD card, just stop if SD card does not initialize
  Serial.print("Initializing SD card...");
  if (!SD.begin(10)) {
    Serial.println("SD initialization failed!");
    return false;
  }
  Serial.println("initialization done.");
  
  //open the file
  myFile = SD.open(fileName + ".csv", FILE_WRITE);
  return true;
}


//close the SD card
bool closeSdCard(File myFile){
  myFile.close();
  Serial.println("done.");
}
