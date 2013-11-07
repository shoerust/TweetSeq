/**
 * Main class for handling all logic relating to the
 * sequencer and retrieving and displaying tweets
 */

public class Sequencer {
  private Twitter twitter;
  private Capture cam;
  private double tempo;
  private DateTime dateTime;
  private ArrayList<Tweet> tweetList;
  private ArrayList<Tweet> activeTweetList;
  private Minim minim;
  private AudioOutput out;
  private float xOffset;
  private float yOffset;
  private boolean playing;
  
  public Sequencer(Minim minim) {
      dateTime = new DateTime();
      tempo = (double) width-1200;
      tweetList = new ArrayList<Tweet>();
      activeTweetList = new ArrayList<Tweet>();
      this.minim = minim;
      out = minim.getLineOut( Minim.STEREO, 2048 );
      playing = false;
  }
  
  public Capture getCamera() {
    return this.cam;
  }
  
  public void drawSequencer() {
     background(255);
//     if (cam.available() == true) {
//       cam.read();
//     }
//     image(cam, 0, 0);
     strokeWeight(4);
     stroke(255);
     smooth(8);
     fill(color(255,255,255,120));
     //draw border lines
     rect(width-300, 0, width-300, height);
     rect(0, height-300, width-300, height-300);
     
     //draw sequencer
     strokeWeight(3);
     stroke(255);
     fill(color(120,120,120,120));
     //horizontal
     rect(width-1200, height-300, width-380, height-300);
     rect(width-1200, height-200, width-380, height-200);
     rect(width-1200, height-100, width-380, height-100);
     //vertical
     line(width-900, height-300, width-900, height);
     line(width-600, height-300, width-600, height);
     
     //draw buttons
     drawPlayButton();
     drawStopButton();
     drawRefreshButton();
  }
  
  public void snapToGrid() {
    for (Tweet tweet : activeTweetList) {
      if (tweet.isActive()) {
        float xLoc = mouseX;
        // X location
        if (xLoc >= 0 && xLoc < width - 900) {
          tweet.setX(width-1200);
        }
        if (xLoc >= width-900 && xLoc < width - 600) {
          tweet.setX(width-900);
        }
        if (xLoc >= width-600 && xLoc < width - 300) {
          tweet.setX(width-600);
        }
        float yLoc = mouseY;
        // Y location
        if (yLoc <= height && yLoc > height - 100) {
          tweet.setY(height-100);
        }
        if (yLoc <= height-100 && yLoc > height - 200) {
          tweet.setY(height-200);
        }
        if (yLoc <= height-200 && yLoc > height - 300) {
          tweet.setY(height-300);
        }
      }
    }
  }
  
//  public void setupCamera(TweetSeq tweetSeq) {
//      String[] cameras = Capture.list();
//  
//      if (cameras.length == 0) {
//        println("There are no cameras available for capture.");
//        exit();
//      } else {
//        println("Available cameras:");
//        for (int i = 0; i < cameras.length; i++) {
//          println(cameras[i]);
//        }
//        cam = new Capture(tweetSeq, 1280, 720);
//        cam.start();     
//      } 
//  }
  
  public void drawTimeIndicator() {
    stroke(255,0,0);
    line((float) tempo, height-300, (float) tempo, height);
    if (playing) {
      updateTimeIndicator();
    }
  }
  
  private void updateTimeIndicator() {
     DateTime temp = new DateTime();
     Period period = new Period(dateTime, temp);
     double time = (double) period.getMillis();
     time = time/1000;
     println(time);
     if (time == 0.0) time = 1;
     if (time > 1.0) time = 1;
     println(time);
     println("tempo" + tempo);
     tempo += (double) time*35;
     dateTime = temp;
     println("tempo" + tempo);
     if (tempo > width-300) {
       resetTimeIndicator();
     }
  }
  
  private void resetTimeIndicator() {
     tempo = (double) width-1200; 
     resetTweets();
  }
  
