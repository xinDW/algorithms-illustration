import java.util.Arrays;
import java.util.List;
import java.util.LinkedList;
import java.util.ArrayList;

class DecisionTree {
  private IrisData dataset;
   
  private int nFeatures;
  private int nSamples;
  private int nClasses;
  
  private List<LinkedList<Float>> partitions;
  
  public DecisionTree(IrisData dataset) {
    this.dataset = dataset;
    this.nSamples = dataset.getSize();
    this.nFeatures = dataset.N_FEATURES;
    this.nClasses = dataset.N_CLASSES;
    init();
  }
  
  private void init() {
    float[][] features = new float[nFeatures][nSamples];
    partitions = new ArrayList<LinkedList<Float>>();
    for (int i = 0; i < nFeatures; ++i) {
      partitions.add(new LinkedList<Float>());
    }
    
    int itemIdx = 0;
    for (Iris sample : dataset.allItems()) {
      int featIdx = 0;
      for (float f : sample.features()) {
        features[featIdx++][itemIdx] = f;
      }
      itemIdx++;
    }
    
    for (int i = 0; i < nFeatures;  ++i) {
      Arrays.sort(features[i]);
      for (int j = 0; j < nSamples - 1; ++j) {
        float p = (features[i][j] + features[i][j+1]) / 2;
   
        if (partitions.get(i).size() == 0 || partitions.get(i).getLast() != p)
          partitions.get(i).add(p); 
      }
    }
  }
  
  public Node generateTree() {
    Node root = new Node(nSamples);
    generateTreeRecursive(root);
    return root;
  }
  
  private void generateTreeRecursive(Node node) {
    if (node == null || node.empty()) return;
    
    print("generateTreeRecursive");
    for (int i : node.getSamplesIndices())
      print(" " + i); 
    println();
    
    float maxGain = -1e10;
    int optimalPartitionFeatIdx = -1;
    float optimalPartitionPoint = 0;
    
    /* traverse to find the optimal partition feature and the optimal partition point; */
    for (int k = 0; k < nFeatures; ++k) {
      println(partitions.get(k).size() + " partitions @feat" + k);
      for (float p : partitions.get(k)) {
        
        float gain = calcInformationGain(node, k, p);
        
        if (gain > maxGain) {
          maxGain = gain;
          optimalPartitionFeatIdx = k;
          optimalPartitionPoint = p;
          println("gain = " + gain + "@feat" + k + " @partition" + p);
        }       
      }
    }
    println("optFeat: " + optimalPartitionFeatIdx + ", optPartition: " + optimalPartitionPoint);
    if (optimalPartitionFeatIdx > -1) {
      node = partitionNode(node, optimalPartitionFeatIdx, optimalPartitionPoint);
      partitions.get(optimalPartitionFeatIdx).remove(optimalPartitionPoint);
    }
    
    generateTreeRecursive(node.left);
    generateTreeRecursive(node.right);
  }
  
  public Node partitionNode(Node node, int partitionFeatIdx, float partitionPoint) {
    Node left = new Node(), right = new Node();
    
    List<Iris> data = dataset.allItems();
    for (int idx : node.samplesIndices) {
      Iris sample = data.get(idx);
      if (sample.features()[partitionFeatIdx] <= partitionPoint) 
        left.add(idx);
      else 
        right.add(idx);
    }
    
    if (!left.empty() && !right.empty()) {
      node.left = left;
      node.right = right;
    }
    
    return node;
     
  }
  
 
  private float calcInformationGain(Node node, int partitionFeatIdx, float partitionPoint) {
    float infoEntropy = calcInformationEntropy(node);
    node = partitionNode(node, partitionFeatIdx, partitionPoint);
    if (node.left == null || node.right == null || node.left.empty() || node.right.empty()) return 0;
    
    float leftWeight = node.left.size() / node.size();
    float rightWeight = node.right.size() / node.size();
    float conditionalEntropy =  leftWeight * calcInformationEntropy(node.left) + rightWeight * calcInformationEntropy(node.right);
    /* calculating the IG should not change the node itself, so make it as is. */
    node.pruning(); 
    
    return infoEntropy - conditionalEntropy;
  }
  
  
  private float calcInformationEntropy(Node node) {
    if (node == null || node.empty()) return 0;
    
    List<Iris> data = dataset.allItems();
    int[] stat = new int[nClasses];
    for (int idx : node.getSamplesIndices()) {
      int type = data.get(idx).type();
      stat[type]++;
    }
    
    float infoEntropy = 0;
    int nSamples = node.size();
    for (int num : stat) {
      float p = (float)num / nSamples;
      if (p != 0)
        infoEntropy += -1 * p * log(p);
    }
    
    return infoEntropy;
  }
  
  class Node {
    private List<Integer> samplesIndices; // indices of samples devided into the current node
    
    public Node left, right;
    
    public Node() { 
      samplesIndices = new ArrayList<Integer>();
    }
    
    public Node(int n) {
      this();
      for (int idx = 0; idx < n; ++idx)
        add(idx);
    }
    
    public void add(int idx) { samplesIndices.add(idx); }
    
    public List<Integer> getSamplesIndices() { return samplesIndices; }
   
    public boolean empty() { return samplesIndices.size() == 0; }
    
    public boolean isLeaf() { return (left == null) && (right == null); }
    
    public int size() { return samplesIndices.size(); }
    
    public void pruning() {
      left = null;
      right = null;
    }
  }
}
