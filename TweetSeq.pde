import twitter4j.*;
import twitter4j.TwitterResponse;
import java.util.Date;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Arrays;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import processing.video.*;

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;

private Sequencer sequencer;
private Minim minim;
 
void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
  background(255);
  smooth();
  minim = new Minim(this);
  sequencer = new Sequencer(minim);
  sequencer.setupCamera(this);
  sequencer.retrieveTweets();
}
 
void draw() {
  sequencer.drawSequencer();
  sequencer.drawTweets();
  sequencer.drawTimeIndicator();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    sequencer.resetTweets();
    sequencer.buttonPressed();
    sequencer.setOffset();
  } else if (mouseButton == RIGHT) {
    sequencer.playSample();
    sequencer.removeActiveTweet();
  }
}

void mouseDragged() {
  sequencer.updateTweet();
}


