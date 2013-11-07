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

import SimpleOpenNI.*;

private Sequencer sequencer;
private Minim minim;

SimpleOpenNI  context;

void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
  background(255);
  smooth();
  setupKinect();
  minim = new Minim(this);
  sequencer = new Sequencer(minim);
//  sequencer.setupCamera(this);
  sequencer.retrieveTweets();
}

void draw() {
  sequencer.drawSequencer(context);
  sequencer.drawTweets();
  sequencer.drawTimeIndicator();

}
void setupKinect()
{
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableRGB();
  context.enableHand();
  context.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
}

void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  
 /* context.startTrackingHand(pos);
  
  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);*/
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

void mouseReleased() {
  sequencer.deactivateTweet();
}


