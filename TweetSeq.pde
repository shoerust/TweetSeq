import twitter4j.*;
import twitter4j.TwitterResponse;
import java.util.Date;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import processing.video.*;

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
 
private Minim minim;
private AudioOutput out;
private Sequencer sequencer;
 
void setup() {
  size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
  background(255);
  smooth();
  sequencer = new Sequencer();
  sequencer.setupCamera(this);
  sequencer.retrieveTweets();
}
 
void draw() {
  sequencer.drawSequencer();
  sequencer.drawTimeIndicator();
  sequencer.updateTweetLocation();
  sequencer.drawTweets();
}


