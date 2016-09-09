import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress puredata;

Markov markov;

void setup() {
  size(320, 240);
  
  oscP5 = new OscP5(this, 12000);
  
  puredata = new NetAddress("127.0.0.1", 12001); 
  markov = new Markov();
}

void draw() {
  background(0);
}

void mouseClicked() {
  oscP5.send(new OscMessage("/state").add(markov.getState()), puredata);
}

void oscEvent(OscMessage message) {
  println(message.arguments());
  for(int i = 0; i < message.arguments().length; i++) {
    if(message.arguments()[i].equals("getnextnote")){
      int next = markov.getNextNote();
      sendInt(next);
    }
  }
}

void sendInt(int i) {
  println("sending int: " + i);
  oscP5.send(new OscMessage("/state").add(i), puredata);
}