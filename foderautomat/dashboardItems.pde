class dashboarditems {

  color c;
  void setup() {
    layout();
    dashboard_spist();
    dashboard_vaegt();
  }


  void layout() {
    for (int i = 0, x = 290; i < 2; i++) {
      image(dashboarditem, x, 1080);
      x+=510;
    }
    for (int i = 0, x = 290; i < 2; i++) {
      image(dashboarditem, x, 1710);
      x+=510;
    }

    //image(kitty_forbrug, 560, 1780);
    textAlign(CENTER);
    textFont(SegoeBold, 70);
    text("Spist", width/5-20, 900);
    text("V"+char(230)+"gt", width-365, 900); // char(230) = 'æ'
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

  void dashboard_spist() {
    int filled = 100; // controls how much is filled in the diagram
    noStroke();
    fill(#22E763);
    rect(width/5-100, 1000, filled, 85, 50);

    noFill();
    stroke(#707070);
    strokeWeight(8);
    rect(width/5-100, 1000, 350, 85, 50);

    fill(0);
    textAlign(CENTER);
    textFont(SegoeBold, 50);
    text("25%", width/5+90, 1060);

    fill(0);
    textAlign(CENTER);
    textFont(SegoeBold, 65 );
    text("50/250 g", width/5+90, 1200);
  }

  void dashboard_vaegt() {
    float weight = 3;
    if (weight < 4) c = #00FF3C;
    else if (weight > 4 && weight < 6) c = #F6FF00;
    else c = #FF0008;
    fill(c);
    stroke(0);
    ellipse(width - 285, 1100, 350, 200);
    fill(0);
    textFont(SegoeBold, 50);
    textAlign(CENTER);
    text(weight + " kg", width - 290, 1120);
    textFont(SegoeBold, 40);
    text(weight + " kg", width - 290, 1250);
    fill(c);
    noStroke();
    ellipseMode(CENTER);
    ellipse(width-200, 1235, 35, 35);

  }
}
