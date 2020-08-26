class GaussianDistribution2D {
  private float meanX, meanY;
  private float stdX, stdY;
  private int nContourLevels;
  
  private float[][] contourRadius;
  
  private static final float CONTOUR_HIGH = 0.90;
  private static final float CONTOUR_LOW  = 0.03;
  
  protected GaussianDistribution2D() {
    this(0., 0., 0., 0., 10);
  }
  protected GaussianDistribution2D(float muX, float muY, float sigmaX, float sigmaY, int n) {
    this.meanX = muX;
    this.meanY = muY;
    this.stdX = sigmaX;
    this.stdY = sigmaY;
    this.nContourLevels = n;
    
    getContour();
  }
  
  public void update(float muX, float muY, float sigmaX, float sigmaY) {
    this.meanX = muX;
    this.meanY = muY;
    this.stdX = sigmaX;
    this.stdY = sigmaY;
    
    getContour();
  }
  
  public void render(color c) {
    pushStyle();
    pushMatrix();
    
    translate(meanX, meanY);
    //noStroke();
    //fill(c, 20);
    noFill();
    
    for (int i = 0; i < nContourLevels; ++i) {
      stroke(c, 20 + i * 15);
      ellipse(0, 0, contourRadius[i][0], contourRadius[i][1]);
    }
    
    popMatrix();
    popStyle();
  }
  
  
  
  private void getContour() {
    contourRadius = new float[nContourLevels][2];
    float contourIntervals = (CONTOUR_HIGH - CONTOUR_LOW) / (nContourLevels - 1);
    for (int i = 0; i < nContourLevels; ++i) {
      contourRadius[i][0] = getDeltaXAt(CONTOUR_LOW + contourIntervals * i, stdX);
      contourRadius[i][1] = getDeltaXAt(CONTOUR_LOW + contourIntervals * i, stdY);
      println(contourRadius[i][0] + ", " + contourRadius[i][1]);
    }
  }
  
  /**get the value of (x-mu) when the magnitude of a gaussian distribution f(x) decreases from max to p.
   *@Params:
     p: float in range [0, 1]
   */
  private float getDeltaXAt(float p, float sigma) {
    return sqrt(-log(p) * 2) * sigma;
  }
  
  /** deprecated since static inner classes are not allowed in processing
    
  static class Builder {
    private float meanX, meanY;
    private float stdX, stdY;
    private int nContourLevels = 10;
    
    public Builder() { }
    
    public Builder mean(float x, float y) { 
      this.meanX = x;
      this.meanY = y;
      return this;
    }
    
    public Builder std(float x, float y) {
      this.stdX = x;
      this.stdY = y;
      return this;
    }
    
    public Builder contourLevel(int n) {
      this.nContourLevels = n;
      return this;
    }
    
    public GaussianDistribution2D build() {
      return new GaussianDistribution2D(meanX, meanY, stdX, stdY, nContourLevels);
    }
  }
  */
  
}
