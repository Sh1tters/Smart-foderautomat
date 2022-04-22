import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.net.InetAddress;
import java.net.Socket;

Socket socket;
boolean com = false;

void setup() {
  size(300, 300);
}

void draw() {
}

void mousePressed() {
  println("lol");
  com = true;
  requestData();
}


void requestData() {
  if (com) {
    try {
      // Connect to socket now
      InetAddress host = InetAddress.getLocalHost();
      socket = new Socket(host.getHostName(), 7777);

      if (socket.isConnected()) {
        // Send a message to the client application
        ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
        oos.writeObject("requesting information to dc motor module");

        // Read and display the response message sent by server application
        ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
        String message = (String) ois.readObject();
        System.out.println(message);

        ois.close();
        oos.close();
      }
    }
    catch (IOException | ClassNotFoundException e) {
      e.printStackTrace();
    }
    com = false;
  }
}
