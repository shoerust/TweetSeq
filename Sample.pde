import ddf.minim.*;

public class Sample {
  Minim minim;
  AudioPlayer sample;
  private BeatDetect beat;
  private BeatListener bl;
  private Particles particles;
  
  public Sample(Minim minim, String fileName,Particles particles) {
    println(fileName);
    sample = minim.loadFile("samples/" + fileName);
    
    beat = new BeatDetect(sample.bufferSize(), sample.sampleRate());
    bl = new BeatListener(beat, sample);  
    this.particles = particles;
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
    if (beat.isKick()){
    particles.speed();
    return true;
    }
    return false;
  }
  public boolean isHat() {
    if (beat.isHat()){
    particles.speed();
    return true;
    }
    return false;
  }
  public boolean isSnare() {
    if (beat.isSnare()){
    particles.speed();
    return true;
    }
    return false;
  }
}
