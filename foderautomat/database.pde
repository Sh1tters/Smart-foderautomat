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

  String requestDcMotorInformation() {
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
    
    for(int i = 0; i < hits.size(); i++){
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

  void datafileExist() {
    File f = dataFile(dataPath("")+"\\data.txt");
    boolean exist = f.isFile();

    if (exist) {
    } else {
      output = createWriter(dataPath("")+"\\data.txt");
    }
  }
}
