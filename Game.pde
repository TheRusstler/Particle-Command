import processing.core.*; 

class Game
{
  GameState state = GameState.NotStarted;
  Round round;
  
  Particle[] particles = new Particle[0];
  
  void newGame() 
  {
    state = GameState.Started;
    round = new Round(1);
  }
  
  void update() 
  {
    if(state == GameState.Started && round.isComplete()) 
    {
      state = GameState.Over;
    }
  }
}
