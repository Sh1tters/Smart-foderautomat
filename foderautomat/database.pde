import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;
import java.io.FileWriter;
import java.io.*;
FileWriter fw;
BufferedWriter bw;

PrintWriter output;



class database {

  boolean firstrun() {
    String[] rawdata = loadStrings(dataPath("")+"\\database.txt");
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");

      // find keyword
      if (raw[0].equals("FirstRun")) {

        // find value
        if (raw[1].equals("true")) {
          return true;
        }
      }
    }
    return false;
  }

  void requestData() {
    String[] rawdata = loadStrings(dataPath("")+"\\database.txt");
    for (int i = 0; i < rawdata.length; i++) {
      println(rawdata[i]);
    }
  }

  void findandchangevalue(String keyword, String newValue) {
    String[] rawdata = loadStrings(dataPath("")+"\\database.txt");
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");

      // find keywords
      if (raw[0].equals(keyword)) {

        // find line and change it
        if (rawdata[i].equals(raw[0]+":"+raw[1])) {
          rawdata[i] = raw[0]+":"+newValue;
        }
      }
    }

    // save the file
    saveStrings(dataPath("")+"\\database.txt", rawdata);
  }

  boolean isFileCreated() {
    File f = dataFile(dataPath("")+"\\database.txt");
    boolean exist = f.isFile();

    if (exist) {
      return true;
    }
    return false;
  }

  void createFile() {
    output = createWriter(dataPath("")+"\\database.txt");
  }
}

class communicationDatabase {
  /**
   
   println(cdb.requestDcMotorSumOfTimeFromToday(LocalDateTime.now()));
   today = new Date();
   println(LocalDateTime.now());
   println(frag.findPrevDay(today, 0).toString());
   println(frag.findPrevDay(today, 1).toString());
   println(frag.findPrevDay(today, 2).toString());
   println(frag.findPrevDay(today, 3).toString());*/

  void requestDcMotorSumOfADayAndSetTextOnApp() {
    int sum1 = 0;
    int sum2 = 0;
    datafileExist();


    String[]rawdata = loadStrings(dataPath("")+"\\data.txt");
    String[] filtered;
    String dateFiltered;
    ArrayList<String> hits = new ArrayList<String>();
    for (int i = 0; i < rawdata.length; i++) {
      filtered = split(rawdata[i], "/");

      if (filtered[2].equals("time")) {
        hits.add(filtered[1]);
      }
    }
  }

  String requestDcMotorSumOfAllTime() {
    int sum1 = 0;
    int sum2 = 0;
    datafileExist();

    String[] rawdata = loadStrings(dataPath("")+"\\data.txt");
    String[] filtered;
    ArrayList<String> hits = new ArrayList<String>();
    for (int i = 0; i < rawdata.length; i++) {
      filtered = split(rawdata[i], "/");

      // check if data is time measured
      if (filtered[2].equals("time")) {
        hits.add(filtered[1]);
      }
    }

    for (int i = 0; i < hits.size(); i++) {
      String[] bug = split(hits.get(i), ".");
      int num = Integer.parseInt(bug[0]);
      int num1 = Integer.parseInt(bug[1]);
      sum1 += num;
      sum2 += num1;
    }
    sum1 = sum1 / hits.size();
    sum2 = sum2 / hits.size();

    return sum1 + ":" + sum2;
  }

  void LastTimeFedAppendData(String time) {
    datafileExist();

    try {
      File file = new File(dataPath("")+"\\data.txt");

      FileWriter fw = new FileWriter(file, true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);

      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy:MM:dd");

      pw.write(format.format(date)+"/"+time+"/last_fed_time");

      pw.close();
    }
    catch(IOException ioe) {
      System.out.println("Exception ");
      ioe.printStackTrace();
    }
  }

  void WeightSensorAppendData(String data) {
    datafileExist();

    try {
      File file = new File(dataPath("")+"\\data.txt");

      FileWriter fw = new FileWriter(file, true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);

      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy:MM:dd");

      pw.write(format.format(date)+"/"+data+"/last_fed_time");

      pw.close();
    }
    catch(IOException ioe) {
      System.out.println("Exception ");
      ioe.printStackTrace();
    }
  }

  void datafileExist() {
    File f = dataFile(dataPath("")+"\\data.txt");
    boolean exist = f.isFile();

    if (exist) {
    } else {
      output = createWriter(dataPath("")+"\\data.txt");
    }
  }
}
