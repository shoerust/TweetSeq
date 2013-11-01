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
      tempo = 0.0;
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
     if (cam.available() == true) {
       cam.read();
     }
     image(cam, 0, 0);
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
     rect(0, height-300, width-300, height-300);
     rect(0, height-200, width-300, height-200);
     rect(0, height-100, width-300, height-100);
     
     //draw buttons
     drawPlayButton();
     drawStopButton();
     drawRefreshButton();
  }
  
  public void setupCamera(TweetSeq tweetSeq) {
      String[] cameras = Capture.list();
  
      if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
      } else {
        println("Available cameras:");
        for (int i = 0; i < cameras.length; i++) {
          println(cameras[i]);
        }
        cam = new Capture(tweetSeq, 1280, 720);
        cam.start();     
      } 
  }
  
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
     tempo += time*36;
     dateTime = temp;
     println("tempo" + tempo);
     if (tempo > width-300) {
       resetTimeIndicator();
     }
  }
  
  private void resetTimeIndicator() {
     tempo = 0; 
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
      activeTweetList.get(activeTweetList.size()-1).updateLocation(xOffset, yOffset);
    }
  }
  
  public void buttonPressed() {
    //play/pause
    if ((mouseX > 5 && mouseX < 55 
        && mouseY > 5 && mouseY < 55)) {
      if (playing)
        playing = false;
      else
        playing = true;
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
    for (Tweet tweet : tweetList)
      tweet.stopSample();
  }
//  
//  private void pauseSamples() {
//    for (Tweet tweet : tweetList)
//      tweet.pauseSample();
//  }

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
       if (!tweet.wasPlayed() && tweet.collision(tempo) && !tweet.isPlaying()) {
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
    activeTweetList.add(new Tweet(tweet.getStatus(), 180, color(255, 255, 255), tweet.getX(), tweet.getY(), 
          Constants.TWEET_WIDTH, Constants.TWEET_HEIGHT));
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
