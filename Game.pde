import processing.core.*; 
import java.util.*;

// Game compromises a number of rounds (levels)
class Game
{
  final int delayBetweenRounds = 180;
  
  Visualise visualise = new Visualise();
  GameState state     = GameState.NotStarted;
  Round round;
  int points, timer   = 0;
  ArrayList<City> cities;
  
  void start() 
  {
    points = 0;
    cities = createCities();
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
  
  void roundComplete()
  {
    state = GameState.BetweenRounds;
    timer = delayBetweenRounds;
  }
  
  void startNextRound()
  {
    round = new Round(round.number + 1);
    state = GameState.InRound;
  }
  
  ArrayList<City> createCities() 
  {
    ArrayList<City> cities = new ArrayList<City>();
    cities.add(new City());
    cities.add(new City());
    return cities;
  }
}
