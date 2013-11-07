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
private Particles particles;
private PeasyCam cam;
private SimpleOpenNI  context;
PVector handVec = new PVector();

private Boolean isgesturing = false;

void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT, P3D);
  smooth();
  cam = new PeasyCam(this, Constants.APPLICATION_WIDTH/8, Constants.APPLICATION_HEIGHT/8, 0, 600);
  cam.setActive(false);
  setupKinect();
  minim = new Minim(this);
  particles = new Particles(cam);
  sequencer = new Sequencer(minim,particles);
  // sequencer.setupCamera(this);
  sequencer.retrieveTweets();
}

void draw() {
  background(205);
  cam.beginHUD();
  sequencer.drawSequencer();
  particles.speed();
  particles.drawParticles();
  sequencer.drawTweets();
  sequencer.drawTimeIndicator();
  cam.endHUD();
}

void setupKinect()
{
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableRGB();
  context.enableHand();
  context.startGesture(SimpleOpenNI.GESTURE_WAVE);
}

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  
  sequencer.resetTweets();
  sequencer.buttonPressed(pos);
  sequencer.setOffset(pos);
  
}
public int mapWidth(PVector pos)
{
  return int(map(pos.x, 0, 500, 0, Constants.APPLICATION_WIDTH));
}
void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  if(isgesturing == true)
  {
    isgesturing = false;
    sequencer.snapToGrid(pos);
    sequencer.deactivateTweet();
  }
  else
  {
    context.startTrackingHand(pos);
    isgesturing = true;
  }
  //context.startTrackingHand(pos);
 /* context.startTrackingHand(pos);
  
  int handId = context.startTrackingHand(pos);
  println("hand stracked: " + handId);*/
}

void mousePressed() {
  if (mouseButton == LEFT) {
    sequencer.resetTweets();
    sequencer.buttonPressed();
    sequencer.setOffset();
  } 
  else if (mouseButton == RIGHT) {
    sequencer.playSample();
    sequencer.removeActiveTweet();
  }
}

void mouseDragged() {
  sequencer.updateTweet();
}

void mouseReleased() {
  sequencer.snapToGrid();
  sequencer.deactivateTweet();
}
