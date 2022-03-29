boolean loading = false;

class fragments {


  void Fhome() {
    home_layout();
    

    loading = false;
  }

  void home_layout() {
    image(datoColWhite, 133, 500);
    image(datoColWhite, 403, 500);
    image(datoColWhite, 673, 500);
    image(datoColWhite, 943, 500);
  }
  
  void home_actions(){
    // date action event listener    
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
