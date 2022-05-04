class navigationbar {

  void view() {
    bar_background();
    init_fragments();
    ActionEvent();
    handler();
    AnimationSpawn();
  }

  void AnimationSpawn(){
    for(int i = 0; i < splashAni.size(); i++){
      splash sp = splashAni.get(i);
      sp.update();
    }
  }
  
  void handler(){
    if(nav_active_item == "Home"){
      image(home_s, width/2, height-75);
    } else if(nav_active_item == "Settings" || nav_active_item == "Recalibrate" || nav_active_item == "Maengde"){
      image(settings_s, 137.333, height-75);
    } else {
        image(info_s, width-137.333, height-75);
    }
  }

  void bar_background() {
    fill(125);
    noStroke();
    rect(0, height-150, width, 200);
  }

  void init_fragments() {
    home_fragment();
    settings_fragment();
    info_fragment();
  }

  void home_fragment() {
    imageMode(CENTER);
    home.resize(60, 60);
    home_s.resize(60, 60);
    image(home, width/2, height-75);
  }

  void settings_fragment() {
    imageMode(CENTER);
    settings.resize(60, 60);
    settings_s.resize(60, 60);
    image(settings, 137.333, height-75);
  }

  void info_fragment() {
    imageMode(CENTER);
    info.resize(60, 60);
    info_s.resize(60, 60);
    image(info, width-137.333, height-75);
  }

  void ActionEvent() {
    if (mousePressed && !preload && !loading) {
      // onClick settings fragment
      if (mouseX > 0 && mouseX < 0 + 137.333*2+50 && mouseY > height-150 && mouseY < height-150+height) {
        nav_active_item = "Settings";
        loading = true;
      }
      
      // onClick home fragment
      if (mouseX > 137.333*2+50 && mouseX < 137.333*2+50+137.333*3+50 && mouseY > height-150 && mouseY < height-150+height){
        nav_active_item = "Home";
        loading = true;
      }
      
      // onClick info fragment
      if (mouseX > 137.333*5+100 && mouseX < 137.333*5+100 + width && mouseY > height-150 && mouseY < height-150+height){
        nav_active_item = "Info";
        loading = true;
      }
    }
  }
}
