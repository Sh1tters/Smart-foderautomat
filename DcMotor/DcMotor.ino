
// Libs
#include <AccelStepper.h>
#include <AFMotor.h>

boolean run = false;

String quan;
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
  if(run) startMotor(1);
  if(!run) motor.step(0, FORWARD, SINGLE);
  if(Serial.available()>0){
    String state = Serial.read();

    if(state == "1"){
      run = true;
    }

    if(state == "0"){
      run = false;
    }

    // new quantity received?
    if(state.startsWith("quan:")){
      String data = state.split(":");
      //apply new data to quan var
        quan = data[1];
    }
  }
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
