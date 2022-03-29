boolean preload = true;
float n, r, t;

navigationbar nav;
fragments frag;
database db;
splash[] splash;
int unit = 3;
ArrayList<splash> splashAni = new ArrayList<splash>();

PImage home, settings, info, home_s, settings_s, info_s, datoColWhite, datoColBlue, Oversigt, background;
String nav_active_item = "Home";
boolean firstrun;
color c1, c2;
int y, x, w, h;

void firstrunpreload() {
}

void preload() {
  // runs on a different thread
  home = loadImage("home.png");
  settings = loadImage("settings.png");
  info = loadImage("info.png");
  home_s = loadImage("home - Copy.png");
  settings_s = loadImage("settings - Copy.png");
  info_s = loadImage("info - Copy.png");
  datoColWhite = loadImage("Rectangle 7.png");
  datoColWhite.resize(244, 270);
  datoColBlue = loadImage("Rectangle 8.png");
  Oversigt = loadImage("Oversigt.png");

  preload = false;
}

void splashscreen() {
}


void setup() {
  // Oneplus 9g phone dms: 412x915
  background = loadImage("Rectangle 14.png");
  background.resize(displayWidth, displayHeight);
  
  size(displayWidth, displayHeight, OPENGL);

  nav = new navigationbar();
  frag = new fragments();
  db = new database();
  splash = new splash[unit];

  n = 80;
  r = 200;


  if (!db.isFileCreated()) {
    db.createFile();
  }

  // start preload thread
  thread("preload");
}


void draw() {
  // background
  image(background, width/2, height/2);
  //makeGradientBackground();

  if (db.firstrun()) {
    // First ever run 
    println("first run!!");


    db.findandchangevalue("FirstRun", "false");
  } else {
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
      } else {
        frag.Finfo();
      }
      nav.setup();
    }

    if (loading) {
      image(background, width/2, height/2);
      loadingAnimation();


      //show something
      nav.setup();
    }
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

void makeGradientBackground() {
  y = 0; 
  x = 0; 
  w = width; 
  h = height;
  c2 = color(#D9F6FA);
  c1 = color(#F8FEFF);

  // left
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}
