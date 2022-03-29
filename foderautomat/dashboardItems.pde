class dashboarditems {

  void setup() {
    layout();
  }


  void layout() {
    for (int i = 0, x = 290; i < 2; i++) {
      image(dashboarditem, x, 1080);
      x+=510;
    }
    for(int i = 0, x = 290; i < 2; i++){
      image(dashboarditem, x, 1710);
      x+=510;
    }
    
    //image(kitty_forbrug, 560, 1780);
    textAlign(CENTER);
    textFont(SegoeBold, 70);
    text("Spist", width/5-20, 900);
    text("Vaegt", width-365, 900);
    text("Tid", width/5-55, 1535);
    text("Forbrug", width-325, 1535);
    
    image(kitty_forbrug, width-125, 1520);
    image(kitty_time, width/5+200, 1515);
    image(kitty_vaegt, width-125, 890);
    image(kitty_spist, width/5+200, 890);
  }

  void dashboard_handler() {
  }

  void dashboard_actions() {
  }
}
