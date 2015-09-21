import java.util.*;

// Round compromises a number of particles, missiles and cities
class Round 
{
  final static int INITIAL_PARTICLES = 10;
  final static int ROUND_PARTICLE_INCREASE = 5;
  
  int number, missilesRemaining;
  ArrayList<Particle> particles;
  ArrayList<Missile> missiles;
  
  public Round(int number) 
  {
    this.number = number;
    this.missiles = new ArrayList<Missile>();
    
    int numberOfParticles = INITIAL_PARTICLES + (number-1) * ROUND_PARTICLE_INCREASE;
    this.particles = getParticles(numberOfParticles);
    this.missilesRemaining = numberOfParticles * 2;
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
    
    removeGroundedParticles();
    removeExplodedMissiles();
    detectMissileCollisions();
    
    if(particles.size() == 0)
    {
      roundComplete();
    }
  }
  
  void removeGroundedParticles()
  {
    List<Particle> grounded = new ArrayList<Particle>();
    
    for(Particle p : particles)
    {
      if(p.hasHitGround())
      {
        grounded.add(p);
      }
    }
    
    particles.removeAll(grounded);
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
    float distance, sumOfRadiuses;
    List<Particle> collisions = new ArrayList<Particle>();
    
    for(Particle p : particles)
    {
      for(Missile m : missiles)
      {
        distance = PVector.dist(p.position, m.position);
        sumOfRadiuses = p.diameter/2 + m.diameter/2;
        
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
    int xStart, yStart;
    float xVelocity, yVelocity, diameter;
    ArrayList<Particle> particles = new ArrayList<Particle>();
    
    for(int i=0; i<numberOfParticles; i++) 
    {
      xStart = (int)random(0, width);
      yStart = (int)random(-400, -20);
      xVelocity = random(0, 1f);
      yVelocity = random(0, 2f);
      diameter = random(2, 25);
      
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
