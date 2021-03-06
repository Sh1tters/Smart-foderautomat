/**

   HX711 library for Arduino - example file
   https://github.com/bogde/HX711

   MIT License
   (c) 2018 Bogdan Necula

**/
#include "HX711.h"


// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 3;
const int LOADCELL_SCK_PIN = 4;


boolean cd = false;
int timer;
int cd_timeleft;

float maxx = 0.1;


HX711 scale;

void setup() {
Serial.begin(115200);
  // Initialize library with data output pin, clock input pin and gain factor.
  // Channel selection is made by passing the appropriate gain:
  // - With a gain factor of 64 or 128, channel A is selected
  // - With a gain factor of 32, channel B is selected
  // By omitting the gain factor parameter, the library
  // default "128" (Channel A) is used here.
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  
  Serial.println(scale.read());      // print a raw reading from the ADC

 
  Serial.println(scale.read_average(20));   // print the average of 20 readings from the ADC


  Serial.println(scale.get_value(5));   // print the average of 5 readings from the ADC minus the tare weight (not set yet)


  Serial.println(scale.get_units(5), 1);  // print the average of 5 readings from the ADC minus tare weight (not set) divided
  // by the SCALE parameter (not set yet)

  scale.set_scale(2280.f);                      // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare();               // reset the scale to 0

 
  Serial.println(scale.read());                 // print a raw reading from the ADC

  
  Serial.println(scale.read_average(20));       // print the average of 20 readings from the ADC


  Serial.println(scale.get_value(5));   // print the average of 5 readings from the ADC minus the tare weight, set with tare()


  Serial.println(scale.get_units(5), 1);        // print the average of 5 readings from the ADC minus tare weight, divided
  // by the SCALE parameter set with set_scale


}

void loop() {
  float weight = (scale.get_units());
  if (!cd) {
    //   check for which the weight is increasing or decreasing
    if (weight > 1.) {
      if (weight > maxx) {
        maxx = weight;
      }
      if (maxx > weight) {
        Serial.println((String) "test:" + maxx);
        // send max weight to central
        // set cd
        cd = true;
        cd_timeleft = 10; // 5 mins cooldown
      }
    }
  }
  runCD();
}

void runCD() {
  if (cd) {
    if (millis() - timer >= 1000)
    {
      cd_timeleft--;
      if (cd_timeleft < 0) {
        cd = false;
        maxx = 0.;
      }
      timer = millis();
    }
  }
}
