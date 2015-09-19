
// Visualise class draws objects

class Visualise 
{
  void particles(ArrayList<Particle> particles)
  {
    stroke(255);
    fill(255);
    for(Particle p : particles)
    {
      ellipse(p.position.x, p.position.y, p.diameter, p.diameter);
    }
  }
  
  void statistics(int round, int points, int missiles)
  {
    text("Round: " + round, 10, 20);
    text("Points: " + points, 10, 40);
    text("Missiles: " + missiles, 10, 60);
  }
  
  void betweenRounds(int round)
  {
    text("Round " + round, width/2 - 20, height/2 - 5);
  }
  
  void crosshair()
  {
    stroke(0, 0, 255);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
  }
}
