class Round 
{
  final int roundOneParticles = 10;
  final int particleIncreasePerRound = 5;
  
  int number;
  Particle[] particles;
  City[] cities;
  
  public Round(int number) 
  {
    this.number = number;
    this.cities = getCities();
    
    int numberOfParticles = roundOneParticles + (number-1) * particleIncreasePerRound;
    this.particles = getParticles(numberOfParticles);
  }
  
  boolean isComplete() 
  {
    boolean complete = true;
    
    for(Particle p : particles) 
    {
      if(p.stopped == false) 
      {
        complete = false;
        break;
      }
    }
    
    return complete;
  }
  
  City[] getCities() 
  {
    City[] cities = new City[2];
    cities[0] = new City();
    cities[1] = new City();
    return cities;
  }
  
  Particle[] getParticles(int particleCount) 
  {
    Particle[] particles = new Particle[particleCount];
    
    for(int i=0; i<particleCount; i++) 
    {
      int xStart = (int)random(0, width);
      int yStart = (int)random(-400, -20);
      float xVelocity = random(0, 1f);
      float yVelocity = random(0, 1f);
      float diameter = random(2, 8);
      
      // Choose xVelocity direction according to starting half of screen
      if(xStart < width/2 && xVelocity < 0 || xStart > width/2 && xVelocity > 0) 
      {
        xVelocity *= -1;
      }
      
      particles[i] = new Particle(xStart, yStart, xVelocity, yVelocity, diameter);
    }
    
    return particles;
  }
}
