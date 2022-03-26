boolean preload = true;
int n, r;
float t;

navigationbar nav;
fragments frag;
splash[] splash;
int unit = 3;
ArrayList<splash> splashAni = new ArrayList<splash>();

PImage home, settings, info, home_s, settings_s, info_s;
String nav_active_item = "Home";

void preload() {
  // runs on a different thread
  nav = new navigationbar();
  frag = new fragments();
  splash = new splash[unit];
  home = loadImage("home.png");
  settings = loadImage("settings.png");
  info = loadImage("info.png");
  home_s = loadImage("home - Copy.png");
  settings_s = loadImage("settings - Copy.png");
  info_s = loadImage("info - Copy.png");


  // preload = false;
}

void splashscreen() {
}


void setup() {
  // Oneplus 9g phone dms: 412x915
  size(displayWidth, displayHeight, OPENGL);

  n = 20;
  r = 40;

  // start preload thread
  thread("preload");
}


void draw() {
  background(35);
  if (preload) {
    // display loading icon
     smooth();
    noStroke();

    t = -(millis()/500);
    
    for (int i = 0; i < n; i++) {
        fill(255, 255-(i/n)*128, 0);
        
        float x = (width/2)+sin((sin(t+((i/n)*PI))/2)+t)*r;
        float y = (height/2)+cos((sin(t+((i/n)*PI))/2)+t)*r;
        float d = (sin((i/n)*PI))*4;
        ellipse(x, y, d, d);
    }
    
    println("loading...");
  } else {
    if (nav_active_item == "Home") {
      frag.Fhome();
    } else if (nav_active_item == "Settings") {
      frag.Fsettings();
    } else {
      frag.Finfo();
    }
    nav.setup();
  }
}

void mousePressed() {
  splashAni.add(new splash());
}
