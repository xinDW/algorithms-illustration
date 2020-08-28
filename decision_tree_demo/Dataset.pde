import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.ArrayList;

class IrisData {
  private static final String dataPath = "C:\\Users\\think\\Documents\\Processing\\decision_tree_demo\\data\\iris.data";
  
  public static final int N_FEATURES = 4;
  public static final int N_CLASSES = 3;
  
  private List<Iris> data;
  
  public IrisData() {
    data = new ArrayList<Iris>();
  }
  
  private void load() {
    try {
      BufferedReader reader = new BufferedReader(new FileReader(dataPath));
      String line;
      println("loading");
      while((line = reader.readLine()) != null) {
        println(line);
        data.add(parseString(line));
      }
    }
    catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    catch (IOException e) {        
      println(e.getMessage());     
    }   
  }
  
  private Iris parseString(String s) {
    String[] tokens = s.split(",");
    float sl, sw, pl, pw;
    int type;
    sl = Float.parseFloat(tokens[0]);
    sw = Float.parseFloat(tokens[1]);
    pl = Float.parseFloat(tokens[2]);
    pw = Float.parseFloat(tokens[3]);
    
    String typeToken = tokens[4];
    if (typeToken.equals("Iris-setosa"))
      type = Iris.CLASS_SETOSA;
    else if (typeToken.equals("Iris-versicolor"))
      type = Iris.CLASS_VERSICOLOUR;
    else //if (typeToken.equals("Iris-virginica")) 
      type = Iris.CLASS_VIRGINICA;
    
    return new Iris(sl, sw, pl, pw, type);
  }
  
  public List<Iris> allItems() { return this.data; }
  
  public int getSize() { return this.data.size(); }  
  
} 
