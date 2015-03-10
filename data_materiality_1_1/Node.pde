

class Node extends FCircle {

  boolean rectified = false;
  Oscil       wave;
  
  Line ampline;
  Pan pan;

  Node (float size) {
    super(size);
    
    pan = new Pan(-1);
    pan.patch(out);
    
    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    
    wave = new Oscil( Frequency.ofMidiNote( random( 25,100) ).asHz(), 0.1f, Waves.TRIANGLE );
    
    // patch the Oscil to the output
    wave.patch( pan );
    
    //pitchline = new Line();
    //pitchline.patch(wave.frequency);
    
    ampline = new Line();
    ampline.patch(wave.amplitude);
    ampline.activate(0,0,0);
    
  }
  
  void destroy() {
    
    try {
      wave.unpatch(pan);
      pan.unpatch(out);
      wave = null;
      ampline = null;
      pan = null;
    } catch(Exception e) {
    }
  }

  void draw(PGraphics g) {
    preDraw(g);
    ellipse(0, 0, this.getSize(), this.getSize());
    //text( this.vel(), this.getSize() * 0.5 + 5, this.getSize() * 0.5);

    //wave.setAmplitude(map(vel(), 0, 5000, 0, 1));
    //line.setEndAmp(map(vel(), 0, 5000, 0, 1));
    
    //float[] samples = pitchline.getLastValues();
    //pitchline.activate(0.1, samples[samples.length-1], map(vel(), 0, 5000, 400, 8000) );
    
    float [] samples = ampline.getLastValues();
    ampline.activate(0.1, samples[samples.length-1], map(vel(), 0, 5000, 0, 0.05) );

    schmitt(vel());
    
    pan.setPan(map(this.getX(), 0, width, -1, 1));
    


    if (rectified) {
      stroke(255, 0, 0);
    } else {
      stroke(0, 255, 0);
    }

    noFill();
    ellipse(0, 0, vel(), vel());
    postDraw(g);
  }

  float vel() {
    return dist(0,0,this.getVelocityX(),this.getVelocityY());
    //return this.getVelocityX();
    //return this.getVelocityX(),this.getVelocityY());
  }

  float log10 (float x) {
    return (log(x*100) / log(10));
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

