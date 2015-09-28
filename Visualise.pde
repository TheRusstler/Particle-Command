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
    textAlign(LEFT);
    text("Round: " + round, 10, 20);
    text("Points: " + points, 10, 40);
    text("Missiles: " + missiles, 10, 60);
  }
  
  void betweenRounds(int round)
  {
    randomBrush();
    
    textSize(32);
    textAlign(CENTER);
    text("Round " + round, width/2, height/2);
  }
  
  void gameOver()
  {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    textSize(32);
    textAlign(CENTER);
    text("GAME OVER!", width/2, height/2);
    
    textSize(12);
    text("Click anywhere to restart", width/2, height/2 + 50);
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
  
  void randomBrush()
  {
    stroke(random(0,255), random(0,255), random(0,255));
    fill(random(0,255), random(0,255), random(0,255));
  }
}
