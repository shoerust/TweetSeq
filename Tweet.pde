class Tweet {
  private Status status;
  private float alpha;
  private float x;
  private float y;
  private float padding = 5;
  color c;
  
  public Tweet(Status status, float alpha, color c, float x, float y) {
    this.status = status;
    this.alpha = alpha;
    this.c = c;
    this.x = x;
    this.y = y;
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
}
