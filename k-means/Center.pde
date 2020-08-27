class Center extends Point 
{
  public Center()
  {
    radius = CENTER_RADIUS;
  }
  public  Center(double x_, double y_)
  {
    radius = CENTER_RADIUS;
    set_posi(x_, y_);
  }
  public  Center(Point p)
  {
    radius = CENTER_RADIUS;
    set_posi(p.get_x(), p.get_y());
    this.label = p.get_label();
  }
  public void disp()
  {
    pushStyle();
    stroke(10);
    strokeWeight(3);
    fill(colors[this.label]);
    ellipse(this.x, this.y, this.radius, this.radius);
    popStyle();
    
  }
  
  public void set_posi(Point p) 
  {
    set_posi(p.get_x(), p.get_y());
    this.label = p.get_label();
    
  }
  
  
}