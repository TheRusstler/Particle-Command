
// Visualise class draws entities on screen

class Visualise 
{
  void particles(ArrayList<Particle> particles)
  {
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
  
  void roundStart(int round)
  {
    text("Round " + round, width/2 - 20, height/2 - 5);
  }
}
