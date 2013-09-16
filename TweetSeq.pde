import twitter4j.*;
import twitter4j.TwitterResponse;
import java.util.Date;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import processing.video.*;

import java.util.concurrent.locks.*;

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
 
Minim minim;
AudioOutput out;
Twitter twitter;
Sequencer sequencer;
float tempo = 0.0;
DateTime dateTime;
float currentTime;
Capture cam;

ArrayList<Tweet> list = new ArrayList<Tweet>();
final ReadWriteLock lock = new ReentrantReadWriteLock();
 
void setup() {
  //Set the size of the stage, and the background to black.
  size(displayWidth,displayHeight);
  background(255);
  smooth();
  
  double mapCenterLat = 39.8282;
  double mapCenterLon = -98.5795;
  int zoomLevel = 8;
  String mapType = GoogleMapper.MAPTYPE_TERRAIN;
  int mapWidth=1100;
  int mapHeight=900;
  dateTime = new DateTime();
  currentTime = dateTime.getMillis();
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, displayWidth, displayHeight);
    cam.start();     
  } 
  
  retrieveTweets();
}
 
void draw() {
 background(255);
 if (cam.available() == true) {
    cam.read();
 }
 image(cam, 0, 0);
 strokeWeight(4);
 smooth(8);
 
 //draw border lines
 line(width-400, 0, width-400, height);
 line(0, height-400, width-400, height-400);
 
 //draw sequencer
 strokeWeight(3);
 line(0, height-300, width-400, height-300);
 line(0, height-200, width-400, height-200);
 line(0, height-100, width-400, height-100);
 
 //draw index
 line(tempo, height-400, tempo, height);
 currentTime = dateTime.getMillis() - currentTime;
 println("CurrentTime: " + currentTime);
 println("Framerate: " + frameRate);
 println("Divided: " + frameRate/currentTime);
 if (currentTime == 0) currentTime = 1;
 tempo += (frameRate/currentTime/16);
 if (tempo > width-400) tempo = 0; 
 
 //draw tweets
 strokeWeight(1);
 for (Tweet tweet : list) {
   fill(tweet.getColor(), tweet.getAlpha());
   rect(tweet.getX(), tweet.getY(), 500, 80, 20);
   fill(0, 100);
   text("@" + tweet.getStatus().getUser().getScreenName() + "\n " + tweet.getStatus().getText(), tweet.getX() + 50 + tweet.getPadding(), tweet.getY() + tweet.getPadding(), 270, 85);
   PImage img = loadImage("output/" + tweet.getStatus().getUser().getScreenName() + ".jpg");
   if (img == null) {
     img = loadImage(tweet.getStatus().getUser().getProfileImageURL(), "jpeg");
     img.save("output/" + tweet.getStatus().getUser().getScreenName() + ".jpg");
   }
   image(img, tweet.getX() + tweet.getPadding(), tweet.getY() + tweet.getPadding() + 5);
 }
}

private void retrieveTweets() {
  try {  
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setDebugEnabled(true)
      .setOAuthConsumerKey("kzcsRdw9vxlyOBbGiJSpQ")
      .setOAuthConsumerSecret("SE3vDkosIPdxd7z4GjUhH16hHPxPDoUvkMMyfl13rk")
      .setOAuthAccessToken("261075925-4O5yNlSlhg3GNw8CBe1vjoxaoJI1rftN2GGuaonX")
      .setOAuthAccessTokenSecret("ljLSLkNaDvr3nKd9Pr21s8Gi9CTWSCMwh3cu5x77UTM");
    TwitterFactory tf = new TwitterFactory(cb.build());
    twitter = tf.getInstance();
    Query query = new Query("#auspol");
    QueryResult result = twitter.search(query);
    int counter = 0;
    for (Status status : result.getTweets()) {
      list.add(new Tweet(status, 90, color(120, 120, 120), width-400, counter));
      System.out.println("@" + status.getUser().getScreenName() + ":" + status.getText());
      counter += 83;
    }
  } catch (TwitterException e) {
    e.printStackTrace();
  }
}
