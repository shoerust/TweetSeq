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
PVector oldLocation = new PVector();
private DateTime dateTime;
private double time;
private Boolean isgesturing = false;

void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT, P3D);
  //smooth();
  cam = new PeasyCam(this, Constants.APPLICATION_WIDTH/8, Constants.APPLICATION_HEIGHT/8, 0, 600);
  cam.setActive(false);
  setupKinect();
  minim = new Minim(this);
  particles = new Particles(cam);
  sequencer = new Sequencer(minim,particles);
  // sequencer.setupCamera(this);
  sequencer.retrieveTweets();
  dateTime = new DateTime();
  time = 0;
}

void draw() {
  background(205);
  cam.beginHUD();
  sequencer.drawSequencer();
  particles.speed();
  particles.drawParticles();
  sequencer.drawTweets();
  sequencer.drawTimeIndicator();
  context.startTrackingHand(oldLocation);
  cam.endHUD();
}

void setupKinect()
{
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableRGB();
  context.enableHand();
  context.setMirror(true);
  context.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  println(context.depthWidth());
  println(context.depthHeight());
}

void onTrackedHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  println("Tracking Hand pos: " + pos); 
  PVector p2d = new PVector();
  context.convertRealWorldToProjective(pos,p2d);
  println("New X: " + p2d.x);
  println("New Y: " + p2d.y);
  ellipse(mapWidth(p2d), mapHeight(p2d), 50, 50);
  checkLocation(p2d);
  sequencer.updateTweet();
}
public float mapWidth(PVector pos)
{
  return map(pos.x, 0, 640, 0, Constants.APPLICATION_WIDTH);
}
public float mapHeight(PVector pos)
{
  return map(pos.y, 0, 480, 0, Constants.APPLICATION_HEIGHT);
}

void checkLocation(PVector pos) {
  DateTime temp = new DateTime();
  Period period = new Period(dateTime, temp);
  time += (double) period.getMillis();
  time = time/1000;
  println("Time: " + time);
  if (time > 0.05) {
    if (pos.x > oldLocation.x-5 && pos.x < oldLocation.x+5
      && pos.y > oldLocation.y-5 && pos.y < oldLocation.y+5) {
          if(isgesturing == true)
          {
            sequencer.snapToGrid(pos);
            sequencer.deactivateTweet();
            isgesturing = false;
          }
          else
          {
            sequencer.resetTweets();
            sequencer.buttonPressed(pos);
            sequencer.setOffset(pos);
            context.startTrackingHand(pos);
            isgesturing = true;
          }
    }
    time = 0;
  }
  oldLocation = pos;
  dateTime = temp;
}

void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  PVector p2d = new PVector();
  context.convertRealWorldToProjective(pos,p2d);
  if(isgesturing == true)
  {
    isgesturing = false;
    sequencer.snapToGrid(p2d);
    sequencer.deactivateTweet();
  }
  else
  {
    sequencer.resetTweets();
    sequencer.buttonPressed(p2d);
    sequencer.setOffset(p2d);
    context.startTrackingHand(p2d);
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
