class Point 
{
  protected int x;
  protected int y;
  protected int radius = POINT_RADIUS;
  protected int label = 0;
  
  public Point()
  {
    this.x = radius;
    this.y = radius;
  }
  public Point(int x_, int y_)
  {
    this.x = x_;
    this.y = y_;
  }
   public Point(double x_, double y_)
  {
    this.x = (int)x_;
    this.y = (int)y_;
  }
  public void set_posi(double x_, double y_)
  {
    this.x = (int)x_;
    this.y = (int)y_;
  }
  public int get_x()
  {
    return this.x;
  }
  public int get_y()
  {
    return this.y;
  }
  public void cluster(int k) 
  {
    this.label = k;
  }
  
  public int get_label()
  {
    return this.label;
  }
  public void disp()
  {
    pushStyle();
    noStroke();
    fill(colors[this.label]);
    ellipse(this.x, this.y, radius, radius);
    popStyle();
    
  }
  
  public int dist_to(Point p)
  {
    //return (abs(x - p.get_x()) + abs(y - p.get_y()));
    return (int)sqrt(pow(x - p.get_x(), 2) + pow(y - p.get_y(), 2));
  }
  
  public void link_to(Point p)
  {
    pushStyle();
    stroke(100);
    line(x, y, p.get_x(), p.get_y());
    popStyle();
  }
  
  
}