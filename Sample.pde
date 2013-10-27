import ddf.minim.*;

public class Sample {
  Minim minim;
  AudioPlayer sample;
  
  public Sample(Minim minim, String fileName) {
    println(fileName);
    sample = minim.loadFile("samples/" + fileName);
  }
  
  public boolean stopped() {
    if (sample != null)
      return sample.isPlaying();
    else
      return false;
  }
  
  void stop() {
    sample.close();
  }
  
  public void playSample() {
    sample.play();
  }
}
