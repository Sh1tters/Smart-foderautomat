import processing.serial.*;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.net.InetAddress;
import java.net.Socket;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

Socket socket;
// check boolean to run method once only
boolean communication = false;

// string variable for real life time to run motor
String scheduledTimeToEat = "";

// string variable for quantity of food
String quantityOfFood = "";

Serial myPort;
String val;

void setup() {
  String portName = "COM8";
  myPort = new Serial(this, portName, 115200);
}

void draw() {
  
  // check if the time is up to fill up food
  try {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
    LocalDateTime now = LocalDateTime.now();

    requestSocketRespondAndMessage(InetAddress.getLocalHost(), 7777, "time");
    if (dtf.format(now).equals(scheduledTimeToEat)) {
      // request how long it should spin
      requestSocketRespondAndMessage(InetAddress.getLocalHost(), 7777, "quantity");
      // fill up now
      myPort.write("quan:"+quantityOfFood);
      myPort.write("1");
    }
  }
  catch(Exception e) {  
    
    
    e.printStackTrace();
  }

  // send last time fed to app
  if (myPort.available()>0) {
    val=myPort.readStringUntil('\n');
    println(val);
    if (val.equals("%")) {
      try {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
        LocalDateTime now = LocalDateTime.now();

        String time = dtf.format(now);

        // connect to socket
        socket = new Socket(InetAddress.getLocalHost(), 7777);
        if (socket.isConnected()) {
          // Send a message to the client application
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject("last time fed: "+time);
          oos.close();
        }
      }
      catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
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
        if (keyword.equals("time")) scheduledTimeToEat = message;
        else if (keyword.equals("quantity")) quantityOfFood = message;

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

void mousePressed() {
//  myPort.write("q:14:23");
myPort.write("1");
}

void keyPressed() {
  myPort.write("0");
}
