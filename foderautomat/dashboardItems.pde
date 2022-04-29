import java.util.concurrent.*;

import static java.util.concurrent.TimeUnit.SECONDS;

float weight = 0.;
String sidst_spist = "00:00", gen_spist = "00:00"; // format: 00:00
String ugentlig_forbrug = "0", ugentlig_forbrug_penge = "0";
int max_mad = 350;
String foderAmount = "0";

class dashboarditems {
  long DAY_IN_MS = 1000 * 60 * 60 * 24;
  String pattern = "dd:MM:yyyy";
  SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
  int cd_timeleft;
  int time;

  color c;
  boolean cd = false;
  color onCD = #613CC6;
  color offCD = #9482C4;
  void view() {
    // load new data
    loadData();

    layout();
    dashboard_foder();
    dashboard_vaegt();
    dashboard_feednow();
    dashboard_feednow_actionHandler();
    dashboard_tid();
    dashboard_forbrug();

    runCD();
  }

  void loadData() {
    sidst_spist = "00:00";
    gen_spist = "00:00";
    foderAmount = "0";
    weight = 0.;
    // what date is selected?
    if (selected.equals("one")) {
      String[] rawdata = loadStrings("data.txt");
      String[] raw;
      for (int i = 0; i < rawdata.length; i++) {
        raw = split(rawdata[i], "/");

        Date d = new Date(System.currentTimeMillis() - (3 * DAY_IN_MS));
        String stringDate= simpleDateFormat.format(d);

        // find keyword
        if (raw[0].equals(stringDate)) { // get the date 3 days ago
          if (raw[2].equals("sidst_spist")) {
            sidst_spist = raw[1];
          }
          if (raw[2].equals("time")) {
            gen_spist = cdb.SumOfTime(3, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
          if (raw[2].equals("vaegt")) {
            float temp = parseFloat(raw[1]);
            weight = temp;
          }
          if (raw[2].equals("haeldt_op")) {
            foderAmount = cdb.getFoodAmountFilledUp(3, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
        }
      }
    } else if (selected.equals("two")) {
      String[] rawdata = loadStrings("data.txt");
      String[] raw;
      for (int i = 0; i < rawdata.length; i++) {
        raw = split(rawdata[i], "/");

        Date d = new Date(System.currentTimeMillis() - (2 * DAY_IN_MS));
        String stringDate= simpleDateFormat.format(d);

        // find keyword
        if (raw[0].equals(stringDate)) { // get the date 2 days ago
          if (raw[2].equals("sidst_spist")) {
            sidst_spist = raw[1];
          }
          if (raw[2].equals("time")) {
            gen_spist = cdb.SumOfTime(2, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
          if (raw[2].equals("vaegt")) {
            float temp = parseFloat(raw[1]);
            weight = temp;
          }
          if (raw[2].equals("haeldt_op")) {
            foderAmount = cdb.getFoodAmountFilledUp(2, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
        }
      }
    } else if (selected.equals("three")) {
      String[] rawdata = loadStrings("data.txt");
      String[] raw;
      for (int i = 0; i < rawdata.length; i++) {
        raw = split(rawdata[i], "/");

        Date d = new Date(System.currentTimeMillis() - (1 * DAY_IN_MS));
        String stringDate= simpleDateFormat.format(d);

        // find keyword
        if (raw[0].equals(stringDate)) { // get the date 1 days ago
          if (raw[2].equals("sidst_spist")) {
            sidst_spist = raw[1];
          }
          if (raw[2].equals("time")) {
            gen_spist = cdb.SumOfTime(1, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
          if (raw[2].equals("vaegt")) {
            float temp = parseFloat(raw[1]);
            weight = temp;
          }
          if (raw[2].equals("haeldt_op")) {
            foderAmount = cdb.getFoodAmountFilledUp(1, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
        }
      }
    } else if (selected.equals("four")) {
      String[] rawdata = loadStrings("data.txt");
      String[] raw;
      for (int i = 0; i < rawdata.length; i++) {
        raw = split(rawdata[i], "/");

        Date d = new Date(System.currentTimeMillis() - (0 * DAY_IN_MS));
        String stringDate= simpleDateFormat.format(d);

        // find keyword
        if (raw[0].equals(stringDate)) {
          if (raw[2].equals("sidst_spist")) {
            sidst_spist = raw[1];
          }
          if (raw[2].equals("time")) {
            gen_spist = cdb.SumOfTime(0, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
          if (raw[2].equals("vaegt")) {
            float temp = parseFloat(raw[1]);
            weight = temp;
          }
          if (raw[2].equals("haeldt_op")) {
            foderAmount = cdb.getFoodAmountFilledUp(0, 1000 * 60 * 60 * 24, simpleDateFormat);
          }
        }
      }
    }
  }


  void layout() {
    for (int i = 0, x = 290; i < 2; i++) {
      image(dashboarditem, x, 880);
      x+=510;
    }
    for (int i = 0, x = 290; i < 2; i++) {
      image(dashboarditem, x, 1510);
      x+=510;
    }

    //image(kitty_forbrug, 560, 1780);
    textAlign(CENTER);
    textFont(SegoeBold, 70);
    text("Foder", width/5-20, 700);
    text("V"+char(230)+"gt", width-365, 700); // char(230) = 'æ'
    text("Tid", width/5-55, 1335);
    text("Forbrug", width-325, 1335);

    image(kitty_forbrug, width-125, 1320);
    image(kitty_time, width/5+200, 1315);
    image(kitty_vaegt, width-125, 690);
    image(kitty_spist, width/5+200, 690);
  }

  void dashboard_foder() {
    int filled = max_mad; // controls how much is filled in the diagram
    int current = parseInt(foderAmount);
    noStroke();
    fill(#22E763);
    rect(width/5-100, 800, current, 85, 50);

    noFill();
    stroke(#707070);
   // strokeWeight(8);
    rect(width/5-100, 800, filled, 85, 50);

    fill(0);
    textAlign(CENTER);
    textFont(SegoeBold, 50);
    text(cdb.getProcentOf2Numers(max_mad, foderAmount), width/5+90, 860);

    fill(0);
    textAlign(CENTER);
    textFont(SegoeBold, 65 );
    text(foderAmount+"/350 g", width/5+90, 1000);
    
  }

  void dashboard_vaegt() {
    if (weight < 4) c = #00FF3C;
    else if (weight > 4 && weight < 6) c = #F6FF00;
    else c = #FF0008;
    fill(c);
    stroke(0);
    ellipse(width - 285, 900, 350, 200);
    fill(0);
    textFont(SegoeBold, 50);
    textAlign(CENTER);
    text(weight + " kg", width - 290, 920);
    textFont(SegoeBold, 40);
    text(weight + " kg", width - 290, 1050);
    fill(c);
    noStroke();
    ellipseMode(CENTER);
    ellipse(width-200, 1035, 35, 35);
    
    strokeWeight(0);
    
  }

  void dashboard_tid() {
    image(clock, width/5-70, 1475);
    image(line, width/5+60, 1400);
    image(line, width/5+60, 1600);
    fill(0);
    textFont(SegoeBold, 50);
    text("Sidst spist", width/5+70, 1450);
    text(sidst_spist, width/5+70, 1540);

    text("Gennemsnitstid", width/5+70, 1650);
    text(gen_spist, width/5+70, 1740);
  }

  void dashboard_forbrug() {
    image(line, width/5+570, 1400);
    image(line, width/5+570, 1600);

    fill(0);
    textFont(SegoeBold, 50);
    text("Ugentlig forbrug:", width/5+570, 1450);
    text("Max. " + ugentlig_forbrug + " g foder", width/5+570, 1525);
    text("Ugentlig forbrug:", width/5+570, 1650);
    text(ugentlig_forbrug_penge + " kr.", width/5+570, 1725);
  }

  void dashboard_feednow() {
    color colr = #613CC6;
    if (cd) colr = offCD; 
    else colr = onCD;

    fill(colr);
    noStroke();
    rect(width/2-300, 1880, 600, 200, 100);
    fill(#FFFFFF);
    textFont(SegoeBold, 60);
    text("H"+char(230)+"ld foder op", width/2, 2000);

    if (cd) {
      fill(#FF0008);
      textFont(SegoeBold, 40);
      text("Vent venligst " + cd_timeleft + " s", width/2, 2050);
    }
  }

  void dashboard_feednow_actionHandler() {


    if (mouseX > width/2-300 && mouseX < width/2-300+600 && mouseY > 1880 && mouseY < 1880 + 200) {
      if (!cd) {
        // start motor

        // start timer delay
        cd = true;
        cd_timeleft = 20; // 20 seconds
      }
    }
  }

  void runCD() {
    if (cd) {
      if (millis() - time >= 1000)
      {
        cd_timeleft--;
        if (cd_timeleft < 0) {
          cd = false;
        }
        time = millis();
      }
    }
  }
} 
