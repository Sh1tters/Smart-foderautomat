class settings {
  int time;
  int rekaliY = 600;
  boolean active = true;
  
  void view() {
    settings_layout();
    settings_actions();
  }

  void settings_layout() {
    String[] rawdata = loadStrings(filePath);
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");
      // find keywords
      if (raw[0].equals("Auto")) {
        if (raw[1].equals("false")) {
          active = false;
        } else active = true;
      }
    }
    if (active) rekaliY = 600;
    else rekaliY = 1000;
    image(bigHud, width/2, 300);
    image(bigHud, width/2, rekaliY);

    fill(#613CC6);
    textFont(bold, 40);
    text("Automatisk fodring", width/2-125, 300);
    text("Rekalibrer", width/2-200, rekaliY);
    //  automatiskfodring, rekalibrer, switchOn, switchOff, switchButton, bigHud, smallHud;
    if (active) {
      image(switchOn, width/2+250, 300);
      image(switchButton, width/2+290, 300);
    } else {
      image(switchOff, width/2+250, 300);
      image(switchButton, width/2+210, 300);

      image(smallHud, width/2-125, 600);

      fill(#613CC6);
      text("S"+char(230)+"t m"+char(230)+"ngde af mad", width/2-150, 600);
    //  rect(width/2-350, 500, 500, 200);
    }
  }

  void settings_actions() {
    // settings for feed now
    if(!active){
      if(mouseX > width/2-350 && mouseX < width/2-350+500 && mouseY > 500 && mouseY < 500 + 200){
      nav_active_item = "Maengde";
      ms.text = "";
      ms.keyboard = false;
      loading = false;
      delay(500);
      mouseX = 10000;
      }
    }
    
    if (mouseX > width/2+180 && mouseX < width/2+180 + 200 && mouseY > 240 && mouseY < 240 + 150) {
      if (active) {
        active = false;
        String[] rawdata = loadStrings(filePath);
        String[] raw;
        for (int i = 0; i < rawdata.length; i++) {
          raw = split(rawdata[i], ":");

          // find keywords
          if (raw[0].equals("Auto")) {
            if (raw[1].equals("true")) {
              rawdata[i] = raw[0]+":"+"false";
            }
          }
        }
        // save the file
        saveStrings("/data/user/0/processing.test.foderautomat/files/database.txt", rawdata);
      } else {
        active = true;
        String[] rawdata = loadStrings(filePath);
        String[] raw;


        for (int i = 0; i < rawdata.length; i++) {
          raw = split(rawdata[i], ":");

          // find keywords
          if (raw[0].equals("Auto")) {
            if (raw[1].equals("false")) {
              rawdata[i] = raw[0]+":"+"true";
            }
          }
        }
        // save the file
        saveStrings("/data/user/0/processing.test.foderautomat/files/database.txt", rawdata);
      } 
      delay(500);
      mouseX = 10000;
    }

    // recalibrate
    // openKeyboard();
    if (mouseX > width/2-425 && mouseX < width/2-425 + 165*5 && mouseY > rekaliY-100 && mouseY < rekaliY-100 + 200) {
      nav_active_item = "Recalibrate";
      rc.serial = "";
      rc.keyboard = false;
      loading = false;
      delay(500);
      mouseX = 10000;
    }
  }

  void settings_handler() {
  }
}
