Game game;
Visualise visualise = new Visualise();

void setup()
{
  size(800, 600);
  noCursor();
  game = new Game();
  game.start();
}

void draw(){
  background(0);
  game.update();
}

void mousePressed()
{
}

void mouseReleased() 
{}
