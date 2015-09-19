import processing.core.*; 
import java.util.*;

class Game
{
  GameState state = GameState.NotStarted;
  Round round;
  int points;
  
  Visualise visualise = new Visualise();
  
  void start() 
  {
    points = 0;
    round = new Round(1);
    state = GameState.InRound;
  }
  
  void update() 
  {
    switch(state)
    {
      case NotStarted:
        break;
        
      case InRound:
        round.update();
        visualise.particles(round.particles);
        visualise.statistics(round.number, points, round.missiles);
        break;
        
      case BetweenRounds:
        visualise.roundStart(round.number);
        break;
        
      case Over:
        break;
    }
  }
}
