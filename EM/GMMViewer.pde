class GMMViewer {
  private int nGaussians;
  
  // real parameters 
  private float[] mean;
  private float[] std;
  
  private float[] mixAltitude;
  
  // estimated parameters
  private float[] meanEst; 
  private float[] stdEst;
  
  private float[] mixAltitudeEst;
  
  // observed data
  private float[] samples;
  
  // x-range for draw()
  private int viewRangeX;
  
  // constants for rendering
  private static final float BOTTOM_MARGIN = 0.25;
  private static final int LINE_WIDTH = 3;
  private static final int SQUARE_SIZE = 5;
  
  private color[] COLORS = {#F44336, #2196F3, #CDDC39, #7C4DFF, #009688,};
  
  
  
  public GMMViewer(float[] mean, float[] std, float[] samples) {
    this(mean, std, samples, width);
  }
  
  public GMMViewer(float[] mean, float[] std, float[] samples, int viewRangeX) {
    nGaussians = mean.length;
    this.mean = mean;
    this.std = std;
    
    this.samples = samples;
    this.viewRangeX = viewRangeX;
    
    init();
  }
  
  
  private void init() {
    meanEst = new float[nGaussians];
    stdEst = new float[nGaussians];
    
    mixAltitude = getMixDistribution(mixAltitude, mean, std);
    mixAltitudeEst = getMixDistribution(mixAltitudeEst, meanEst, stdEst);
    
  }
  
  public void render() {
    pushStyle();
    pushMatrix();
    
    renderLegends();
    renderObservations();
    renderRealMixDistribution();
    renderEstimatedMixDistribution();
    
    
    popMatrix();
    popStyle();
  }
  
  private void renderRealMixDistribution() {
    //println("renderRealMixDistribution");
    renderDistibution(mixAltitude, COLORS[0]);
  }
  
  private void renderEstimatedMixDistribution() {
    //println("renderEstimatedMixDistribution");
    renderDistibution(mixAltitudeEst, COLORS[1]);
  }
  
  private void renderDistibution(float[] dist, color c) {
    pushStyle();
    stroke(c);
    //fill(c);
    strokeWeight(LINE_WIDTH);
    for (int i = 1; i < dist.length - 1; ++i) {
      line(i-1, dist[i-1], i, dist[i]);
      //point(i, dist[i]);
    }
    popStyle();
  }
  
  private void renderObservations() {
    pushStyle();
    noFill();
    stroke(10);
    rectMode(CENTER);
    for (int j = 0; j < samples.length; ++j) {
      pushMatrix();
      
      translate(samples[j], height * (1 - BOTTOM_MARGIN));
      rotate(PI/4);
      square(0, 0, SQUARE_SIZE);
      
      popMatrix();
    }
    popStyle();
    
  }
  
  private void renderLegends() {
    float startAtX = 0.72 * width;
    float startAtY = height * 0.1 + 10;
    float inset = 20;
    float fontSize = inset * 0.8;
    
    pushStyle();
    strokeWeight(LINE_WIDTH);
    stroke(COLORS[0]);
    line(startAtX, startAtY, startAtX + 20, startAtY);
    
    fill(50);
    textSize(fontSize);
    text("REAL", startAtX + 30, startAtY + fontSize / 2);
    startAtY += inset;
    
    stroke(COLORS[1]);
    line(startAtX, startAtY, startAtX + 20, startAtY);
    text("ESTIMATION", startAtX + 30, startAtY + fontSize / 2);
    startAtY += inset;
    
    noFill();
    stroke(10);
    text("SAMPLES", startAtX + 30, startAtY + fontSize / 2);
    
    pushMatrix();
    noFill();
    strokeWeight(1);
    translate(startAtX + SQUARE_SIZE / 2, startAtY - SQUARE_SIZE / 2);
    rotate(PI/4);
    square(0, 0, SQUARE_SIZE);
    popMatrix();
    
    popStyle();
  }
  
  public void updateEstimations(float[] meanEst, float[] stdEst) {
    this.meanEst = meanEst;
    this.stdEst = stdEst;
    
    mixAltitudeEst = getMixDistribution(mixAltitudeEst, meanEst, stdEst);
  }
  
  /* calculate phi(yi | theta), where phi is the gaussian function and theta is mu and sigma */
  private float getLikelyhoodGivenParams(float yi, float mu, float sigma) {
    float p = 1 / (sqrt(2 * PI) * sigma) * exp(-sq(yi - mu) / (2 * sigma * sigma));
    return p;
  } 
  
  private float[] getMixDistribution(float[] dist, float[] mu, float[] sigma) {
    if (dist == null) dist = new float[viewRangeX];
    
    for (int i = 0; i < viewRangeX; ++i) {
      float mixAltitude = 0.;
      for (int k = 0; k < nGaussians; ++k) {
        mixAltitude += getLikelyhoodGivenParams(i, mu[k], sigma[k]);
      }
      dist[i] = height * (1 - BOTTOM_MARGIN - mixAltitude * 30);
      
    }
    
    return dist;
  }
  
  
}
  
