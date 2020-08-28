import java.util.List;
import java.util.ArrayList;
import java.util.Queue;
import java.util.LinkedList;

class TreeViewer {
  
  private DecisionTree.Node root;
  
  private int treeDepth;
  
  private float unitHeight;
  
  private List<Integer> nNodesPerLayer;
  
  private static final float VERTICAL_MARGIN_RATIO = 0.1;
  private static final float HORIZONTAL_MARGIN_RATIO = 0.2;
  
  private static final float LAYER_HEIGHT_INC_INDEX = 1.2;
  
  private static final int NODE_RADIUS = 10;
  
  private static final color NODE_COLOR = #8BC34A;
  private static final color LEFT_NODE_COLOR = #03A9F4;
  private static final color TEXT_COLOR = #303F9F;
  private static final color EDGE_COLOR = #000000;
  
  public TreeViewer(DecisionTree.Node root) {
    this.root = root;
    initTreeRendering();
  }
  
  public void render() {
    if (root == null) return;
    
    pushStyle();
    textSize(NODE_RADIUS);
    
    pushMatrix();
    
    translate(width / 5, height * VERTICAL_MARGIN_RATIO);
    renderRecursive(root, 0);
    popMatrix();
    popStyle();
    
  }
  
  private void renderRecursive(DecisionTree.Node node, int layer) {
    if (node == null) return;
   
    //float layerHeight = pow(LAYER_HEIGHT_INC_INDEX, treeDepth - layer - 1) * unitHeight;
    float layerHeight = (treeDepth - layer) * unitHeight;
    //float xDist = layerHeight * tan(radians(70 - layer * 2));
    float xDist = layerHeight;
    
    println("rendering layer" + layer + " height " + layerHeight);
    /* draw left sub-tree */
    if (node.left != null) {
      pushMatrix();
      stroke(EDGE_COLOR);
      line(0, 0, -xDist, layerHeight);
      translate(-xDist, layerHeight);
      renderRecursive(node.left, layer + 1);
      popMatrix();
    }
    
    
    /* draw right sub-tree */
    if (node.right != null) {
      pushMatrix();
      stroke(EDGE_COLOR);
      line(0, 0, xDist, layerHeight);
      translate(xDist, layerHeight);
      renderRecursive(node.right, layer + 1);
      popMatrix();
    }
    
    /* draw self. */
    if (node.isLeaf()) {
      fill(TEXT_COLOR);
      text(node.size(), NODE_RADIUS / 2, NODE_RADIUS / 2);
      fill(LEFT_NODE_COLOR);
    }
      
    else fill(NODE_COLOR);
    noStroke();
    ellipse(0, 0, NODE_RADIUS, NODE_RADIUS);
    
  }
  
  private int getTreeDepth() {
    int treeDepth = getDepthByDepthFirstTraverse(root);
    println("Tree depth : " + treeDepth);
    return treeDepth;
  }
  
  private int getDepthByDepthFirstTraverse(DecisionTree.Node node) {
    if (node == null) return 0;
    
    int leftDepth = getDepthByDepthFirstTraverse(node.left);
    int rightDepth = getDepthByDepthFirstTraverse(node.right);
    
    return 1 + Math.max(leftDepth, rightDepth);
  }
  
  private List<Integer> getNodesNumPerLayerByBreadthFirstTraverse() {
    if (root == null) return null;
    
    nNodesPerLayer = new ArrayList<Integer>();
    Queue<DecisionTree.Node> queue1 = new LinkedList<DecisionTree.Node>();
    Queue<DecisionTree.Node> queue2 = new LinkedList<DecisionTree.Node>();
    queue1.offer(root);
    
    while(!queue1.isEmpty()) {
      nNodesPerLayer.add(queue1.size());
      
      println("layer" + nNodesPerLayer.size() + " width " + queue1.size());
      while(!queue1.isEmpty()) {
        DecisionTree.Node node = queue1.poll();
        if (node.isLeaf()) continue;
        
        queue2.offer(node.left);
        queue2.offer(node.right);
      }
      
      queue1 = queue2;
      queue2 = new LinkedList<DecisionTree.Node>();
    }
    
    println(nNodesPerLayer.size());
    return nNodesPerLayer;
  }
  
  /* find out the optimal positions of each node on the screen. */
  private void initTreeRendering() {
    treeDepth = getTreeDepth();
    
    int nUnitsInHeight = 0;
    for (int i = 0; i < treeDepth; ++i) 
      nUnitsInHeight += i; //pow(LAYER_HEIGHT_INC_INDEX, i);
      
    unitHeight = height * (1 - VERTICAL_MARGIN_RATIO * 2) / nUnitsInHeight;
    
    nNodesPerLayer = getNodesNumPerLayerByBreadthFirstTraverse();
  
  }
  
  
}
