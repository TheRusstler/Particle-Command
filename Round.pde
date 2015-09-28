import java.util.*;

class Round 
{
  final int INITIAL_PARTICLES = 10;
  final int ROUND_PARTICLE_INCREASE = 5;
  
  int number, missilesRemaining;
  ArrayList<Particle> particles;
  ArrayList<Missile> missiles;
  
  public Round(int number) 
  {
    this.number = number;
    this.missiles = new ArrayList<Missile>();
    this.particles = getParticles(INITIAL_PARTICLES + (number-1) * ROUND_PARTICLE_INCREASE);
    this.missilesRemaining = particles.size() * 2;
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
    detectCityCollisions();
    
    if(cities.size() == 0)
    {
      gameOver();
    }
    else if(particles.size() == 0)
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
    float distance;
    List<City> cityCollisions = new ArrayList<City>();
    List<Particle> particleCollisions = new ArrayList<Particle>();
    
    for(Particle p : particles)
    {
      for(City c : cities)
      {
        if(c.isWithinBounds(p.position, p.diameter/2))
        {
          cityCollisions.add(c);
          particleCollisions.add(p);
          sound.explosion();
        }
      }
    }
    
    cities.removeAll(cityCollisions);
    particles.removeAll(particleCollisions);
  }
  
  void fireMissile(int x, int y)
  {
    if(missilesRemaining > 0)
    {
      missiles.add(new Missile(x, y));
      sound.missile();
      missilesRemaining--;
    }
  }
  
  ArrayList<Particle> getParticles(int numberOfParticles) 
  {
    ArrayList<Particle> particles = new ArrayList<Particle>();
    float roundVelocityMultiplier = 1 + number/10.0;
    
    for(int i=0; i<numberOfParticles; i++) 
    {
      particles.add(new Particle(number));
    }
    
    return particles;
  }
}
