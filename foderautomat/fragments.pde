boolean loading = false;
import java.time.LocalDate;
import java.util.Date;
Date today;

String selected = "four";

class fragments {
  final long MILLIS_IN_A_DAY = 1000 * 60 * 60 * 24;
  int addon = 270;


  void Fhome() {
    today = new Date();
    home_layout();
    home_handler();
    home_actions();


    loading = false;
  }
  //font Segoe UI
  void home_layout() {
    // title
    image(Oversigt, width/2, 200);

    // date slide
    for (int i = datesWhite.length - 1, x = 133; i >= 0; i--) {
      String date = findPrevDay(today, i).toString();
      String[] dateParts = date.split(" ");


      image(datesWhite[i], x, 500);
      textAlign(CENTER);
      fill(#613CC6);
      textFont(Segoe, 65);
      text(dateParts[2], x, 500);
      textFont(Segoe, 40);
      text(dateParts[0], x, 550);
      x+=270;
    }

    // show dashboard items
    dbi.setup();
  }


  void home_actions() {
    int x = 133 / 4, y = 380, w = 200, h = 220;
    //244,270
    // date action event listener
    // first image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      //image(datoColBlue, 133, 500);
      selected = "one";
    }
    x=133 + (addon - (w/2));
    // second image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      //image(datoColBlue, 133 + addon, 500);
      selected = "two";
    }
    x=133 + (addon * 2 - (w/2));
    // third image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      //image(datoColBlue, 133 + (addon * 2), 500);
      selected = "three";
    }
    x=133 + (addon * 3 - (w/2));
    // fourth image
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      //image(datoColBlue, 133 + (addon * 3), 500);
      selected = "four";
    }
  }

  void home_handler() {
    if (selected.equals("one")) {
      image(datoColBlue, 133, 500);
      setText(3, 133, 500, 550);
    } else if (selected.equals("two")) {
      image(datoColBlue, 133 + addon, 500);
      setText(2, 133 + addon, 500, 550);
    } else if (selected.equals("three")) {
      image(datoColBlue, 133 + (addon * 2), 500);
      setText(1, 133 + (addon * 2), 500, 550);
    } else if (selected.equals("four")) {
      image(datoColBlue, 133 + (addon * 3), 500);
      setText(0, 133 + (addon * 3), 500, 550);
    }
  }

  void Fsettings() {

    loading = false;
  }

  void Finfo() {

    loading = false;
  }

  void setText(int numdate, int x, int y, int y2) {
    String date = findPrevDay(today, numdate).toString();
    String[] dateParts = date.split(" ");

    textAlign(CENTER);
    fill(#ffffff);
    textFont(Segoe, 65);
    text(dateParts[2], x, y);
    textFont(Segoe, 40);
    text(dateParts[0], x, y2);
  }

  private Date findPrevDay(Date date, int amount)
  {
    return new Date(date.getTime() - (MILLIS_IN_A_DAY * amount));
  }
}
