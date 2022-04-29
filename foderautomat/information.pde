class information {
  boolean active = false;
  String active_name = "0";
  int appfunktionerY = 600;
  boolean onAction = false;



  void view() {
    information_layout();
    information_actions();
  }


  void information_layout() {
    if (!active) appfunktionerY = 605;
    else appfunktionerY = 1205;
    image(bigHud, width/2, 300);
    image(bigHud, width/2, appfunktionerY);

    fill(#613CC6);
    textFont(bold, 40);
    text("Kalibrering af app'en", width/2-135, 305);
    text("Hj"+char(230)+"lp til app funktioner", width/2-125, appfunktionerY);


    if (active_name == "1") {
      image(off, width/2+300, 280);
      image(on, width/2+300, appfunktionerY);

      smallHud_info.resize(190*4, 800);
      image(smallHud_info, width/2-75, 750);
      fill(#613CC6);
      textFont(bold, 60);
      text("Instruktioner:", width/2-150, 500);
      textFont(bold, 40);
      text("1. G"+char(229)+" ind i indstillinger", width/2-160, 600);
      text("2. Tryk p"+char(229)+" \"Rekalibrer\"", width/2-155, 700);
      text("3. F"+char(248)+"lg indstruktionerne", width/2-145, 800);
    } else if (active_name == "2") {
      image(on, width/2+300, 280);
      image(off, width/2+300, 600);

      smallHud_info.resize(190*4, 1200);
      image(smallHud_info, width/2-75, 1300);
      fill(#613CC6);
      textFont(bold, 60);
      text("Instruktioner:", width/2-150, 1150);
    } else {
      image(on, width/2+300, 280);
      image(on, width/2+300, 600);
    }
  }

  void information_actions() {
    if (mouseX > width/2-425 && mouseX < width/2-425 + 165*5 && mouseY > 200 && mouseY < 200 + 200) {
      if (active) {
        active = false;
        active_name = "0";
      } else {
        active = true;
        active_name = "1";
      }
      delay(500);
      mouseX = 30000;
    }

    if (mouseX > width/2-425 && mouseX < width/2-425+165*5 && mouseY > 500 && mouseY < 500 +200 && !active) {
      if (active_name == "2") {
        active_name = "0";
      } else active_name = "2";
      delay(500);
      mouseX = 30000;
    }
  }
}
