
// Libs
#include <AccelStepper.h>
#include <AFMotor.h>

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.net.InetAddress;
import java.net.Socket;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

// Number of steps per output rotation
// Change this as per your motor's specification (200 default for our motor)
const int stepsPerRevolution = 200;

// connect motor to port #2 (M3 and M4)
AF_Stepper motor(stepsPerRevolution, 2);

// check boolean to run method once only
boolean communication = false;

// string variable for real life time to run motor
String scheduledTimeToEat = "";

// string variable for quantity of food
String quantityOfFood = "";

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

  // request clock time from app in setup also 
  requestSocketRespondAndMessage(InetAddress.getLocalHost(), 7777, time);
} 

void loop() {
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
  LocalDateTime now = LocalDateTime.now();
 
  requestSocketRespondAndMessage(InetAddress.getLocalHost(), 7777, time);
  if(dtf.format(now).equals(scheduledTimeToEat)){
    // time to fill up food
    startMotor(1);
  }


  delay(5UL*60UL*60UL*1000UL); // wait 5 hours to run check again to optimize performance and reduce failure rate
}

void requestSocketRespondAndMessage(InetAddress host, int port, String keyword) {
   if (communication) {
    try {
      // Connect to socket now
      socket = new Socket(host.getHostName(), port);

      if (socket.isConnected()) {

        // Send a message to the client application
        ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
        oos.writeObject("requesting " + keyword + " from dc_motor#1");

        // Read and display the response message sent by server application
        ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
        String message = (String) ois.readObject();
        if(keyword.equals("time")) scheduledTimeToEat = message;
        else if(keyword.equals("quantity")) quantityOfFood = message;

        ois.close();
        oos.close();
      }
    }
    catch (IOException | ClassNotFoundException e) {
      e.printStackTrace();
    }
    communication = false;
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

void stopMotor(){
  motor.step(0);
}
