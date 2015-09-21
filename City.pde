class City 
{
  public final int WIDTH = 60, HEIGHT = 60;
  
  private final int YOFFSET = 10;
  private final int yMin, yMax, xMin, xMax;
  
  public City(int position)
  {
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
