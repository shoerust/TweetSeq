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
private Particles particles;
private PeasyCam cam;

void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT, P3D);
  smooth();
  cam = new PeasyCam(this, Constants.APPLICATION_WIDTH/8, Constants.APPLICATION_HEIGHT/8, 0, 600);
  cam.setActive(false);
  background(255);

  minim = new Minim(this);
  particles = new Particles(cam);
  sequencer = new Sequencer(minim,particles);
  // sequencer.setupCamera(this);
  sequencer.retrieveTweets();
}

void draw() {
  background(255);
  cam.beginHUD();
  particles.speed();
  particles.drawParticles();
  sequencer.drawSequencer();
  sequencer.drawTweets();
  sequencer.drawTimeIndicator();
  cam.endHUD();
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

<<<<<<< HEAD
=======
void mouseReleased() {
  sequencer.snapToGrid();
  sequencer.deactivateTweet();
}


>>>>>>> 6cd5a3255f3719d5a5be4c0c16dc8f3c16380898
