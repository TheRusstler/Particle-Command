final int delayBetweenRounds = 120;

Round round;
Visualise visualise = new Visualise();
int state     = GameState.NotStarted;
int points, timer   = 0;

ArrayList<City> cities;

void setup() 
{
  size(800, 600);
  noCursor();
  
  points = 0;
  cities = createCities();
  round = new Round(0);
  state = GameState.BetweenRounds;
  //state = GameState.Over;
  timer = delayBetweenRounds;
}

void draw() 
{
  background(0);
  
  switch(state)
  {
    case GameState.NotStarted:
      break;
      
    case GameState.InRound:
      round.update();
      visualise.cities(cities);
      visualise.particles(round.particles);
      visualise.missiles(round.missiles);
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.crosshair();
      break;
      
    case GameState.BetweenRounds:
      visualise.betweenRounds(round.number + 1);
      betweenRoundsTimerTick();
      break;
      
    case GameState.Over:
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.gameOver();
      break;
  }
}

void betweenRoundsTimerTick()
{
  if(timer == 0) 
  {
    startNextRound();
  }
  timer--;
}

void gameOver()
{
  state = GameState.Over;
}

void roundComplete()
{
  state = GameState.BetweenRounds;
  timer = delayBetweenRounds;
}

void startNextRound()
{
  round = new Round(round.number + 1);
  state = GameState.InRound;
}

ArrayList<City> createCities() 
{
  ArrayList<City> cities = new ArrayList<City>();
  cities.add(new City(width * 1/5));
  cities.add(new City(width * 2/5));
  cities.add(new City(width * 3/5));
  cities.add(new City(width * 4/5));
  return cities;
}

void mousePressed()
{
    switch(state)
  {
    case GameState.NotStarted:
      break;
      
    case GameState.InRound:
      round.fireMissile(mouseX, mouseY);
      break;
      
    case GameState.BetweenRounds:
      timer = 0;
      break;
      
    case GameState.Over:
      setup();
      break;
  }
}

void mouseReleased() 
{
}
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
class GameState
{
  public static final int NotStarted = 0;
  public static final int InRound = 1;
  public static final int BetweenRounds = 2;
  public static final int Over = 3;
}
class Missile
{
  final PVector position;
  int diameter;
  boolean exploded;
  
  public Missile(int x, int y)
  {
    position = new PVector(x, y);
    diameter = 0;
  }
  
  private int increasing = 40;
  private int decreasing = 41;
  void integrate()
  {
    if(exploded == false)
    {
      if(increasing > 0)
      {
        diameter++;
        increasing--;
      }
      else if(decreasing > 0)
      {
        diameter--;
        decreasing--;
      }
      else
      {
        exploded = true;
      }
    }
  }
}
class Particle 
{
  final static float DRAG = .999f;
  
  final PVector position, velocity, gravity;
  final float diameter;
  
  Particle(int x, int y, float xVel, float yVel, float diameter) 
  {
    this.position = new PVector(x, y);
    this.velocity = new PVector(xVel, yVel);
    this.gravity = new PVector(0f, 0.002f);
    this.diameter = diameter;
  }
  
  void integrate() 
  { 
    position.add(velocity); 
    velocity.add(gravity);
    velocity.mult(DRAG);
  }
  
  boolean hasHitGround() 
  {
    return position.y + diameter / 2 >= height - 5;
  }
}
import java.util.*;

// Round compromises a number of particles, missiles and cities
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

// Visualise class draws objects

class Visualise 
{
  void cities(ArrayList<City> cities)
  {
    stroke(166);
    fill(166);
    for(City c : cities)
    {
      rect(c.xMin, c.yMin, c.WIDTH, c.HEIGHT, 7);
    }
  }
  
  void particles(ArrayList<Particle> particles)
  {
    stroke(255);
    fill(255);
    for(Particle p : particles)
    {
      ellipse(p.position.x, p.position.y, p.diameter, p.diameter);
    }
  }
  
  void missiles(ArrayList<Missile> missiles)
  {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    for(Missile m : missiles)
    {
      ellipse(m.position.x, m.position.y, m.diameter, m.diameter);
    }
  }
  
  void statistics(int round, int points, int missiles)
  {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    textSize(14);
    text("Round: " + round, 10, 20);
    text("Points: " + points, 10, 40);
    text("Missiles: " + missiles, 10, 60);
  }
  
  void betweenRounds(int round)
  {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    textSize(32);
    text("Round " + round, width/2 - 60, height/2 - 10);
  }
  
  void gameOver()
  {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    textSize(32);
    text("GAME OVER!", width/2 - 80, height/2 - 10);
  }
  
  void crosshair()
  {
    stroke(0, 0, 255);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
  }
}

