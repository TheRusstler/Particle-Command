final int delayBetweenRounds = 120;

Visualise visualise = new Visualise();
GameState state     = GameState.NotStarted;
Round round;
int points, timer   = 0;

ArrayList<City> cities;

void setup() 
{
  size(800, 600);
  noCursor();
  
  points = 0;
  cities = createCities();
  round = new Round(0);
  state = GameState.BetweenRounds;
  timer = delayBetweenRounds;
}

void draw() 
{
  background(0);
  
  switch(state)
  {
    case NotStarted:
      break;
      
    case InRound:
      round.update();
      visualise.particles(round.particles);
      visualise.statistics(round.number, points, round.missiles);
      visualise.crosshair();
      break;
      
    case BetweenRounds:
      visualise.betweenRounds(round.number + 1);
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

void mousePressed()
{
}

void mouseReleased() 
{
}
