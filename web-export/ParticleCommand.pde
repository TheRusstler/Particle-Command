import ddf.minim.*;

final int DELAY_BETWEEN_ROUNDS = 60 * 2;

Visualise visualise;
SoundEffect sound;

Round round;
int points, timer, state;
ArrayList<City> cities;

void setup() 
{
  size(800, 600);
  noCursor();
  
  visualise = new Visualise();
  sound     = new SoundEffect(new Minim(this));

  points = 0;
  cities = createCities();
  round  = new Round(0);
  state  = GameState.NotStarted;
  timer  = DELAY_BETWEEN_ROUNDS;
}

void draw() 
{
  background(0);
  
  switch(state)
  {
    case GameState.NotStarted:
      visualise.startScreen();
      visualise.crosshair();
      break;
      
    case GameState.InRound:
      round.update();
      visualise.world();
      visualise.cities(cities);
      visualise.particles(round.particles);
      visualise.bombers(round.bombers);
      visualise.missiles(round.missiles);
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.crosshair();
      break;
      
    case GameState.BetweenRounds:
      visualise.betweenRounds(round.number + 1, points);
      betweenRoundsTimerTick();
      break;
      
    case GameState.Over:
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.gameOver();
      visualise.crosshair();
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
  timer = DELAY_BETWEEN_ROUNDS;
  sound.startup();
}

void startNextRound()
{
  round = new Round(round.number + 1);
  state = GameState.InRound;
}

ArrayList<City> createCities() 
{
  ArrayList<City> cities = new ArrayList<City>();
  
  for(int i=0; i<City.MAX_CITIES; i++)
  {
    cities.add(new City(i));
  }
  
  return cities;
}

void mousePressed()
{
    switch(state)
  {
    case GameState.NotStarted:
      roundComplete();
      break;
      
    case GameState.InRound:
      round.fireMissile(mouseX, mouseY);
      break;
      
    case GameState.BetweenRounds:
      timer = 0;
      break;
      
    case GameState.Over:
      setup();
      roundComplete();
      break;
  }
}
abstract class Block
{
  final int blockWidth, blockHeight;
  final int yMin, yMax, xMin, xMax;
  PVector position, velocity;
  
  public Block(int x, int y, int blockWidth, int blockHeight, PVector velocity)
  {
    this.position = new PVector(x, y);
    this.velocity = velocity;
    this.xMin = x - blockWidth/2;
    this.xMax = x + blockWidth/2;
    this.yMin = y - blockHeight/2;
    this.yMax = y + blockHeight/2;
    this.blockWidth = blockWidth;
    this.blockHeight = blockHeight;
  }
  
  public boolean isWithinBounds(PVector pos, float radius)
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
class Bomber extends Block
{
  int startDelay;
  boolean started;
  
  public Bomber(int delay)
  {
    super(width + 50, 50, 40, 25, new PVector(-1, 0));
    this.startDelay = delay;
  }
  
  void bomb()
  {
    PVector pos, vel;
    Particle p;
    
    p = new Particle(round.number, 10, 0);
    pos = new PVector(position.x, position.y + blockHeight/2);
    vel = new PVector(0, 1);
    p.setMotion(pos, vel);
    p.r = 0;
    p.g = 255;
    p.b = 0;
    
    round.particles.add(p);
  }
  
  void integrate() 
  { 
    if(started)
    {
      position.add(velocity); 
      if(frameCount % 100 == 0)
      {
        bomb();
      }
    }
    else
    {
      checkIfStarted();
    }
  }
  
  void checkIfStarted()
  {
    if(startDelay == 0)
    {
      started = true;
    }
    else
    {
      startDelay--;
    }
  }
}
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
  final float diameter;
  float r, g, b;
  
  PVector position, velocity, gravity;
  int round, startDelay;
  boolean started;
    
  Particle(int round, float diameter, int startDelay) 
  { 
    this.round = round;
    this.gravity = new PVector(0f, 0.003f);
    this.diameter = diameter;
    this.startDelay = startDelay;
    this.r = random(50, 255);
    this.g = random(50, 255);
    this.b = random(50, 255);
    
    randomiseMotion();
  }
  
  void integrate() 
  { 
    if(started)
    {
      position.add(velocity); 
      velocity.add(gravity);
      velocity.mult(DRAG);
    }
    else
    {
      checkIfStarted();
    }
  }
  
  void checkIfStarted()
  {
    if(startDelay == 0)
    {
      started = true;
    }
    else
    {
      startDelay--;
    }
  }
  
  boolean hasHitGround() 
  {
    return position.y + diameter / 2 >= height - 50;
  }
  
  Particle split()
  {
    Particle p = new Particle(round, diameter, 0);
    p.setMotion(position.get(), velocity.get());
    p.velocity.x = -p.velocity.x;
    p.r = r;
    p.g = g;
    p.b = b;
    return p;
  }
  
  void setMotion(PVector position, PVector velocity)
  {
    this.position = position;
    this.velocity = velocity;
  }
  
  void randomiseMotion()
  {
    int x;
    float xVelocity, yVelocity, roundVelocityMultiplier;
    
    roundVelocityMultiplier = 1 + round/10.0;
    
    x = (int)random(0, width);
    xVelocity = random(0, 1*roundVelocityMultiplier);
    yVelocity = random(0, 2*roundVelocityMultiplier);
    
    // Choose xVelocity direction according to starting half of screen
    if(x < width/2 && xVelocity < 0 || x > width/2 && xVelocity > 0) 
    {
      xVelocity *= -1;
    }
    
    position = new PVector(x, -20);
    velocity = new PVector(xVelocity, yVelocity);
  }
}
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
    this.bombers = getBombers();
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
    
    for(Bomber b : bombers)
    {
      b.integrate();
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
  
  ArrayList<Bomber> getBombers()
  {
    ArrayList<Bomber> bombers = new ArrayList<Bomber>();
    //if(number > 1)
    //{
      //bombers.add(new Bomber((int)random(50, 300)));
    //}
    bombers.add(new Bomber(0));
    return bombers;
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
class SoundEffect
{
  Minim minim;
  AudioPlayer player;
  
  public SoundEffect(Minim minim)
  {
    this.minim = minim;
  }
  
  void startup()
  {
    playFile("sounds/startup.wav");
  }
  
  void missile()
  {
    playFile("sounds/missile.mp3");
  }
  
  void missileHit()
  {
    playFile("sounds/missile_hit.wav");
  }
  
  void particleSplit()
  {
    playFile("sounds/split.wav");
  }
  
  void explosion()
  {
    playFile("sounds/explosion.wav");
  }
  
  void upgrade()
  {
    playFile("sounds/upgrade.wav");
  }
  
  void playFile(String path)
  {
    player = minim.loadFile(path, 2048);
    player.play();
  }
}
class Visualise 
{
  PImage world, city, bomber;
  public Visualise()
  {
    world = loadImage("images/world.jpg");
    city = loadImage("images/city.jpg");
    bomber = loadImage("images/bomber.jpg");
  }
  
  void cities(ArrayList<City> cities)
  {
    for(City c : cities)
    {
      image(city, c.xMin, c.yMin);
    }
  }
  
  void particles(ArrayList<Particle> particles)
  {
    for(Particle p : particles)
    {
      stroke(p.r, p.g, p.b);
      fill(p.r, p.g, p.b);
      ellipse(p.position.x, p.position.y, p.diameter, p.diameter);
    }
  }
  
  void missiles(ArrayList<Missile> missiles)
  {
    explosionBrush();
    for(Missile m : missiles)
    {
      ellipse(m.position.x, m.position.y, m.diameter, m.diameter);
    }
  }
  
  void bombers(ArrayList<Bomber> bombers)
  {
    for(Bomber b : bombers)
    {
      image(bomber, b.xMin, b.yMin);
      System.out.println(b.xMin +" " + b.yMin);
    }
  }
  
  void statistics(int round, int points, int missiles)
  {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    textSize(14);
    textAlign(LEFT);
    text("Round: " + round, 10, 20);
    text("Points: " + points, 10, 40);
    text("Missiles: " + missiles, 10, 60);
  }
  
  void world()
  {
    image(world, 0, height-120);
  }
  
  void betweenRounds(int round, int points)
  {
    randomBrush();
    textSize(32);
      
    if(round > 1 && timer < DELAY_BETWEEN_ROUNDS)
    {
      text("ROUND " + round + " COMPLETE!", width/2, height/2 -30);
      textSize(20);
      text(points + " POINTS", width/2, height/2 +30);
    }
    else 
    {
      textAlign(CENTER);
      text("ROUND " + round, width/2, height/2);
    }
  }
  
  void gameOver()
  {
    explosionBrush();
    textSize(32);
    textAlign(CENTER);
    text("GAME OVER!", width/2, height/2);
    
    stroke(0, 0, 255);
    fill(0, 0, 255);
    textSize(12);
    text("Click to restart", width/2, height/2 + 50);
  }
  
  void startScreen()
  {
    randomBrush();
      
    textSize(32);
    textAlign(CENTER);
    text("PARTICLE COMMAND!", width/2, height/2);
    
    stroke(0, 0, 255);
    fill(0, 0, 255);
    textSize(12);
    text("Click anywhere to start", width/2, height/2 + 50);
  }
  
  void crosshair()
  {
    stroke(0, 0, 255);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
  }
  
  boolean isRed;
  void explosionBrush()
  { 
    if(frameCount % 5 == 0)
    {
      isRed = !isRed;
    }
    
    if(isRed)
    {
      stroke(255, 0, 0);
      fill(255, 0, 0);
    }
    else
    {
      stroke(255, 255, 255);
      fill(255, 255, 255);
    }
  }
  
  float r = 0, g = 0, b = 0;
  void randomBrush()
  {
    if(frameCount % 2 == 0)
    {
      r = random(0, 255);
      g = random(0, 255);
      b = random(0, 255);
    }
    
    stroke(r, g, b);
    fill(r, g, b);
  }
}