  public void retrieveTweets() {
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
      tweetList.clear();
      for (Status status : result.getTweets()) {
        tweetList.add(new Tweet(status, 180, color(255, 255, 255), width-Constants.TWEET_WIDTH, counter, 
          Constants.TWEET_WIDTH, Constants.TWEET_HEIGHT));
        System.out.println("@" + status.getUser().getScreenName() + ":" + status.getText());
        counter += Constants.TWEET_HEIGHT + 2;
      }
    } catch (TwitterException e) {
      e.printStackTrace();
    }
  }
  
  public void updateTweet() {
    if (activeTweetList != null && activeTweetList.get(activeTweetList.size()-1) != null)  {
      for (Tweet tweet : activeTweetList) {
        if (tweet.mouseIn(mouseX, mouseY) && tweet.isActive()) {
          tweet.updateLocation(xOffset, yOffset);
        }
      }
    }
  }
  
  public void buttonPressed() {
    //play/pause
    if ((mouseX > 5 && mouseX < 55 
        && mouseY > 5 && mouseY < 55)) {
      if (playing) {
        playing = false;
        pauseSamples();
      } else {
        playing = true;
        playSamples();
      }
    }
    //stop
    if ((mouseX > 65 && mouseX < 115 
        && mouseY > 5 && mouseY < 55)) {
        playing = false;
        stopSamples();
        resetTimeIndicator();
    }
    //refresh
    if ((mouseX > Constants.APPLICATION_WIDTH-360 && mouseX < Constants.APPLICATION_WIDTH-310)
         && (mouseY > 5 && mouseY < 55)) {
       retrieveTweets();
    }
  }
  
  public void setOffset() {
    int counter = 0;
    for (Tweet tweet : tweetList) {
      if (tweet.mouseIn(mouseX, mouseY)) {
        xOffset = mouseX - tweet.getX();
        yOffset = mouseY - tweet.getY();
        addActiveTweet(counter);
        break;
      }
      counter++;
    }
    
    for (Tweet tweet : activeTweetList) {
      if (tweet.mouseIn(mouseX, mouseY)) {
        xOffset = mouseX - tweet.getX();
        yOffset = mouseY - tweet.getY();
        tweet.setActive();
        break;
      }
    }
  }
  
  public void deactivateTweet() {
    for (Tweet tweet : activeTweetList)
      tweet.setInactive();
  }
  
  public void playSample() {
    for (Tweet tweet : tweetList) {
      if (tweet.mouseIn(mouseX, mouseY)) {
        tweet.playNote(out);
        break;
      }
    }
  }
  
  private void stopSamples() {
    for (Tweet tweet : activeTweetList)
      tweet.stopSample();
  }
   
  private void pauseSamples() {
    for (Tweet tweet : activeTweetList)
      tweet.pauseSample();
  }
  
  private void playSamples() {
    for (Tweet tweet : activeTweetList) {
      if (tempo > tweet.getX() && tempo < tweet.getX() + Constants.TWEET_WIDTH && !tweet.isPlaying())
        tweet.resumeSample();
    }
  }

  public void drawTweets() { 
     strokeWeight(1);
     stroke(0);
     //draw list
     for (Tweet tweet : Reversed.reversed(tweetList)) {
       tweet.drawTweet();
       testStopped(tweet);
     }
     //draw active tweets
     for (Tweet tweet : activeTweetList) {
       tweet.drawTweet();
       if (tempo > width-1200 && !tweet.wasPlayed() && tweet.collision(tempo) && !tweet.isPlaying()) {
         //tweet.playNote(this.out);
         tweet.playSample(this.minim);
       }
       testStopped(tweet);
     }
  }
  
  private void testStopped(Tweet tweet) {
     if (tweet.noteStopped()) {
       tweet.setPlaying(false);
       tweet.setPlayed(true);
       tweet.resetNote();
     }
     if (tweet.sampleStopped()) {
       tweet.setPlaying(false);
       tweet.setPlayed(true);
     }
  }
  
  private void drawPlayButton() {
    //play/pause button
    stroke(120);
    fill(color(255, 255, 255, 120));
    rect(5, 5, 50, 50);
    stroke(120);
    fill(color(255, 255, 255));
    if (playing) {
      rect(15, 10, 10, 40);
      rect(35, 10, 10, 40);
    } else {
      triangle(10, 10, 10, 50, 50, 30);
    }
  }
  
  private void drawStopButton() {  
    //stop button
    stroke(120);
    fill(color(255, 255, 255, 120));
    rect(65, 5, 50, 50);
    stroke(120);
    fill(color(255, 255, 255));
    rect(70, 10, 40, 40);
  }
  
  private void drawRefreshButton() {
    stroke(120);
    fill(color(255, 255, 255, 120));
    rect(Constants.APPLICATION_WIDTH-360, 5, 50, 50);
    stroke(120);
    fill(color(255, 255, 255));
    ellipse(Constants.APPLICATION_WIDTH-335, 30, 40, 40);
  }
  
  private void resetTweets() {
    for (Tweet tweet : activeTweetList)
      tweet.setPlayed(false);
  }
  
  public void addActiveTweet(int location) {
    Tweet tweet = tweetList.get(location);
    Tweet temp = new Tweet(tweet.getStatus(), 180, color(255, 255, 255), tweet.getX(), tweet.getY(), 
          Constants.TWEET_WIDTH, Constants.TWEET_HEIGHT);
    temp.setActive();
    activeTweetList.add(temp);
  }
  
  public void removeActiveTweet() {
    if (mouseX < Constants.APPLICATION_WIDTH-300) {
      int counter = activeTweetList.size();
      for (Tweet tweet : Reversed.reversed(activeTweetList)) {
        counter--;
        if (tweet.mouseIn(mouseX, mouseY))
          break;
      }
      if (counter < activeTweetList.size())
        activeTweetList.remove(counter);
    }
  }
}
