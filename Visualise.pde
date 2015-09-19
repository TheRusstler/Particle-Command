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
    text("Round: " + round, 0, 10);
    text("Points: " + points, 0, 20);
    text("Missiles: " + missiles, 0, 30);
  }
  
  void roundStart(int round)
  {
    text("Round " + round, width/2 - 20, height/2 - 5);
  }
}
