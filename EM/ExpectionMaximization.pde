/** Estimate the Gaussian Mixture Model using the EM (Expectation Maximization) Algorithm */;

class GMMEstimator {
  
  /* number of gaussians in the GMM */
  private int nGaussians;
  
  private GaussianMixtureModel gmm;
  
  private GMMViewer viewer;
  
  /* maximum iterations */
  private int maxIterations, iter = 0;
  
  /* observed data */
  private int nObservations;
  private float[] observations;
  
  /* parameters to be estimated: means and stddevs of each gaussian */
  private float[] means;
  private float[] stds;
  
  private float[] alpha; // alpha[k] is the probability that an observation comes from the k-th gaussian
  private float[][] respn; // respn[j][k] is the responsiveness of the k-th gaussian to the j-th observation 
  
  public GMMEstimator(int nGaussians, float[] samples, int maxIter) {
    this.nGaussians = nGaussians;
    observations = samples;
    nObservations = samples.length;
    maxIterations = maxIter;
    
    initParameters();
  }
  
  public GMMEstimator(GaussianMixtureModel gmm, int maxIter) {
    this(gmm.getNGaussians(), gmm.getObservations(), maxIter);
    this.gmm = gmm;
    this.viewer = new GMMViewer(gmm.getMeanVals(), gmm.getStddevVals(), gmm.getObservations());
  }
  
  public void iterate() {
    viewer.render();
    if (iter < maxIterations) {
      calcResponsiveness();
      updateParameters();
      iter++;
    }
    
  }
  
  /* E-step */ 
  private void calcResponsiveness() {
    for (int j = 0; j < nObservations; ++j) {
      float sum = 0;
      float[] phi = new float[nGaussians];
      for (int k = 0; k < nGaussians; ++k) {
        phi[k] = getLikelyhoodGivenParams(observations[j], means[k], stds[k]);
        
        sum += alpha[k] *   phi[k];
      }
      for (int k = 0; k < nGaussians; ++k) {
        respn[k][j] = alpha[k] *   phi[k] / sum;
        // println("calcResponsiveness:" + alpha[k] + " " +  phi[k] + " " + sum);
      }  
    }
  }
  
  /* M-step */
  private void updateParameters() {
    viewer.updateEstimations(means, stds);
    for (int k = 0; k < nGaussians; ++k) {
      float sum1 = 0, sum2 = 0, sum3 = 0;
      for (int j = 0; j < nObservations; ++j) {
        sum1 += respn[k][j];
        sum2 += respn[k][j] * observations[j];
        sum3 += respn[k][j] * sq(observations[j] - means[k]);
        
      }
      stds[k] = sqrt(sum3 / sum1);
      means[k] = sum2 / sum1;
      alpha[k] = sum1 / nObservations; //<>//
      println("updateParameters: k = " + k + " alpha " + alpha[k] + " stddev " +  stds[k] + " mean " + means[k]);
    }
    
    
  }
  
  private void initParameters() {
    means = new float[nGaussians];
    stds  = new float[nGaussians];
    
    alpha = new float[nGaussians];
    respn = new float[nGaussians][nObservations];
    
    for (int k = 0; k < nGaussians; ++k) {
      //means[k] = width / 2;
      //stds[k] = width / 2;
      
      /* mean and stddev values of different Gaussian cannot be initialized with the same value, otherwise the k Gaussians would be the same at each iteration. */
      means[k] = random(width * 0.1, width * 0.9);
      stds[k] = random(width * 0.1, width * 0.3);
      
      alpha[k] = 1. / nGaussians;
      for (int j = 0; j < nObservations; ++j) {
        respn[k][j] = 1. / nGaussians;
      }
    }
  }
  
  /* calculate phi(yi | theta), where phi is the gaussian function and theta is mu and sigma */
  private float getLikelyhoodGivenParams(float yi, float mu, float sigma) {
    float p = 1 / (sqrt(2 * PI) * sigma) * exp(-sq(yi - mu) / (2 * sigma * sigma));
    return p;
  } 
}
