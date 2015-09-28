import java.util.*;

class Round 
{
  final int INITIAL_PARTICLES = 10;
  final int ROUND_PARTICLE_INCREASE = 5;
  
  int number, missilesRemaining;
  ArrayList<Particle> particles;
  ArrayList<Missile> missiles; 
  ArrayList<Bomber> bombers;
  
  public Round(int number) 
  {
    this.number = number;
    this.missiles = new ArrayList<Missile>();
    this.particles = getParticles();
    this.missilesRemaining = (int) (particles.size() * 1.7);
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
    splitParticles();
    
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
  
  void splitParticles()
  {
    if(frameCount % 300 == 0)
    {
      Particle newFromSplitting, randomParticle;
      randomParticle = particles.get((int)random(0, particles.size()-1));
      newFromSplitting = randomParticle.split();
      particles.add(newFromSplitting);
      
      // Make sound if split is visible
      if(newFromSplitting.position.y > 0)
      {
        sound.particleSplit();
      }
    }
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
          sound.missileHit();
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
  
  ArrayList<Particle> getParticles() 
  {
    ArrayList<Particle> particles = new ArrayList<Particle>();
    float roundVelocityMultiplier = 1 + number/10.0;
    int numberOfParticles = INITIAL_PARTICLES + (number-1) * ROUND_PARTICLE_INCREASE;
    int startDelay;
    float diameter;
    
    for(int i=0; i<numberOfParticles; i++) 
    {
      startDelay = (int)random(0, 600);
      diameter = random(10, 25);
      particles.add(new Particle(number, diameter, startDelay));
    }
    
    return particles;
  }
}
