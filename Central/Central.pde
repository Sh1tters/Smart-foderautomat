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

boolean cd = false;

Serial myPort;
Serial myPort2;
String val;
String weight;
int serial = 9999;
PrintWriter output;
int maengde = 0;
int timer1, timer2, timer3, cd_timeleft;

void setup() {
  String portName = "COM8"; // default portname. If error occurs, change to "COM9"
  String portName2 = "COM9";
  //  myPort = new Serial(this, portName, 115200);
  myPort2 = new Serial(this, "COM8", 115200);
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
  if (millis() - timer1 >= 5000) {
    try {
      try {
        // Connect to socket now
        socket = new Socket(InetAddress.getByName("100.72.99.140"), serial);
        if (socket.isConnected()) {
          // Send a message to the client application
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject("request update");


          // Read and display the response message sent by server application
          ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
          String message = (String) ois.readObject();
          println("Respond: "+ message);
          String[] msg = message.split(":");
          delay(500);
          updateFile(msg[0]);
          if (msg[1].equals("run")) {
            String amount = msg[2];
            maengde = parseInt(msg[2]);
            // myPort.write("runtime:"+calculateRunTime(0, amount));
          }
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
  if (millis() - timer2 >= 20000) {
    if (!cd && 1==2) {
      try {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss");
        LocalDateTime now = LocalDateTime.now();

        requestSumOfTimeToRunMotor();
        String[] split_time = dtf.format(now).toString().split(":");
        String current_time = split_time[0] + ":" + split_time[1];

        if (current_time.equals(scheduledTimeToEat)) {
          // fill up now
          println("now time to fill up");
          // myPort.write("runtime:"+calculateRunTime(0, maengde);
          cd  = true;
          cd_timeleft = 60; // set cooldown to 1 minute, so that this if statement doesnt work twice (fills up twice)
        }
      }
      catch(Exception e) {
      }
      timer2 = millis();
    }
  }
  arduino();
  runCD();
}

void arduino() {
  if (myPort2.available()>0) {
    weight = myPort2.readStringUntil('\n');
    println(weight);
    if (weight != "" || weight != null || weight != " ") {
      if (weight.startsWith("test:")) {
        try {
          DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd:MM:yyyy");
          LocalDateTime now = LocalDateTime.now();

          String time = dtf.format(now);
          DateTimeFormatter dtf1 = DateTimeFormatter.ofPattern("HH:mm");
          LocalDateTime now1 = LocalDateTime.now();

          String time1 = dtf1.format(now1);
          // connect to socket
          socket = new Socket("100.72.99.140", serial);
          if (socket.isConnected()) {
            String data = weight.replace("\n", "").split(":")[1]; // get the weight from string
            // Send a message to the client application
            ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject("weight/"+data);
            oos.close();
          }
        } 
        catch(Exception e) {
          e.printStackTrace();
        }
      }

      //if (weight.split(":")[0] == "test") {
      //  try {
      //    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd:MM:yyyy");
      //    LocalDateTime now = LocalDateTime.now();

      //    String time = dtf.format(now);
      //    DateTimeFormatter dtf1 = DateTimeFormatter.ofPattern("HH:mm");
      //    LocalDateTime now1 = LocalDateTime.now();

      //    String time1 = dtf.format(now);
      //    // connect to socket
      //    socket = new Socket("100.72.99.140", serial);
      //    if (socket.isConnected()) {
      //      String data = weight.split(":")[1]; // get the weight from string
      //      // Send a message to the client application
      //      ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
      //      oos.writeObject("weight:"+data+":"+time+":"+time1);
      //      oos.close();
      //    }
      //  } 
      //  catch(Exception e) {
      //    e.printStackTrace();
      //  }
      //}
    }
  }
}

/**
 We have calculated that every 0.32 seconds it fills up 1 gram of food
 We just take that value and times it by the amount we want to and then we get the total time
 for the motor to run on
 */

int calculateRunTime(float how_long_it_takes_per_g, int amount_of_food) {
  return parseInt(how_long_it_takes_per_g * amount_of_food);
}





// send last time fed to app
//if (myPort.available()>0) {
//  val=myPort.readStringUntil('\n');
//  if (val.equals("%")) {
//    try {
//      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd:MM:yyyy");
//      LocalDateTime now = LocalDateTime.now();

//      String time = dtf.format(now);

//      // connect to socket
//      socket = new Socket("100.72.99.140", serial);
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





void requestSumOfTimeToRunMotor() {
  try {
    try {
      // Connect to socket now
      socket = new Socket("100.72.99.140", serial);

      if (socket.isConnected()) {

        // Send a message to the client application
        ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
        oos.writeObject("requesting time to dc motor module");

        // Read and display the response message sent by server application
        ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
        String message = (String) ois.readObject();
        scheduledTimeToEat = message;

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

void runCD() {
  if (cd) {
    if (millis() - timer3 >= 1000)
    {
      println("cd: " + cd_timeleft);
      cd_timeleft--;
      if (cd_timeleft < 0) {
        cd = false;
      }
      timer3 = millis();
    }
  }
}
