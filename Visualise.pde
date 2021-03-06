/*
 * Visualise draws objects on screen
 */

class Visualise 
{
  PImage world, city, bomber;
  public Visualise()
  {
    world = loadImage("images/world.jpg");
    city = loadImage("images/city.jpg");
    bomber = loadImage("images/bomber.png");
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
    for(Missile m : missiles)
    {
      if(m.reachedTarget())
      {
        explosionBrush();
        ellipse(m.position.x, m.position.y, m.diameter, m.diameter);
      }
      else
      {
        stroke(255, 255, 255);
        fill(255, 255, 255);
        ellipse(m.position.x, m.position.y, 5, 5);
      }
    }
  }
  
  void bombers(ArrayList<Bomber> bombers)
  {
    for(Bomber b : bombers)
    {
      image(bomber, b.xMin, b.yMin);
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
  
  void betweenRounds(int points)
  {
    randomBrush();
    textSize(32);
      
    if(round.number > 0 && timer < DELAY_BETWEEN_ROUNDS)
    {
      text("ROUND " + round.number + " COMPLETE!", width/2, 200);
      textSize(20);
      text(points + " POINTS", width/2, 270);
      
      text("Cities bonus: +" + cities.size() * CITY_SURVIVAL_BONUS, width/2, 350);
      text("Missiles bonus: +" + round.missilesRemaining * MISSILE_UNUSED_BONUS, width/2, 390);
      
      if(cities.size() < City.MAX_CITIES)
      {
        text("1 CITY REBUILT!", width/2, height/2 +150);
      }
    }
    else 
    {
      textAlign(CENTER);
      text("ROUND " + (round.number+1), width/2, height/2);
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
