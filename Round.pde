import java.util.*;

// Round compromises a number of particles, missiles and cities
class Round 
{
  final static int INITIAL_MISSILES = 10;
  final static int INITIAL_PARTICLES = 10;
  final static int ROUND_PARTICLE_INCREASE = 5;
  
  int number, missilesRemaining;
  ArrayList<Particle> particles;
  ArrayList<Missile> missiles;
  
  public Round(int number) 
  {
    this.number = number;
    this.missilesRemaining = INITIAL_MISSILES;
    this.missiles = new ArrayList<Missile>();
    
    int numberOfParticles = INITIAL_PARTICLES + (number-1) * ROUND_PARTICLE_INCREASE;
    this.particles = getParticles(numberOfParticles);
  }
  
  void update()
  {
    for(Particle p : particles)
    {
      p.integrate();
    }
    
    for(Missile m : missiles)
    {
      m.integrate();
    }
    
    removeExplodedMissiles();
    detectMissileCollisions();
  }
  
  void removeExplodedMissiles()
  {
    List<Missile> exploded = new ArrayList<Missile>();
    for(Missile m : missiles)
    {
      if(m.exploded == true)
      {
        exploded.add(m);
      }
    }
    
    missiles.removeAll(exploded);
  }
  
  void detectMissileCollisions()
  {
    List<Particle> collisions = new ArrayList<Particle>();
    
    for(Particle p : particles)
    {
      for(Missile m : missiles)
      {
        float distance = PVector.dist(p.position, m.position);
        float sumOfRadiuses = p.diameter/2 + m.diameter/2;
        
        if(distance <= sumOfRadiuses)
        {
          points += 10;
          collisions.add(p);
        }
      }
    }
    
    particles.removeAll(collisions);
  }

  void detectCityCollisions()
  {
    
  }
  
  void fireMissile(int x, int y)
  {
    if(missilesRemaining > 0)
    {
      missiles.add(new Missile(x, y));
      missilesRemaining--;
    }
  }
  
  ArrayList<Particle> getParticles(int numberOfParticles) 
  {
    ArrayList<Particle> particles = new ArrayList<Particle>();
    
    for(int i=0; i<numberOfParticles; i++) 
    {
      int xStart = (int)random(0, width);
      int yStart = (int)random(-400, -20);
      float xVelocity = random(0, 1f);
      float yVelocity = random(0, 2f);
      float diameter = random(2, 25);
      
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
