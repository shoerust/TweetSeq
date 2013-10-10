public class Sequencer {
  private Twitter twitter;
  private Capture cam;
  private float tempo;
  private DateTime dateTime;
  private ArrayList<Tweet> tweetList;
  private Minim minim;
  private AudioOutput out;
  private float xOffset;
  private float yOffset;
  private boolean playing;
  
  public Sequencer() {
      dateTime = new DateTime();
      tempo = 0.0;
      tweetList = new ArrayList<Tweet>();
      minim = new Minim(this);
      out = minim.getLineOut( Minim.MONO, 2048 );
      playing = true;
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
        
        // The camera can be initialized directly using an 
        // element from the array returned by list():
        cam = new Capture(tweetSeq, 1280, 720);
        cam.start();     
      } 
  }
  
  public void drawTimeIndicator() {
    stroke(255,0,0);
    line(tempo, height-300, tempo, height);
    if (playing) {
      updateTimeIndicator();
    }
  }
  
  private void updateTimeIndicator() {
     DateTime temp = new DateTime();
     Period period = new Period(dateTime, temp);
     float time = period.getSeconds();
     if (time == 0.0) time = 1;
     tempo += time*4;
     dateTime = temp;
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
    if (tweetList.get(0) != null)  {
      tweetList.get(0).updateLocation(xOffset, yOffset);
    }
  }
  
  public void buttonPressed() {
    if ((mouseX > 5 && mouseX < 55 
        && mouseY > 5 && mouseY < 55)) {
      if (playing)
        playing = false;
      else
        playing = true;
    }
    if ((mouseX > 65 && mouseX < 115 
        && mouseY > 5 && mouseY < 55)) {
        playing = false;
        resetTimeIndicator();
    }
  }
  
  public void setOffset() {
    int counter = 0;
    for (Tweet tweet : tweetList) {
      if (tweet.mouseIn(mouseX, mouseY)) {
        xOffset = mouseX - tweet.getX();
        yOffset = mouseY - tweet.getY();
        swapElements(counter);
        break;
      }
      counter++;
    }
  }

  public void drawTweets() { 
     strokeWeight(1);
     stroke(0);
     for (Tweet tweet : Reversed.reversed(tweetList)) {
       tweet.drawTweet();
       if (!tweet.wasPlayed() && tweet.collision(tempo) && !tweet.isPlaying()) {
         tweet.playNote(this.out);
       }
       if (tweet.noteStopped()) {
         tweet.setPlaying(false);
         tweet.setPlayed(true);
         tweet.resetNote();
       }
     }
  }
  
  private void drawPlayButton() {
    //play/pause button
    stroke(120);
    fill(color(255, 255, 255, 120));
    rect(5, 5, 50, 50);
    stroke(120);
    fill(color(120, 120, 120, 120));
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
    fill(color(120, 120, 120, 120));
    rect(70, 10, 40, 40);
  }
  
  private void resetTweets() {
    for (Tweet tweet : tweetList)
      tweet.setPlayed(false);
  }
  
  /**
   * We move the active element to the beginning of the ArrayList
   * to ensure we detect the move the correct tweet when 2 crossover.
   */
  public void swapElements(int location) {
    Tweet tempTweet = tweetList.get(0);
    tweetList.set(0, tweetList.get(location));
    tweetList.set(location, tempTweet);
  }
}
