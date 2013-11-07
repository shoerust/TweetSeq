import ddf.minim.*;

public class Sample {
  Minim minim;
  AudioPlayer sample;
  BeatDetect beat;
  BeatListener bl;
  
  public Sample(Minim minim, String fileName) {
    println(fileName);
    sample = minim.loadFile("samples/" + fileName);
    
    beat = new BeatDetect(sample.bufferSize(), sample.sampleRate());
    bl = new BeatListener(beat, sample);  
  }
  
  public boolean stopped() {
    if (sample != null)
      return sample.isPlaying();
    else
      return false;
  }
  
  public void stopSample() {
    sample.pause();
    sample.rewind();
  }
  
  public void pauseSample() {
    sample.pause();
  }
  
  public void stop() {
    sample.close();
  }
  
  public void playSample() {
    sample.play();
  }
  
  
    public boolean isKick() {
   return beat.isKick();
  }
  public boolean isHat() {
    return beat.isHat();
  }
  public boolean isSnare() {
    return beat.isSnare();
  }
}
