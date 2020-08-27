// k-menas clustering demostration
import java.util.ArrayList;


final int points_num = 150;
final int cluster_num = 4;

final int edge = 10;
final int POINT_RADIUS = 15;
final int CENTER_RADIUS = 20;

final int pie_chart_radius = 60;

color[] colors = new color[cluster_num];
Point[] points = new Point[points_num];
Center[] centers = new Center[cluster_num];
int[] stat = new int[cluster_num];

int frame = 0;
long time = 0;
long last_record = time;
long interval_between_frames = 2000;

boolean pause = false;

void setup()
{
  size(500, 500);
  color[] color_library = new color[8];
  color_library[0] = color(255, 0, 0, 100);
  color_library[1] = color(0, 255, 0, 100);
  color_library[2] = color(0, 0, 255, 100);
  color_library[3] = color(255, 255, 0, 100);
  color_library[4] = color(255, 0, 255, 100);
  color_library[5] = color(0, 255, 255, 100);
  color_library[6] = color(255, 255, 255, 100);
  color_library[7] = color(0, 0, 0, 100);
  
  for (int i = 0; i < points_num; i++)
  {
    double init_x = random(edge, width - edge);
    double init_y = random(edge, height - edge);
   
    while (init_x > (width - pie_chart_radius * 2 - edge) && init_y < (pie_chart_radius * 2 + edge)) 
    {
      init_x = random(edge, width - edge);
      init_y = random(edge, width - edge);
    }
    points[i] = new Point(init_x, init_y);
    points[i].disp();
  }
  
  for (int k = 0; k < cluster_num; k++)
  {
    centers[k] = new Center(points[k]);
    centers[k].disp();
    colors[k] = color_library[k];
    stat[k] = 0;
  }
  
}


void draw() 
{
  time = millis() - last_record;
  if (time > interval_between_frames)
  {
    last_record = millis();
    frame ++;
    //println("draw once ======================" + frame);
    
    
    background(200);
    
    int dist = 0;
    int min_dist = 65535;
    
     
    for (int p = 0; p < points_num; p++)
    {   
      
      min_dist = 1000;
      for (int k = 0; k < cluster_num; k++)
      {
        dist = points[p].dist_to(centers[k]);
        if (dist < min_dist) 
        {
          min_dist = dist;
          points[p].cluster(k);
          //stat[k] += 1;
          //println("point[" + p + "] added to cluster[" + k + "]");
        }
      }
      
     
      points[p].disp();
      points[p].link_to(centers[points[p].get_label()]);
    }
    
    for (int k = 0; k < cluster_num; k++)
    {
      stat[k] = 0;
    }
    for(int i = 0; i < points_num; i++)
    {
       stat[points[i].get_label()] += 1;
    }
      
    /// update the cluster center
    int[] mark = updateCenter(points, points_num, cluster_num);
    
    float start = 0.0;
    float accu = 0.0;
    for (int k = 0; k < cluster_num; k++)
    {
      centers[k].set_posi(points[mark[k]]);
      centers[k].disp();
      
      /// darw a  pie chart
      if (frame > 0) 
      {
        pushStyle();
        noStroke();
        fill(colors[centers[k].get_label()]);
        accu += stat[k]; 
        arc(width - pie_chart_radius, pie_chart_radius, pie_chart_radius * 2 - 30, pie_chart_radius * 2 - 30, start / points_num * 2 * PI, accu / points_num * 2 * PI);
        start += stat[k];
  
        popStyle();
      }
      
    }
    
  }
  
}


/// update center of current clusters
int[] updateCenter(Point[] p, int points_num, int clusters_num)
{
  
  double[] center_x = new double[clusters_num];
  double[] center_y = new double[clusters_num];
  int[] points_num_per_cluster = new int[clusters_num];
  int min_dist[] = new int[clusters_num];
  int mark[] = new int[clusters_num];
  Point[] newCenter = new Point[clusters_num];
  
  for (int k = 0; k < clusters_num; k++)
  {
    center_x[k] = 0.0;
    center_y[k] = 0.0;
    
    points_num_per_cluster[k] = 0;
    min_dist[k] = 65535;
    mark[k] = 0;
    newCenter[k] = new Point();
  }
  
  for (int i = 0; i < points_num; i++)
  {
    center_x[p[i].get_label()] += p[i].get_x();
    center_y[p[i].get_label()] += p[i].get_y();
    points_num_per_cluster[p[i].get_label()] += 1;
  }
  
  for (int k = 0; k < clusters_num; k++)
  {
    center_x[k] /= points_num_per_cluster[k];
    center_y[k] /= points_num_per_cluster[k];
 
    newCenter[k].set_posi(center_x[k], center_y[k]);
    
  
    for (int i = 0; i < points_num; i++)
    {
      if (p[i].get_label() == k) 
      {
          int dist = p[i].dist_to(newCenter[k]);
          if (dist < min_dist[k])
          {
            min_dist[k] = dist;
            mark[k] = i;
          }
      }      
    }
  }
  
  return mark;
  
}


void mouseClicked()
{
  if (mouseButton == LEFT)
  {
    for (int i = 0; i < cluster_num; i++)
    {
      println("centroids reset");
      centers[i].set_posi(points[(int)random(points_num)]);
    }
  }
  else if(mouseButton == RIGHT)
  {
    pause = !pause;
    if (pause) 
    {
      println("paused");
      interval_between_frames = 200000;
    }
    else 
    {
      println("resumed");
      interval_between_frames = 2000;
    }
    
  }
  
}