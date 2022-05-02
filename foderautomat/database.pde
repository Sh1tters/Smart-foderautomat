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
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
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

  String isAutoOn() {
    String on = "false";
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");
      // find keyword
      if (raw[0].equals("Auto")) {
        // find value
        if (raw[1].equals("true")) {
          on = "true";
        }
      }
    }
    return on;
  }

  void requestData() {
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
    for (int i = 0; i < rawdata.length; i++) {
      String[] raw = split(rawdata[i], ":");
      if(raw[0].equals("Serial")){
      }
    }
  }

  void findandchangevalue(String keyword, String newValue) {
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/database.txt");
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], ":");

      // find keywords
      if (raw[0].equals(keyword)) {
        rawdata[i] = raw[0]+":"+newValue;
      }
    }
    // save the file
    saveStrings("/data/user/0/processing.test.foderautomat/files/database.txt", rawdata);
  }

  boolean isFileCreated() {
    File f = dataFile("/data/user/0/processing.test.foderautomat/files/database.txt");
    boolean exist = f.isFile();

    if (exist) {
      return true;
    }
    return false;
  }

  void createFile() {
    output = createWriter("/data/user/0/processing.test.foderautomat/files/database.txt");
    output.write("FirstRun:true\n");
    output.write("Auto:true\n");
    output.write("Serial:9999\n");
    output.flush();
    output.close();
  }
}

class communicationDatabase {

  String SumOfTime(int day, long DAY_IN_MS, SimpleDateFormat simpleDateFormat) {
    int sum1 = 0;
    int sum2 = 0;
    String[] rawdata = loadStrings("data.txt");
    String[] raw;
    ArrayList<String> hits = new ArrayList<String>();
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], "/");

      Date d = new Date(System.currentTimeMillis() - (day * DAY_IN_MS));
      String stringDate= simpleDateFormat.format(d);

      // find keyword
      if (raw[0].equals(stringDate)) {
        if (raw[2].equals("time")) {
          hits.add(raw[1]);
        }
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

  String requestDcMotorSumOfAllTime() {
    int sum1 = 0;
    int sum2 = 0;
    datafileExist();

    String[] rawdata = loadStrings("data.txt");
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
      File file = new File("data.txt");

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
      File file = new File("data.txt");

      FileWriter fw = new FileWriter(file, true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);

      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy:MM:dd");

      pw.write(format.format(date)+"/"+data+"/vaegt");

      pw.close();
    }
    catch(IOException ioe) {
      System.out.println("Exception ");
      ioe.printStackTrace();
    }
  }

  String getFoodAmountFilledUp(int day, long DAY_IN_MS, SimpleDateFormat simpleDateFormat) {
    int foder = 0;
    String[] rawdata = loadStrings("data.txt");
    String[] raw;
    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], "/");

      Date d = new Date(System.currentTimeMillis() - (day * DAY_IN_MS));
      String stringDate= simpleDateFormat.format(d);

      // find keyword
      if (raw[0].equals(stringDate)) {
        if (raw[2].equals("haeldt_op")) {
          int value = parseInt(raw[1]);
          foder+=value;
        }
      }
    }

    return ""+foder;
  }

  double calculatePercentage(double obtained, double total) {
    return obtained * 100 / total;
  }

  String getProcentOf2Numers(int max, String current) {
    double obtained = Double.parseDouble(current);
    double total =  max;

    int val = (int)calculatePercentage(obtained, total);

    String value = nf(val, 0, 1);
    return value + "%";
  }

  void datafileExist() {
    File f = dataFile("data.txt");
    boolean exist = f.isFile();

    if (exist) {
    } else {
      output = createWriter("data.txt");
    }
  }
}
