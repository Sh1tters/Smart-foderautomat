import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.lang.Runnable;
import java.lang.Thread;
import java.net.ServerSocket;
import java.net.Socket;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.SocketAddress;

public static int PORT = 49664;
private ServerSocket server;
boolean haeld_op_knap = false;

boolean preload = true;
float n, r, t;

navigationbar nav;
recalibrate rc;
settings st;
information in;
fragments frag;
database db;
dashboarditems dbi;
communicationDatabase cdb;
splash[] splash;
int unit = 3;
ArrayList<splash> splashAni = new ArrayList<splash>();
PFont Segoe, SegoeBold, bold;
PImage home, settings, info, home_s, settings_s, info_s, datoColWhite, datoColBlue, Oversigt, background, 
  kitty_forbrug, kitty_spist, kitty_vaegt, kitty_time, dashboarditem, vaegt, spist, tid, forbrug, clock, line, 
  automatiskfodring, rekalibrer, switchOn, switchOff, switchButton, bigHud, smallHud, on, off, smallHud_info;
PImage[] datesWhite = new PImage[4];
String nav_active_item = "Home";
boolean firstrun;
color c1, c2;
int y, x, w, h;

void preload() {
  // runs on a different thread
  on = loadImage("polyON.png");
  on.resize(60, 60);
  off = loadImage("polyOFF.png");
  off.resize(60, 60);
  automatiskfodring = loadImage("Automatisk fodring.png");
  automatiskfodring.resize(350, 75);
  rekalibrer = loadImage("Rekalibrer.png");
  rekalibrer.resize(350, 75);
  switchOn = loadImage("Rectangle 32.png");
  switchOn.resize(200, 150);
  switchOff = loadImage("sm.png");
  switchOff.resize(200, 150);
  switchButton = loadImage("Rectangle 33.png");
  switchButton.resize(125, 150);
  bigHud = loadImage("Rectangle 31.png");
  bigHud.resize(179*5, 250);
  smallHud = loadImage("Rectangle 34.png");
  smallHud.resize(179*3, 250);
  smallHud_info = loadImage("Rectangle 34.png");
  smallHud_info.resize(190*4, 800);
  home = loadImage("home.png");
  settings = loadImage("settings.png");
  info = loadImage("info.png");
  home_s = loadImage("home - Copy.png");
  settings_s = loadImage("settings - Copy.png");
  info_s = loadImage("info - Copy.png");

  datesWhite[0] = loadImage("Rectangle 7.png");
  datesWhite[0].resize(244, 270);
  datesWhite[1] = loadImage("Rectangle 7.png");
  datesWhite[1].resize(244, 270);
  datesWhite[2] = loadImage("Rectangle 7.png");
  datesWhite[2].resize(244, 270);
  datesWhite[3] = loadImage("Rectangle 7.png");
  datesWhite[3].resize(244, 270);

  datoColBlue = loadImage("Rectangle 8.png");
  datoColBlue.resize(244, 270);
  Oversigt = loadImage("Oversigt.png");
  Oversigt.resize(285, 80);

  //kitty_forbrug, kitty_spist, kitty_vaegt, kitty_time, dashboarditem, vaegt, spist, tid, forbrug;
  kitty_forbrug = loadImage("forbrug.png");
  kitty_forbrug.resize(100, 100);
  kitty_spist = loadImage("kitty.png");
  kitty_spist.resize(100, 100);
  kitty_vaegt = loadImage("v.png");
  kitty_vaegt.resize(100, 100);
  kitty_time = loadImage("hourglass.png");
  kitty_time.resize(100, 100);
  dashboarditem = loadImage("Rectangle 25.png");
  dashboarditem.resize(179*3, 215*3);

  clock = loadImage("clock.png");
  clock.resize(75, 75);
  line = loadImage("Line 2.png");
  line.resize(350, 5);

  Segoe = createFont("Segoe UI", 32);
  SegoeBold = createFont("Segoe UI Bold", 70);
  bold = createFont("Arial Bold", 40);



  preload = false;
}

void splashscreen() {
}


void setup() {
  // Oneplus 9g phone dms: 412x915
  background = loadImage("Rectangle 14.png");
  background.resize(displayWidth, displayHeight);

  size(displayWidth, displayHeight, OPENGL);

  // fix orientation of the phone to portrait and avoid auto-rotate(which restarts the app):
  orientation(PORTRAIT);


  nav = new navigationbar();
  frag = new fragments();
  db = new database();
  cdb = new communicationDatabase();
  dbi = new dashboarditems();
  in = new information();
  rc = new recalibrate();
  st = new settings();
  splash = new splash[unit];

  n = 80;
  r = 200;

  if (!cdb.isFileCreated()) {
    cdb.createFile();
  }
  // use database.txt when running first time(when you uninstalled and installed again)
  // use /data/user/0/processing.test.foderautomat/files/database.txt when running any other time
// ("/data/user/0/processing.test.foderautomat/files/database.txt");
  String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
  for (int i = 0; i < rawdata.length; i++) {
    String[] raw = split(rawdata[i], ":");
    if (raw[0].equals("Serial")) {
      PORT = parseInt(raw[1]);
    }
  }

  // start preload thread
  thread("preload");


  // start coms
  thread("handleConnection");
}


