class MachineSettings {
  String text;
  boolean keyboard = false;
  int time;
  int cd_timeleft;

  void startMaengde() {
    virtualKeyboard();
    actions();
    image(bigHud, width/2, 400);
    fill(#613CC6);
    textFont(bold, 40);
    if (!keyboard) {
      String[] rawdata = loadStrings(filePath);
      for (int i = 0; i < rawdata.length; i++) {
        String[] raw = split(rawdata[i], ":");
        if (raw[0].equals("Settings")) {
          text("Indtast m"+char(230)+"ngde i gram (f. eks: "+raw[1]+")", width/2, 400);
        }
      }
    } else {
      text(text, width/2, 400);
    }

    if (text.length() > 0 && !text.contains("g")) {
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
          db.findandchangevalue("Settings", text);
          delay(750);
          maengde = parseInt(text);
          nav_active_item = "Home";
        }
        time = millis();
      }
    }
  }

  void actions() {
    if (mouseX > width/2-425 && mouseX < width/2-425 + 165*5 && mouseY > 300 && mouseY < 300 + 200) {
      keyboard = true;
      openKeyboard();
      mouseX = 30000; // reset mouse
    }
    if (mouseX > width/2-225 && mouseX < width/2-225 + 165*3 && mouseY > 700 && mouseY < 700 + 200) {
      loading = true;
      cd_timeleft = 2;
      closeKeyboard();
      mouseX = 30000; //reset mouse
    }
  }



  void virtualKeyboard() {
    if (int(key) <= 59 && int(key) >= 48 && key != ':' && key != ';' && text.length() < 4) { // check if a number was pressed only (1 = 48...0=59)
      text = text + key;
      key = 0; // reset key
    }

    if (int(key) == 65535 && text.length() > 0) { // check if delete button has been pressed
      text = text.substring(0, text.length() - 1); // remove last digit in serial
      key = 0; // reset key
    }
  }
}
