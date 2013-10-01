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
  private boolean isSelected;
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
    this.isSelected = false;
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
  public boolean isSelected() { return this.isSelected; }
  
  public boolean mouseIn(float x, float y) {
    if (this.xDifference == 0 && this.yDifference == 0) {
      xDifference = x - this.x;
      yDifference = y - this.y;
    }
    return (x > this.x && x < (this.x + this.tweetWidth) &&
            y > this.y && y < (this.y + this.tweetHeight));
  }
  
  public void updateLocation(float x, float y) {
      this.x = x-50;
      this.y = y-50;
      xDifference = x - this.x;
      yDifference = y - this.y;
      println(this.x + " " + this.y + " " + this.xDifference + " " + this.yDifference);
  }
  
}
