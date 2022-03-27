boolean preload = true;
float n, r, t;

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


  preload = false;
}

void splashscreen() {
}


void setup() {
  // Oneplus 9g phone dms: 412x915
  size(displayWidth, displayHeight, OPENGL);

  n = 80;
  r = 200;

  // start preload thread
  thread("preload");
}


void draw() {
  background(35);
  if (preload) {
    loadingAnimation();

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

  if (loading) {
    background(35);
    loadingAnimation();
    nav.setup();
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
