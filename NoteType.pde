public class NoteType
{
  private float notelength;
  private String notepitch;
  private boolean noteplayed;
  
  public NoteType(float notelength)
  {
    this.notelength = notelength;
    notepitch = "C3"; //notepitch;
    noteplayed = false;
  }
  
  public NoteType(float notelength, String pitch)
  {
    this.notelength = notelength;
    this.notepitch = pitch;
    noteplayed = false;
  }
  
  public boolean getPlayed()
  {
    return noteplayed;
  }
  
  public float getLength()
  {
    return notelength;
  }
  public void setPlayed (boolean flag)
  {
    noteplayed = flag;
  }
  public String getPitch()
  {
    return notepitch;
  }
}
