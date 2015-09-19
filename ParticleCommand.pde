Game game;

void setup()
{
  size(800, 600);
  game = new Game();
}

void draw(){
  background(0);
  game.update();
}

void mousePressed()
{
  game.start();
}

void mouseReleased() 
{}
