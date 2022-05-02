class recalibrate {
  boolean keyboard = false;
  String serial = "";
  int cd_timeleft = 4;
  int time;

  void start() { 
    virtualKeyboard();
    recalibrate_actions();
    image(bigHud, width/2, 400);
    fill(#613CC6);
    textFont(bold, 40);
    if (!keyboard) {
      text("Indtast nyt serienummer", width/2, 400);
    } else {
      text(serial, width/2, 400);
    }

    if (serial.length() > 3) {
      // show clickable buttons 
      fill(#613CC6);
      rectMode(CENTER);
      rect(width/2, 800, 165*3, 200, 50);
      rectMode(CORNER);
      fill(#FFFFFF);
    } else {
      // show unclickable buttons 
      fill(#B7A0F3);
      rectMode(CENTER);
      rect(width/2, 800, 165*3, 200, 50);
      rectMode(CORNER);
      fill(#B1B1B1);
    }
    textFont(bold, 40);
    text("F"+char(230)+"rdig", width/2, 810);


    if (loading) {
      if (millis() - time >= 1000)
      {
        cd_timeleft--;
        if (cd_timeleft < 0) {
          loading = false;
          db.findandchangevalue("Serial", serial);
          PORT = parseInt(serial);
          delay(750);
          nav_active_item = "Home";
        }
        time = millis();
      }
    }
  }

  void virtualKeyboard() {
    if (int(key) <= 59 && int(key) >= 48 && key != ':' && key != ';' && serial.length() < 4) { // check if a number was pressed only (1 = 48...0=59)
      serial = serial + key;
      key = 0; // reset key
    }

    if (int(key) == 65535 && serial.length() > 0) { // check if delete button has been pressed
      serial = serial.substring(0, serial.length() - 1); // remove last digit in serial
      key = 0; // reset key
    }
  }

  void recalibrate_actions() {
    if (mouseX > width/2-425 && mouseX < width/2-425 + 165*5 && mouseY > 300 && mouseY < 300 + 200) {
      keyboard = true;
      openKeyboard();
      mouseX = 30000; // reset mouse
    }
    if (mouseX > width/2-225 && mouseX < width/2-225 + 165*3 && mouseY > 700 && mouseY < 700 + 200) {
      loading = true;
      closeKeyboard();
      mouseX = 30000; //reset mouse
    }
  }
}
