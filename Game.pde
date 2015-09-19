import processing.core.*; 
import java.util.*;

class Game
{
  final int delayBetweenRounds = 180;
  
  Visualise visualise = new Visualise();
  GameState state     = GameState.NotStarted;
  Round round;
  int points, timer = 0;
  
  void start() 
  {
    points = 0;
    round = new Round(0);
    state = GameState.BetweenRounds;
    timer = delayBetweenRounds;
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
        visualise.roundStart(round.number + 1);
        betweenRoundsTimer();
        break;
        
      case Over:
        break;
    }
  }
  
  void betweenRoundsTimer()
  {
    timer--;
    if(timer == 0) 
    {
      startNextRound();
    }
  }
  
  void endRound()
  {
    
  }
  
  void startNextRound()
  {
    round = new Round(round.number + 1);
    state = GameState.InRound;
  }
}
