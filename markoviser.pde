import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress puredata;

Markov markov;

void setup() {
  size(640, 480);
  
  oscP5 = new OscP5(this, 12000);
  
  puredata = new NetAddress("127.0.0.1", 12001); 
  markov = new Markov();
}

void draw() {
  background(0);
  rect(mouseX, mouseY, 20, 20);
}

void mouseClicked() {
  oscP5.send(new OscMessage("/state " + markov.getState()), puredata);
}

void oscEvent(OscMessage message) {
  for(int i = 0; i < message.arguments().length; i++) {
    if(message.arguments()[i].equals("getnext")){
      int next = markov.getNext();
      sendInt(next);
    }
  }
  println(message.arguments());
}

void sendInt(int i) {
  println("sending int: " + i);
  oscP5.send(new OscMessage("/state " + i), puredata);
}