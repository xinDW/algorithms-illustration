float[][] mean;
float[][] std;

import java.util.*;

int nGroups = 2;
int nSamples = 30;
int maxIterations = 40;
GaussianMixtureModel gmm;
GMMEstimator estimator;



int sec;

void setup() {
  size(500, 500);
  
  gmm = new GaussianMixtureModel(nGroups, nSamples);
  estimator = new GMMEstimator(gmm, maxIterations);
  
  sec = 0;
  //initSampling();
  
}

void draw() {
  
  if (millis() / 1000 > sec) {
    background(255);
    estimator.iterate();
    sec++;
    saveFrame("EM-####.png");
  }
    
}
