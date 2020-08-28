class Iris {
  
  private float sepalLength, sepalWidth;
  private float petalLength, patelWidth;
  private int type;
  
  public static final int CLASS_SETOSA = 0;
  public static final int CLASS_VERSICOLOUR = 1;
  public static final int CLASS_VIRGINICA = 2;
  
  public Iris(float sl, float sw, float pl, float pw, int cls) {
    sepalLength = sl;
    sepalWidth = sw;
    petalLength = pl;
    patelWidth = pw;
    type = cls;
  }
  
  public float[] features() {
    return new float[]{sepalLength, sepalWidth, petalLength, patelWidth};
  }
  
  public int type() { return type; }
  
}
