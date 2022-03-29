boolean loading = false;

class fragments {


  void Fhome() {
    home_layout();
    home_actions();


    loading = false;
  }
//font Segoe UI
  void home_layout() {
    for (int i = 0, x = 133; i < datesWhite.length; i++) {
      image(datesWhite[i], x, 500);
      textAlign(CENTER);
      textSize(30);
      textFont(Segoe);
      text("18", x, 500);
      x+=270;
    }
  }

  void home_actions() {
    int x = 133 / 4, y = 380, w = 200, h = 220;
    int addon = 270;
    //244,270
    // date action event listener 
    // first image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      image(datoColBlue, 133, 500);
    }
    x=133 + (addon - (w/2));
    // second image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      image(datoColBlue, 133 + addon, 500);
    }
    x=133 + (addon * 2 - (w/2));
    // third image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      image(datoColBlue, 133 + (addon * 2), 500);
    }
    x=133 + (addon * 3 - (w/2));
    // fourth image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      image(datoColBlue, 133 + (addon * 3), 500);
    }
  }

  void Fsettings() {
    textAlign(CENTER);
    textSize(50);
    fill(255);
    text("Settings Fragment", width/2, height/2);

    loading = false;
  }

  void Finfo() {
    textAlign(CENTER);
    textSize(50);
    fill(255);
    text("Info Fragment", width/2, height/2);

    loading = false;
  }
}
