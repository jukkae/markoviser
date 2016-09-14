import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress puredata;

Markov markov;
Markov rhythmM;

void setup() {
  size(320, 240);
  
  oscP5 = new OscP5(this, 12000);
  
  puredata = new NetAddress("127.0.0.1", 12001); 
  markov = new Markov();
  rhythmM = new Markov();
}

void draw() {
  background(0);
}

void mouseClicked() {
  oscP5.send(new OscMessage("/state").add(markov.getState()), puredata);
}

void oscEvent(OscMessage message) {
  if(message.checkAddrPattern("/lerp1")) {
    float lerp = (float) message.arguments()[0];
    markov.lerpMatricesA(lerp);
  }
  if(message.checkAddrPattern("/lerp2")) {
    float lerp = (float) message.arguments()[0];
    markov.lerpMatricesB(lerp);
  }
  for(int i = 0; i < message.arguments().length; i++) {
    if(message.arguments()[i].equals("getnextnote")){
      int next = markov.getNextNote();
      sendInt(next);
    }
    if(message.arguments()[i].equals("getnextvalue")) {
      int next = markov.getNextValue();
      sendValue(next);
      if(next == 16 || next == 12) sendToggle(0); //TODO testing toggle!
    }
    if(message.arguments()[i].equals("getnextmute")) {
      int mute = markov.getNextMute();
      sendMute(mute);
    }
    if(message.arguments()[i].equals("getnextlegato")) {
      int legato = markov.getNextLegato();
      sendLegato(legato);
    }
  }
}

void sendInt(int i) {
  oscP5.send(new OscMessage("/state").add(i), puredata);
}

void sendValue(int i) {
  oscP5.send(new OscMessage("/value").add(i), puredata);
}

void sendToggle(int i) {
  oscP5.send(new OscMessage("/toggle").add(i), puredata);
}

void sendMute(int i) {
  oscP5.send(new OscMessage("/mute").add(i), puredata);
}

void sendLegato(int i) {
  oscP5.send(new OscMessage("/legato").add(i), puredata);
}