public class Sequencer {
  private Twitter twitter;
  private Capture cam;
  private float tempo;
  private DateTime dateTime;
  private float currentTime;
  private ArrayList<Tweet> list;
  private Minim minim;
  private AudioOutput out;
  private float xOffset;
  private float yOffset;
  
  public Sequencer() {
      dateTime = new DateTime();
      currentTime = dateTime.getMillis();
      tempo = 0.0;
      list = new ArrayList<Tweet>();
      minim = new Minim(this);
      out = minim.getLineOut( Minim.MONO, 2048 );
  }
  
  public Capture getCamera() {
    return this.cam;
  }
  
  public void drawSequencer() {
     background(255);
     stroke(0);
     if (cam.available() == true) {
       cam.read();
     }
     image(cam, 0, 0);
     strokeWeight(4);
     smooth(8);
     //draw border lines
     line(width-300, 0, width-300, height);
     line(0, height-300, width-300, height-300);
     
     //draw sequencer
     strokeWeight(3);
     line(0, height-300, width-300, height-300);
     line(0, height-200, width-300, height-200);
     line(0, height-100, width-300, height-100);
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
     //draw index
     stroke(255,0,0);
     line(tempo, height-300, tempo, height);
     currentTime = dateTime.getMillis() - currentTime;
     //println("CurrentTime: " + currentTime);
     //println("Framerate: " + frameRate);
     //println("Divided: " + frameRate/currentTime);
     if (currentTime == 0) currentTime = 1;
     tempo += ((frameRate)/currentTime)/2;
     if (tempo > width-300) tempo = 0; 
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
        list.add(new Tweet(status, 180, color(255, 255, 255), width-300, counter, 
          Constants.TWEET_WIDTH, Constants.TWEET_HEIGHT));
        System.out.println("@" + status.getUser().getScreenName() + ":" + status.getText());
        counter += 83;
      }
    } catch (TwitterException e) {
      e.printStackTrace();
    }
  }
  
  public void updateTweet() {
    if (list.get(0) != null)  {
      list.get(0).updateLocation(xOffset, yOffset);
    }
  }
  
  public void setOffset() {
    int counter = 0;
    for (Tweet tweet : list) {
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
     for (Tweet tweet : Reversed.reversed(list)) {
       tweet.drawTweet();
       if (tweet.collision(tempo) && !tweet.isPlaying()) {
         tweet.playNote(this.out);
       }
       if (tweet.noteStopped()) {
         tweet.setPlaying(false);
         tweet.resetNote();
       }
     }
  }
  
  /**
   * We move the active element to the beginning of the ArrayList
   * to ensure we detect the move the correct tweet when 2 crossover.
   */
  public void swapElements(int location) {
    Tweet tempTweet = list.get(0);
    list.set(0, list.get(location));
    list.set(location, tempTweet);
  }
}