void draw() {
  // Update serial
  String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
  for (int i = 0; i < rawdata.length; i++) {
    String[] raw = split(rawdata[i], ":");
    if (raw[0].equals("Serial")) {
      PORT = parseInt(raw[1]);
    }
  }

  // background
  image(background, width/2, height/2);
  //makeGradientBackground();
  if (preload) {
    // preload
    loadingAnimation();

    println("loading...");
  } else {
    // file created? (may have been deleted)
    if (!db.isFileCreated()) {
      db.createFile();
    }
    if (nav_active_item == "Home") {
      frag.Fhome();
    } else if (nav_active_item == "Settings") {
      frag.Fsettings();
    } else if (nav_active_item == "Recalibrate") {
      rc.start();
    } else {
      frag.Finfo();
    }
    nav.view();
  }

  if (loading) {
    image(background, width/2, height/2);
    loadingAnimation();


    //show something
    nav.view();
  }
}

void mousePressed() {
  splashAni.add(new splash());
}

void loadingAnimation() {
  smooth();
  noStroke();


  //https://openprocessing.org/sketch/579622
  /*
        Loading animation from open processing - changed millis into frameCount since it was too fast, also fixed the negative green color.
   */
  t = -radians(frameCount);
  for (int i = 0; i < n; i++) {
    float norm = norm(i, 0, n-1);
    fill(255, norm*128, 0);
    float x = (width/2)+sin((sin(t+(norm*PI))/1)+t)*r;
    float y = (height/2)+cos((sin(t+(norm*PI))/1)+t)*r;
    float d = (sin((i/n)*PI))*16;
    ellipse(x, y, d, d);
  }
  textSize(60);
  textAlign(CENTER);
  text("Loading...", width/2, height/2);
}




// SOCKET COMMUNICATIONS DOWN BELOW
void handleConnection() {
  try {
    // call constructor
    int backlog = 5;
    //https://stackoverflow.com/questions/37420237/why-socket-does-not-connect-with-ip-instead-of-localhost
    //https://stackoverflow.com/questions/8965155/cannot-assign-requested-address-using-serversocket-socketbind
    //0.0.0.0:49664
    // home connection: 192.168.1.141:PORT
    // school connection: 100.72.99.140:PORT
    println("Starting up server...");
    //PORT
    server = new ServerSocket(PORT, backlog, InetAddress.getByName("192.168.1.141"));
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  //println("(!) Server socket is bounded: " + server.isBound() + " (!)");
  //println("(!) Local Socket Address: "+ server.getLocalSocketAddress() +"(!)");
  System.out.println("Waiting for client message...");
  // The server do a loop here to accept all connection initiated by the
  // client application.
  while (true) {
    try {
      Socket socket = server.accept();
      println();
      println("(!)=================LOG================(!)");
      println("(!) New connection established... (!)");
      new ConnectionHandler(socket);
    }
    catch (IOException e) {
    }
  }
}


class ConnectionHandler implements Runnable {
  private final Socket socket;

  ConnectionHandler(Socket socket) {
    this.socket = socket;

    Thread t = new Thread(this);
    t.start();
  }

  public void run() {
    try {
      try {
        // Read a message sent by client application
        ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
        String message = (String) ois.readObject();

        // Updater
        if (message.equals("request update")) {
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          if (haeld_op_knap) {
            oos.writeObject(PORT+":run");
            haeld_op_knap = false;
          } else oos.writeObject(PORT+": ");
          db.findandchangevalue("Serial", PORT+"");
          server.close();
          delay(500);
          thread("handleConnection");
        }


        //DC MOTOR
        if (message.equals("requesting time to dc motor module")) {
          println("(!) Received a request from DC Motor! Sending back information.. (!)");

          // retrieve information from dc motor txt document
          // Send a response information to the client application
          ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
          oos.writeObject(cdb.requestDcMotorSumOfAllTime() + "");
          oos.close();
          ois.close();
          println("(!) Sent back to client: " + cdb.requestDcMotorSumOfAllTime() + " (!)");
        }

        //DC MOTOR
        if (message.startsWith("last_time_fed:")) {
          println("(!) last time fed information received. Appending to data sheet now (!)");
          String[] data = message.split(":");
          cdb.LastTimeFedAppendData(data[1]);
          ois.close();
        }

        //WEIGHT SENSOR
        if (message.startsWith("InfoFromWeightSensor:")) {
          // append information to weight document
          println("(!) information from weight sensor received. Appending to data sheet now (!)");
          String[] data = message.split(":");
          cdb.WeightSensorAppendData(data[1]);
          ois.close();
        }



        println();
        println("(!)=================LOG================(!)");
      }
      catch (ClassNotFoundException ce) {
      }
    }
    catch (IOException e) {
    }
  }
}
