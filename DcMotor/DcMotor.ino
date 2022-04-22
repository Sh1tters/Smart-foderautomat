

#include <AccelStepper.h>
#include <AFMotor.h>

// Number of steps per output rotation
// Change this as per your motor's specification
const int stepsPerRevolution = 200;

// connect motor to port #2 (M3 and M4)
AF_Stepper motor(stepsPerRevolution, 2);
// you can change these to DOUBLE or INTERLEAVE or MICROSTEP!
void forwardstep() {
  motor.onestep(FORWARD, SINGLE);
}
void backwardstep() {
  motor.onestep(BACKWARD, SINGLE);
}
AccelStepper stepper(forwardstep, backwardstep); // use functions to step
void setup() {
  Serial.begin(115200);
  Serial.println("Stepper test!");

  motor.setSpeed(50);  // 10 rpm
} 

void loop() {
  Serial.println("Single coil steps");
  motor.step(1, FORWARD, SINGLE);
}

void mousePressed(){
  motor.setSpeed(0);
}
