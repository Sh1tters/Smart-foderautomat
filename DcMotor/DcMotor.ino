
// Libs
#include <AccelStepper.h>
#include <AFMotor.h>

boolean run = false;
int runtime = 0;
int time;
int cd_timeleft;
boolean cd;
boolean active;

String quan;
// Number of steps per output rotation
// Change this as per your motor's specification (200 default for our motor)
const int stepsPerRevolution = 200;

// connect motor to port #2 (M3 and M4)
AF_Stepper motor(stepsPerRevolution, 2);

void forwardstep() {
  motor.step(10, FORWARD, SINGLE);
}
void backwardstep() {
  motor.step(10, BACKWARD, SINGLE);
}
AccelStepper stepper(forwardstep, backwardstep); // use functions to step

/**
 * @brief 0
 * 1. Send socket message to app
 * 2. Retrieve respond of clock 0time when motor should start
 * 
 */

void setup() {
  Serial.begin(115200);
  Serial.println("debug");
  motor.setSpeed(50);  // 50 rpm
} 

void loop() {
  Serial.println("gay");
      motor.step(1, BACKWARD, SINGLE);
  run = true;
  if(run) {
    motor.step(10, BACKWARD, SINGLE);
    //startMotor(time);
    //run = false;
  }


//  if(Serial.available()>0){
//    String state = Serial.readString();
//
//    if(state.startsWith("runtime:")){
//      time = state.split(":")[1];
//      run = true;
//    }
//  }
//  if(active){
//  if (millis() - time >= 1000)
//      {
//        cd_timeleft--;
//        motor.step(10, BACKWARD, SINGLE);
//        if (cd_timeleft < 0) {
//          run = false;
//        }
//        time = millis();
//      }
//  }
}



void startMotor(int time){
active = true;
cd_timeleft = time;
}

//motor.step(0, BACKWARD, SINGLE);
