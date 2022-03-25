class navigationbar {

  void setup() {
    bar_background();
    init_fragments();
    ActionEvent();
    handler();
  }
  
  void handler(){
    if(nav_active_item == "Home"){
      image(home_s, width/2, height-30);
    } else if(nav_active_item == "Settings"){
      image(settings_s, 137.333-50, height-30);
    } else {
        image(info_s, width-137.333+50, height-30);
    }
  }

  void bar_background() {
    fill(65);
    noStroke();
    rect(0, height-60, width, 150);
  }

  void init_fragments() {
    home_fragment();
    settings_fragment();
    info_fragment();
  }

  void home_fragment() {
    imageMode(CENTER);
    home.resize(30, 30);
    home_s.resize(30, 30);
    image(home, width/2, height-30);
  }

  void settings_fragment() {
    imageMode(CENTER);
    settings.resize(30, 30);
    settings_s.resize(30, 30);
    image(settings, 137.333-50, height-30);
    fill(255);
  }

  void info_fragment() {
    imageMode(CENTER);
    info.resize(30, 30);
    info_s.resize(30, 30);
    image(info, width-137.333+50, height-30);
  }

  void ActionEvent() {
    if (mousePressed) {
      // onClick settings fragment
      if (mouseX > 0 && mouseX < 0 + 137.33 && mouseY > height-60 && mouseY < height) {
        //image(settings_s, 137.33-50, height-30);
        nav_active_item = "Settings";
      }
      
      // onClick home fragment
      if (mouseX > 137.33 && mouseX < 137.33 + width/2-(137.33/2) && mouseY > height-60 && mouseY < height){
        nav_active_item = "Home";
      }
      
      // onClick info fragment
      if (mouseX > width/2+(137.33/2) && mouseX < width/2+(137.33/2) + width && mouseY > height-60 && mouseY < height){
        nav_active_item = "Info";
      }
    }
  }
}
