import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.lang.Runnable;
import java.lang.Thread;
import java.net.ServerSocket;
import java.net.Socket;

private static final int PORT = 7777;
private ServerSocket server;

void setup() {
  try {
    server = new ServerSocket(PORT);
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void draw() {
  handleConnection();
}

private void handleConnection() {
  System.out.println("Waiting for client message...");

  // The server do a loop here to accept all connection initiated by the
  // client application.
  while (true) {
    try {
      Socket socket = server.accept();
      new ConnectionHandler(socket);
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}



class ConnectionHandler implements Runnable {
  private final Socket socket;

  ConnectionHandler(Socket socket) {
    this.socket = socket;

    Thread t = new Thread(this);
    t.start();
  }

  public void run() {
    try {
      // Read a message sent by client application
      ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
      String message = (String) ois.readObject();
      System.out.println("Message Received: " + message);

      // Send a response information to the client application
      ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
      oos.writeObject("Hi...");

      ois.close();
      oos.close();
      socket.close();

      System.out.println("Waiting for client message...");
    }
    catch (IOException | ClassNotFoundException e) {
      e.printStackTrace();
    }
  }
}
