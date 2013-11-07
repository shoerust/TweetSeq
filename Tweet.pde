public class Tweet {
  private Status status;
  private float alpha;
  private float x;
  private float y;
  private float tweetWidth;
  private float tweetHeight;
  private float xDifference;
  private float yDifference;
  private float padding;
  private boolean isPlaying;
  private boolean wasPlayed;
  private boolean isActive;
  private ArrayList<Float> piano;
  private float pitch;
  private float amplitude;
  private Minim minim;
  private Particles particles;
  private Note note;
  private Sample sample;
  private ArrayList<String> sampleNames;
  private float kickOffset;
  private float snareOffset;
  private float hatOffset;
  color c;
  
  public Tweet(Status status, float alpha, color c, float x, float y, float tweetWidth, float tweetHeight) {
    this.status = status;
    this.alpha = alpha;
    this.c = c;
    this.x = x;
    this.y = y;
    this.tweetWidth = tweetWidth;
    this.tweetHeight = tweetHeight;
    this.xDifference = 0;
    this.yDifference = 0;
    this.kickOffset = 0;
    this.snareOffset = 0;
    this.hatOffset = 0;
    this.isPlaying = false;
    this.wasPlayed = false;
    this.amplitude = 0.2;
    this.padding = 5;
    File f = new File(sketchPath("samples"));
    sampleNames = new ArrayList<String>(Arrays.asList(f.list()));
    setupNote();
  }
  
  private void setupNote() {
    this.piano = new ArrayList<Float>();
    piano.add(new Float(262));
    piano.add(277.0);
    piano.add(294.0);
    piano.add(311.0);
    piano.add(330.0);
    piano.add(349.0);
    piano.add(370.0);
    piano.add(392.0);
    piano.add(415.0);
    piano.add(440.0);
    piano.add(466.0);
    piano.add(494.0);
    piano.add(523.0);
    piano.add(554.0);
    piano.add(587.0);
    piano.add(622.0);
    piano.add(659.0);
    this.pitch = this.calculatePitch();
    this.note = new Note(this.pitch, this.amplitude);
  }

  public float getAlpha() { return this.alpha; }
  public color getColor() { return this.c; }
  public void setAlpha(float alpha) { this.alpha = alpha; }
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  public void setX(float x) { this.x = x; }
  public void setY(float y) { this.y = y; }
  public Status getStatus() { return this.status; }
  public float getPadding() { return this.padding; }
  public float getWidth() { return this.tweetWidth; }
  public float getHeight() { return this.tweetHeight; }
  public boolean isPlaying() { return this.isPlaying; }
  public boolean wasPlayed() { return this.wasPlayed; }
  public void setPlaying(boolean playing) { this.isPlaying = playing; }
  public void setPlayed(boolean played) { this.wasPlayed = played; }
  public void setActive() { this.isActive = true; }
  public void setInactive() { this.isActive = false; }
  public boolean isActive() { return this.isActive; }
  
  public boolean mouseIn(float x, float y) {
    return (x >= this.x && x <= (this.x + this.tweetWidth) &&
            y >= this.y && y <= (this.y + this.tweetHeight));
  }
  
  public boolean collision(double x) {
      return (x >= this.x && x <= (this.x + this.tweetWidth) &&
              this.y >= height-300);
  }
  
  public void updateLocation(float x, float y) {
      this.x = mouseX - x;
      this.y = mouseY - y;
  }
  
  public void playNote(AudioOutput out) {
    note.addNote(out);
    this.isPlaying = true;
  }
  
  public void playSample(Minim minim,Particles particles) {
    this.minim = minim;
    this.particles = particles;
    sample = new Sample(this.minim, getSampleName(),particles);
    sample.playSample();
    this.isPlaying = true;
  }
  
  public void stopSample() {
    if (sample != null)
      sample.stopSample();
  }
  
  public void pauseSample() {
    if (sample != null)
      sample.pauseSample();
  }
  
  public void resumeSample() {
    if (sample != null)
      sample.playSample();
  }
  
  public boolean noteStopped() {
    return note.stopped();
  }
  
  public boolean sampleStopped() {
    if (sample != null)
      return sample.stopped();
    else
      return false;
  }
  
  private String getSampleName() {
     switch (status.getText().charAt(5)) {
      case 'a':
      case 'b':
        return sampleNames.get(3);
      case 'c':
        return sampleNames.get(4);
      case 'd':
        return sampleNames.get(5);
      case 'e':
      case 'f':
        return sampleNames.get(3);
      case 'g':
      case 'h':
        return sampleNames.get(4);
      case 'i':
      case 'j':
        return sampleNames.get(5);
      case 'k':
      case 'l':
        return sampleNames.get(6);
      case 'm':
        return sampleNames.get(7);
      case 'n':
        return sampleNames.get(8);
      case 'o':
        return sampleNames.get(9);
      case 'p':
      case 'q':
        return sampleNames.get(10);
      case 'r':
      case 's':
        return sampleNames.get(9);
      case 't':
        return sampleNames.get(3);
      case 'u':
        return sampleNames.get(4);
      case 'v':
        return sampleNames.get(5);
      case 'w':
        return sampleNames.get(3);
      case 'x':
      case 'y':
      case 'z':
        return sampleNames.get(4);
      default:
        return sampleNames.get(5);
    }
  }
  
  private float calculatePitch() {
    switch (status.getText().charAt(5)) {
      case 'a':
      case 'b':
        return piano.get(0);
      case 'c':
        return piano.get(1);
      case 'd':
        return piano.get(2);
      case 'e':
      case 'f':
        return piano.get(3);
      case 'g':
      case 'h':
        return piano.get(4);
      case 'i':
      case 'j':
        return piano.get(5);
      case 'k':
      case 'l':
        return piano.get(6);
      case 'm':
        return piano.get(7);
      case 'n':
        return piano.get(8);
      case 'o':
        return piano.get(9);
      case 'p':
      case 'q':
        return piano.get(10);
      case 'r':
      case 's':
        return piano.get(11);
      case 't':
        return piano.get(12);
      case 'u':
        return piano.get(13);
      case 'v':
        return piano.get(14);
      case 'w':
        return piano.get(15);
      case 'x':
      case 'y':
      case 'z':
        return piano.get(16);
      default:
        return piano.get(8);
    }
  }
  
  public void resetNote() {
    this.note = new Note(this.pitch, this.amplitude);
  }
  
  public void drawTweet() {
      if ( sample != null  )
       {
         if (sample.isSnare())
         {
         snareOffset = 100;
         }
         if (sample.isKick())
         {
         kickOffset = 100;
         }
         if (sample.isHat())
         {
         hatOffset = 100;
         }  
       }
    stroke(120);
    fill(getColor(), getAlpha());
    rect(getX(), getY(), Constants.TWEET_WIDTH, Constants.TWEET_HEIGHT, 20);
    if (snareOffset > 0)
    {
     snareOffset = snareOffset - 10; 
    }
    if (kickOffset > 0)
    {
     kickOffset = kickOffset - 10; 
    }
    if (hatOffset > 0)
    {
     hatOffset = hatOffset - 10; 
    }
    fill(hatOffset + 50, kickOffset + 50, snareOffset + 50);
    text("@" + getStatus().getUser().getScreenName() + "\n " 
      + getStatus().getText(), getX() + 50 + getPadding(), 
      getY() + getPadding(), 220, 85);
    PImage img = loadImage("output/" + getStatus().getUser().getScreenName() + ".jpeg");
    if (img == null) {
      img = loadImage(getStatus().getUser().getProfileImageURL(), "jpeg");
      img.save("output/" + getStatus().getUser().getScreenName() + ".jpeg");
    }
    image(img, getX() + getPadding(), getY() + getPadding() + 5);
  }
  
}
