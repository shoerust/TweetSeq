/**
 * The Note class uses minim to play a sine wave at a specified
 * frequency that deteriorates at a specified constant level 
 * over time.
 */
public class Note implements AudioSignal {
  private float frequency;
  private float level;
  private float alph;
  private SineWave sine;
  private AudioOutput out;
   
  public Note(float pitch, float amplitude) {
     frequency = pitch;
     level = amplitude;
     alph = 0.8; // decay value
  }
  
  public void updateLevel() {
     // Called once per buffer to decay the amplitude away
     level = level * alph;
     sine.setAmp(level);
     
     // Stop the oscillator when its level is very low.
     if (level < 0.001) {
         this.out.removeSignal(this);
     }
  }
     
  public void generate(float [] samp) {
    sine.generate(samp);
    updateLevel();
  }
   
  public void generate(float [] sampL, float [] sampR) {
    sine.generate(sampL, sampR);
    updateLevel();
  }
  
  public void addNote(AudioOutput out) {
   sine = new SineWave(frequency, level, out.sampleRate());
   this.out = out;
   this.out.addSignal(this);
  }
  
  public boolean stopped() {
    return level < 0.001;
  }

}
