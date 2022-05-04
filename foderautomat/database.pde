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
  
  boolean isAutoOn(){
    String[] rawdata = loadStrings(filePath);
    String[] raw;
    for(int i = 0; i < rawdata.length; i++){
      raw = split(rawdata[i], ":");
      
      if(raw[0].equals("Auto")){
        if(raw[i].equals("true")) return true;
        else return false;
      }
    }
    return false;
  }
  
  void findandchangevalue(String keyword, String newValue) {
    String[] rawdata = loadStrings(filePath);
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
    File f = dataFile(filePath);
    boolean exist = f.isFile();

    if (exist) {
      return true;
    }
    return false;
  }

  void createFile() {
    output = createWriter(filePath);
    output.write("FirstRun:true\n");
    output.write("Auto:true\n");
    output.write("Serial:9999\n");
    output.write("Settings:32\n");
    output.flush();
    output.close();
  }
}

class communicationDatabase {

  int SumOfDay(int day, long DAY_IN_MS, SimpleDateFormat simpleDateFormat) {
    int total = 0;
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
    String[] raw;

    for (int i = 0; i < rawdata.length; i++) {
      raw = split(rawdata[i], "/");

      Date d = new Date(System.currentTimeMillis() - (day * DAY_IN_MS));
      String stringDate = simpleDateFormat.format(d);

      if (raw[0].equals(stringDate)) {
        if (raw[2].equals("haeldt_op")) {
          total += parseInt(raw[1]);
        }
      }
    }

    return total;
  }

  String SumOfTime(int day, long DAY_IN_MS, SimpleDateFormat simpleDateFormat) {
    int sum1 = 0;
    int sum2 = 0;
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
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
      String[] bug = split(hits.get(i), ":");
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

    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
    String[] filtered;
    ArrayList<String> hits = new ArrayList<String>();
    for (int i = 0; i < rawdata.length; i++) {
      filtered = split(rawdata[i], "/");

      // check if data is time measured
      if (filtered[2].equals("sidst_spist")) {
        hits.add(filtered[1]);
      }
    }

    for (int i = 0; i < hits.size(); i++) {
      String[] bug = split(hits.get(i), ":");
      int num = parseInt(bug[0]);
      int num1 = parseInt(bug[1]);
      sum1 += num;
      sum2 += num1;
    }
    sum1 = sum1 / hits.size();
    sum2 = sum2 / hits.size();


    String time = sum1 + ":" + sum2;
    return time + "";
  }

  void LastTimeFedAppendData(String time) {

    try {
      File file = new File("/data/user/0/processing.test.foderautomat/files/storage/data.txt");

      FileWriter fw = new FileWriter(file, true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);

      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("dd:MM:yyyy");
      pw.write(format.format(date)+"/"+time+"/sidst_spist\n");

      pw.close();
    }
    catch(IOException ioe) {
      System.out.println("Exception ");
      ioe.printStackTrace();
    }
  }

  void WeightSensorAppendData(String data, String date) {
    try {
      File file = new File("/data/user/0/processing.test.foderautomat/files/storage/data.txt");

      FileWriter fw = new FileWriter(file, true);///true = append
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);


      pw.write(date+"/"+data+"/vaegt\n");

      pw.close();
    }
    catch(IOException ioe) {
      System.out.println("Exception ");
      ioe.printStackTrace();
    }
  }

  String getFoodAmountFilledUp(int day, long DAY_IN_MS, SimpleDateFormat simpleDateFormat) {
    int foder = 0;
    String[] rawdata = loadStrings("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
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

  boolean isFileCreated() {
    File f = dataFile("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
    boolean exist = f.isFile();

    if (exist) {
      return true;
    }
    return false;
  }

  void createFile() {
    output = createWriter("/data/user/0/processing.test.foderautomat/files/storage/data.txt");
    output.write("02:05:2022/17:10/sidst_spist\n");
    output.write("02:05:2022/14:50/sidst_spist\n");
    output.write("03:05:2022/01:21/sidst_spist\n");
    output.write("03:05:2022/17:43/sidst_spist\n");
    output.write("03:05:2022/32/haeldt_op\n");

    output.flush();
    output.close();
  }
}
