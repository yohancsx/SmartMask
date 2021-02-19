
/**
 * Main code for the Smart Mask with the Feather BLE Sense
 * Utilizes the pressure and proximity sensors and outputs the readings to bluetooth
 * Written by Yohan Sequeira - Jan 2021
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

Adafruit_APDS9960 apds9960; // proximity, light, color, gesture
Adafruit_BMP280 bmp280;     // temperautre, barometric pressure
Adafruit_SHT31 sht30;       // humidity

//variables to hold sensor data
uint8_t proximity;
float temperature, pressure;
float humidity;

void setup() {
  //initialize sensors
  apds9960.begin();
  apds9960.enableProximity(true);
  apds9960.enableColor(false);
  bmp280.begin();
  sht30.begin();
}
 
void loop() {
  //read sensor data
  proximity = apds9960.readProximity();
  temperature = bmp280.readTemperature();
  pressure = bmp280.readPressure();
  humidity = sht30.readHumidity();
}

//change the led color for indication purposes??
void changeLEDColor(){
  
}
