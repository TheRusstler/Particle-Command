class Round 
{
  final int roundOneParticles = 10;
  final int particleIncreasePerRound = 5;
  
  int number, missiles;
  ArrayList<Particle> particles;
  ArrayList<City> cities;
  
  public Round(int number) 
  {
    this.number = number;
    this.missiles = 20;
    this.cities = getCities();
    
    int numberOfParticles = roundOneParticles + (number-1) * particleIncreasePerRound;
    this.particles = getParticles(numberOfParticles);
  }
  
  void update()
  {
    for(Particle p : particles)
    {
      p.integrate();
    }
  }
 
  ArrayList<City> getCities() 
  {
    ArrayList<City> cities = new ArrayList<City>();
    cities.add(new City());
    cities.add(new City());
    return cities;
  }
  
  ArrayList<Particle> getParticles(int particleCount) 
  {
    ArrayList<Particle> particles = new ArrayList<Particle>();
    
    for(int i=0; i<particleCount; i++) 
    {
      int xStart = (int)random(0, width);
      int yStart = (int)random(-400, -20);
      float xVelocity = random(0, 1f);
      float yVelocity = random(0, 2f);
      float diameter = random(2, 8);
      
      // Choose xVelocity direction according to starting half of screen
      if(xStart < width/2 && xVelocity < 0 || xStart > width/2 && xVelocity > 0) 
      {
        xVelocity *= -1;
      }
      
      particles.add(new Particle(xStart, yStart, xVelocity, yVelocity, diameter));
    }
    
    return particles;
  }
}
