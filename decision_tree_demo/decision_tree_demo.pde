IrisData irisData;
DecisionTree dt;
TreeViewer viewer;

void setup() {
  size(800, 800);
  background(255);
  irisData = new IrisData();
  irisData.load();
  
  
  dt = new DecisionTree(irisData);
  viewer = new TreeViewer(dt.generateTree());
  viewer.render();
  saveFrame();
} 
