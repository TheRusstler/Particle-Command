class City 
{
  public static final int MAX_CITIES = 5;
  public final int WIDTH = 60, HEIGHT = 30;
  private final int YOFFSET = -54;
  private final int yMin, yMax, xMin, xMax;
  private final int number;
  
  public City(int number)
  {
    this.number = number;
    
    int position = (int)(width * (number + 1) / (MAX_CITIES + 1));
    yMin = height - HEIGHT + YOFFSET;
    yMax = height + YOFFSET;
    xMin = position - WIDTH/2;
    xMax = position + WIDTH/2;
  }
  
  boolean isWithinBounds(PVector pos, float radius)
  {
    if( pos.x + radius > xMin  
         && pos.x - radius < xMax
         && pos.y + radius > yMin
         && pos.y - radius < yMax)
         {
           return true;
         }
    
    return false;
  }
}
