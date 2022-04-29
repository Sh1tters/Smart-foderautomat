class settings {
  int time;
  int rekaliX = 600;
  boolean active = true;

  void view() {
    settings_layout();
    settings_actions();
  }

  void settings_layout() {
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
    println(rawdata.length);
    String[] raw;
    println(rawdata);
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");


      // find keywords
      if (raw[0].equals("Auto")) {
        if (raw[1].equals("false")) {
          active = false;
        } else active = true;
      }
    }
    if (active) rekaliX = 600;
    else rekaliX = 1200;
    image(bigHud, width/2, 300);
    image(bigHud, width/2, rekaliX);

    fill(#613CC6);
    textFont(bold, 40);
    text("Automatisk fodring", width/2-125, 300);
    text("Rekalibrer", width/2-200, rekaliX);
    //  automatiskfodring, rekalibrer, switchOn, switchOff, switchButton, bigHud, smallHud;
    if (active) {
      image(switchOn, width/2+250, 300);
      image(switchButton, width/2+290, 300);
    } else {
      image(switchOff, width/2+250, 300);
      image(switchButton, width/2+210, 300);
    }
  }

  void settings_actions() {
    if (mouseX > width/2+180 && mouseX < width/2+180 + 200 && mouseY > 240 && mouseY < 240 + 150) {
      println("debug");

      if (active) {
        active = false;
        String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
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
        delay(1000);
      } else {
        active = true;
        String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
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
        delay(1000);

        String[] test = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
        println("1.");
        println(test);
        String[] lol = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
        println("2. ");
        println(lol);
      } 
      mouseX = 10000;
    }
  }

  void settings_handler() {
  }
}
