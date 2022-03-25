boolean preload = true;
navigationbar nav;
PImage home, settings, info, home_s, settings_s, info_s;
String nav_active_item = "Home";

void preload() {
  // runs on a different thread. Handles all data
  nav = new navigationbar();
  home = loadImage("home.png");
  settings = loadImage("settings.png");
  info = loadImage("info.png");
  home_s = loadImage("home - Copy.png");
  settings_s = loadImage("settings - Copy.png");
  info_s = loadImage("info - Copy.png");


  preload = false;
}

void splashscreen() {
}


void setup() {
  // Phone dimensionels: 412x915
  size(412, 915, OPENGL);
  background(35);

  // start preload thread
  thread("preload");
}


void draw() {
  if (preload) {
    println("loading...");
  } else {
   // println("done");
    

    nav.setup();
  }
}
