public class Note implements AudioSignal
{
     private float freq;
     private float level;
     private float alph;
     private SineWave sine;
     private AudioOutput out;
     
     Note(float pitch, float amplitude)
     {
         freq = pitch;
         level = amplitude;
         alph = 0.955;  // Decay constant for the envelope
     }

     void updateLevel()
     {
         // Called once per buffer to decay the amplitude away
         level = level * alph;
         sine.setAmp(level);
         
         // This also handles stopping this oscillator when its level is very low.
         if (level < 0.001) {
             this.out.removeSignal(this);
         }
         // this will lead to destruction of the object, since the only active 
         // reference to it is from the LineOut
     }
     
     void generate(float [] samp)
     {
         // generate the next buffer's worth of sinusoid
         sine.generate(samp);
         // decay the amplitude a little bit more
         updateLevel();
     }
     
    // AudioSignal requires both mono and stereo generate functions
    void generate(float [] sampL, float [] sampR)
    {
        sine.generate(sampL, sampR);
        updateLevel();
    }
    
    void addNote(AudioOutput out) {
       sine = new SineWave(freq, level, out.sampleRate());
       this.out = out;
       this.out.addSignal(this);
    }
    
    public boolean stopped() {
      return level < 0.001;
    }

}
