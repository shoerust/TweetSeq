public class Tweet {
  private Status status;
  private float alpha;
  private float x;
  private float y;
  private float tweetWidth;
  private float tweetHeight;
  private float xDifference;
  private float yDifference;
  private float padding = 5;
  private boolean isPlaying;
  private ArrayList<Float> piano;
  private float pitch;
  private float amplitude;
  private Note note;
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
    this.isPlaying = false;
    this.pitch = 0;
    this.amplitude = 0.2;
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
    this.note = new Note(piano.get((int)random(0,16)), 0.2);
  }

  public float getAlpha() {
    return alpha;
  }
  
  public color getColor() {
    return c;
  }
  
  public void setAlpha(float alpha) {
    this.alpha = alpha;
  }
  
  public float getX() { return this.x; }
  public float getY() { return this.y; }
  public Status getStatus() { return this.status; }
  public float getPadding() { return this.padding; }
  public float getWidth() { return this.tweetWidth; }
  public float getHeight() { return this.tweetHeight; }
  public boolean isPlaying() { return this.isPlaying; }
  public void setPlaying(boolean playing) { this.isPlaying = playing; }
  
  public boolean mouseIn(float x, float y) {
    return (x > this.x && x < (this.x + this.tweetWidth) &&
            y > this.y && y < (this.y + this.tweetHeight));
  }
  
  public boolean collision(float x) {
      return (x > this.x && x < (this.x + this.tweetWidth) &&
              this.y > height-400);
  }
  
  public void updateLocation(float x, float y) {
      this.x = x-50;
      this.y = y-50;
  }
  
  public void playNote(AudioOutput out) {
    note.addNote(out);
    this.isPlaying = true;
  }
  
  public boolean noteStopped() {
    return note.stopped();
  }
  
  public void resetNote() {
    this.note = new Note(piano.get((int)random(0,16)), 0.2);
  }
  
}
