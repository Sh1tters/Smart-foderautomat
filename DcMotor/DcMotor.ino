
// Libs
#include <AccelStepper.h>
#include <AFMotor.h>


// Number of steps per output rotation
// Change this as per your motor's specification (200 default for our motor)
const int stepsPerRevolution = 200;

// connect motor to port #2 (M3 and M4)
AF_Stepper motor(stepsPerRevolution, 2);

void forwardstep() {
  motor.onestep(FORWARD, SINGLE);
}
void backwardstep() {
  motor.onestep(BACKWARD, SINGLE);
}
AccelStepper stepper(forwardstep, backwardstep); // use functions to step

/**
 * @brief 
 * 1. Send socket message to app
 * 2. Retrieve respond of clock time when motor should start
 * 
 */

void setup() {
  Serial.begin(115200);
  Serial.println("(!) Stepper has started (!)");

  motor.setSpeed(50);  // 50 rpm
} 

void loop() {
  startMotor(1);


  delay(5UL*60UL*60UL*1000UL); // wait 5 hours to run check again to optimize performance and reduce failure rate
}



void startMotor(int rpm){
  /*
    Because our motor is a rookie, we have configured the rpm to 1 
    and type single as it will result in the smoothest spinning

    Default Settings:
      (!) rpm = 1
      (!) type = SINGLE
      (!) direction = FORWARD
  */

 // statement on how long its gonna run then use the method stopMotor when done.
  motor.step(rpm, FORWARD, SINGLE);
}

void stopMotor(){
  motor.step(0);
}
