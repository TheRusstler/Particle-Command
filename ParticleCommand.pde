Game game;

void setup()
{
  size(800, 600);
  game = new Game();
}

void draw()
{
  background(128);
  game.update();
  
  if(game.state == GameState.Started) 
  {
    drawParticles();
    drawStats();
  }
}

void drawParticles() {
  for(int i=0; i<game.round.particles.length; i++) 
  {
    Particle p = game.round.particles[i];
    
    if(p.stopped == false) 
    {
      p.integrate();
      ellipse(p.position.x, p.position.y, p.diameter, p.diameter);
    }
  }
}

void drawStats() 
{
  text("Round: " + game.round.number, 0, 10);
}


void mousePressed() 
{
    game.newGame();
}

void mouseReleased() 
{
}
