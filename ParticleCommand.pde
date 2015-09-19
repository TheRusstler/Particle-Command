Game game;

void setup()
{
  size(800, 600);
  game = new Game();
  game.start();
}

void draw(){
  background(0);
  game.update();
}

void mousePressed()
{
  game.roundComplete();
}

void mouseReleased() 
{}
