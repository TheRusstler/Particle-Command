
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
