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
int serial = 9999;
PrintWriter output;
int timer1, timer2;

void setup() {
  String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
  for (int i = 0; i < rawdata.length; i++) {
    String[] raw = split(rawdata[i], ":");
    if (raw[0].equals("Serial")) {
      serial = parseInt(raw[1]);
    }
  }

  String portName = "COM8"; // default portname. If error occurs, change to "COM9"
  //  myPort = new Serial(this, portName, 115200);
}

void draw() {
  String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
  for (int i = 0; i < rawdata.length; i++) {
    String[] raw = split(rawdata[i], ":");
    if (raw[0].equals("Serial")) {
      serial = parseInt(raw[1]);
    }
  }
  // check for updates to serial

  if (millis() - timer1 >= 2000) {
    try {
      try {
        // Connect to socket now
        socket = new Socket("192.168.1.141", serial);
        if (socket.isConnected()) {
          // Send a message to the client application
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject("request update");


          // Read and display the response message sent by server application
          ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
          String message = (String) ois.readObject();
          println("Respond: "+ message);
          delay(500);
          updateFile(message);
          ois.close();
          oos.close();
        }
      } 
      catch(ClassNotFoundException e) {
        e.printStackTrace();
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    timer1 = millis();
  }


  // check if the time is up to fill up food
  if (millis() - timer2 >= 30000) {
    try {
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
      LocalDateTime now = LocalDateTime.now();

      requestSocketRespondAndMessage(InetAddress.getLocalHost(), serial, "time");
      String[] split_time = dtf.format(now).toString().split(":");

      if (split_time[0] + ":" + split_time[1] == scheduledTimeToEat) {
        // request how long it should spin
        requestSocketRespondAndMessage(InetAddress.getLocalHost(), serial, "quantity");
        // fill up now
        myPort.write("quan:"+quantityOfFood);
        myPort.write("1");
      }
    }
    catch(Exception e) {
    }
    timer2 = millis();
  }
}


// send last time fed to app
//if (myPort.available()>0) {
//  val=myPort.readStringUntil('\n');
//  if (val.equals("%")) {
//    try {
//      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
//      LocalDateTime now = LocalDateTime.now();

//      String time = dtf.format(now);

//      // connect to socket
//      socket = new Socket("192.168.1.141", serial);
//      if (socket.isConnected()) {
//        // Send a message to the client application
//        ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
//        oos.writeObject("last time fed: "+time);
//        oos.close();
//      }
//    }
//    catch(Exception e) {
//      e.printStackTrace();
//    }
//  }
//}



void requestSocketRespondAndMessage(InetAddress host, int port, String keyword) {
  try {
    try {
      // Connect to socket now
      socket = new Socket("192.168.1.141", serial);

      if (socket.isConnected()) {

        // Send a message to the client application
        ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
        oos.writeObject("requesting time to dc motor module");

        // Read and display the response message sent by server application
        ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
        String message = (String) ois.readObject();
        if (keyword.equals("time")) scheduledTimeToEat = message;

        ois.close();
        oos.close();
      }
    } 
    catch(ClassNotFoundException e) {
    }
  }
  catch (IOException e) {
  }
}

void updateFile(String ser) {
  String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
  String[] raw;
  for (int i = 0; i < rawdata.length; i++) {
    raw = split(rawdata[i], ":");

    // find keywords
    if (raw[0].equals("Serial")) {
      println("debug");
      rawdata[i] = raw[0]+":"+ser;
    }
  }
  // save the file
  saveStrings("/data/user/0/processing.test.foderautomat/files/database.txt", rawdata);
}

void mousePressed() {
  //  myPort.write("q:14:23");
  //myPort.write("1");
}

void keyPressed() {
  //myPort.write("0");
}
