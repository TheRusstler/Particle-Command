class City extends Block
{
  public static final int MAX_CITIES = 5;
  private final int number;
  
  public City(int number)
  {
    super((int)(width * (number + 1) / (MAX_CITIES + 1)), 
          height -70, 
          60,
          30,
          new PVector(0, 0));
          
    this.number = number;
  }
}
