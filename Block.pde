/*
 * Block is a rectangular object with collision detection
 */

abstract class Block
{
  final int blockWidth, blockHeight;
  int yMin, yMax, xMin, xMax;
  PVector position, velocity;
  
  public Block(int x, int y, int blockWidth, int blockHeight, PVector velocity)
  {
    this.position = new PVector(x, y);
    this.velocity = velocity;
    this.blockWidth = blockWidth;
    this.blockHeight = blockHeight;
    integrate();
  }
  
  public void integrate()
  {
    this.xMin = (int)position.x - blockWidth/2;
    this.xMax = (int)position.x + blockWidth/2;
    this.yMin = (int)position.y - blockHeight/2;
    this.yMax = (int)position.y + blockHeight/2;
  }
  
  public boolean isHit(PVector pos, float radius)
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
