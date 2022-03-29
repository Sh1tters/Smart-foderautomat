PrintWriter output;


class database {
  
  boolean firstrun(){
    String[] rawdata = loadStrings(dataPath("")+"\\database.txt");
    String[] raw;
    for(int i = 0; i < rawdata.length; i++){
      raw = split(rawdata[i], ":");
      
      // find keyword
      if(raw[0].equals("FirstRun")){
        
        // find value
        if(raw[1].equals("true")){
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
