class GaussianMixtureModel {
  private int nGaussians;
  
  private float[] muVals;
  private float[] sigmaVals;
  
  private int nObservations;
  private float[] observations;
  
  
  public GaussianMixtureModel(int nGaussians, int nObservations) {
    this.nGaussians = nGaussians;
    this.nObservations = nObservations;
    
    initDistributions();
    initObservations();
  }
  
  public float[] getObservations() {
    if (observations == null) initObservations();
    return observations;
  }
  
  public int getNGaussians() { return nGaussians; }
  
  public float[] getMeanVals() { return muVals; }
  
  public float[] getStddevVals() { return sigmaVals; }
  
  
  /* generate several independent gaussian distributions to compose the GMM. */ 
  private void initDistributions () {
    muVals = existsOrMake(muVals, nGaussians);
    sigmaVals = existsOrMake(sigmaVals, nGaussians);
 
    float muStart = width * 0.1, muEnd = width * 0.9;
    float muRange = (muEnd - muStart) / nGaussians;
    
    for (int k = 0; k < nGaussians; ++k) {
      
      muVals[k] = random(muStart + k * muRange, muStart + (k + 1) * muRange);
      sigmaVals[k] = random(width * 0.1, width * 0.2);
    }
  }
  
  /* generate observed data by sampling from the GMM. */
  private void initObservations() {
    observations = existsOrMake(observations, nObservations);
    
    for (int i = 0; i < nObservations; ++i) {
      int idx = (int) random(nGaussians);
      observations[i] = gaussianSampling(muVals[idx], sigmaVals[idx]);
    }
  }
  
  private float gaussianSampling(float mu, float sigma) {
    float y = randomGaussian();
    return y * sigma + mu;
  }
  
  private float[] existsOrMake(float[] arr, int len) {
    if (arr == null) {
      arr = new float[len];
    }
    return arr;
  }
}
