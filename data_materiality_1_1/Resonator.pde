
class Resonator {

  Oscil wave;
  Line ampline;
  Line pitchline;
  Pan pan;
  ModulationSource mod;

  boolean rectified = false;

  Resonator(ModulationSource _mod) {
    this(_mod, Waves.SAW);
  }

  Resonator(ModulationSource _mod, Wavetable wt) {

    mod = _mod;
    
    pan = new Pan(-1);
    pan.patch(out);

    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    wave = new Oscil( Frequency.ofMidiNote( random( 25, 100) ).asHz(), 0.1f, wt );

    // patch the Oscil to the output
    wave.patch( pan );

    //pitchline = new Line();
    //pitchline.patch(wave.frequency);

    ampline = new Line();
    ampline.patch(wave.amplitude);
    ampline.activate(0, 0, 0);
  }

  void update() {
    //wave.setAmplitude(map(vel(), 0, 5000, 0, 1));
    //line.setEndAmp(map(vel(), 0, 5000, 0, 1));

    //float[] samples = pitchline.getLastValues();
    //pitchline.activate(0.1, samples[samples.length-1], map(vel(), 0, 5000, 400, 8000) );

    float [] samples = ampline.getLastValues();
    ampline.activate(0.1, samples[samples.length-1], mod.amp() );

    //schmitt(value());

    pan.setPan(map(mod.pan(), 0, width, -1, 1));
  }

  void destroy() {

    try {
      wave.unpatch(pan);
      pan.unpatch(out);
      wave = null;
      ampline = null;
      pan = null;
    } 
    catch(Exception e) {
    }
  }

  void schmitt(float val) {
    float thresh = 0.001;
    if (val > thresh) {
      rectified = true;
    } 
    if ( val < -thresh) {
      rectified = false;
    }
  }
}
