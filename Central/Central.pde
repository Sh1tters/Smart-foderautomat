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
int timer;

void setup() {
  // get serial
  File f = dataFile("database.txt");
  boolean exist = f.isFile();

  if (!exist) {
    output = createWriter("database.txt");
    output.write("Serial:9999");
    output.flush();
    output.close();
  }
  serial = 9999;


  String portName = "COM8"; // default portname. If error occurs, change to "COM9"
  myPort = new Serial(this, portName, 115200);
}

void draw() {
  // check for updates to serial
  String[] rawdata = loadStrings("database.txt");
  for (int i = 0; i < rawdata.length; i++) {
    String[] raw = split(rawdata[i], ":");
    if (raw[0].equals("Serial")) {
      serial = parseInt(raw[1]);
    }
  }

  if (millis() - timer >= 5000) {
    try {
      try {
        println("debug");
        println(serial);
        // Connect to socket now
        socket = new Socket(InetAddress.getLocalHost(), serial);

        if (socket.isConnected()) {

          // Send a message to the client application
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject("request update");

          // Read and display the response message sent by server application
          ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
          String message = (String) ois.readObject();
          println("current ser: "+serial);
          updateFile(message);
          serial = parseInt(message);
          println(serial);
          ois.close();
          oos.close();
        }
      } 
      catch(ClassNotFoundException e) {
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    timer = millis();
  }


  // check if the time is up to fill up food
  try {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
    LocalDateTime now = LocalDateTime.now();

    requestSocketRespondAndMessage(InetAddress.getLocalHost(), serial, "time");
    if (dtf.format(now).equals(scheduledTimeToEat)) {
      // request how long it should spin
      requestSocketRespondAndMessage(InetAddress.getLocalHost(), serial, "quantity");
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
    if (val.equals("%")) {
      try {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
        LocalDateTime now = LocalDateTime.now();

        String time = dtf.format(now);

        // connect to socket
        socket = new Socket(InetAddress.getLocalHost(), serial);
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
      catch(ClassNotFoundException e) {
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    communication = false;
  }
}

void updateSerial() {
  try {
    try {
      // Send a message to the client application
      ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
      oos.writeObject("request update");

      // Read and display the response message sent by server application
      ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
      String message = (String) ois.readObject();
      println("port: "+message);
      updateFile(message);
      ois.close();
      oos.close();
    } 
    catch(ClassNotFoundException e) {
    }
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void updateFile(String ser) {
  String[] rawdata = loadStrings("database.txt");
  String[] raw;
  for (int i = 0; i < rawdata.length; i++) {
    raw = split(rawdata[i], ":");

    // find keywords
    if (raw[0].equals("Serial")) {
      rawdata[i] = raw[0]+":"+ser;
    }
  }
  // save the file
  saveStrings("database.txt", rawdata);
}

void mousePressed() {
  //  myPort.write("q:14:23");
  myPort.write("1");
}

void keyPressed() {
  myPort.write("0");
}
