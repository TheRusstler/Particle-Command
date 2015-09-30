import ddf.minim.*;

final int DELAY_BETWEEN_ROUNDS = 60 * 3;

Visualise visualise;
SoundEffect sound;

Round round;
int points, timer, state;
ArrayList<City> cities;

void setup() 
{
  size(800, 600);
  noCursor();
  
  visualise = new Visualise();
  sound     = new SoundEffect(new Minim(this));

  points = 0;
  cities = createCities();
  round  = new Round(0);
  state  = GameState.NotStarted;
  timer  = DELAY_BETWEEN_ROUNDS;
}

void draw() 
{
  background(0);
  
  switch(state)
  {
    case GameState.NotStarted:
      visualise.startScreen();
      visualise.crosshair();
      break;
      
    case GameState.InRound:
      round.update();
      visualise.world();
      visualise.cities(cities);
      visualise.particles(round.particles);
      visualise.bombers(round.bombers);
      visualise.missiles(round.missiles);
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.crosshair();
      break;
      
    case GameState.BetweenRounds:
      visualise.betweenRounds(round.number + 1, points);
      betweenRoundsTimerTick();
      break;
      
    case GameState.Over:
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.gameOver();
      visualise.crosshair();
      break;
  }
}

void mousePressed()
{
    switch(state)
  {
    case GameState.NotStarted:
      roundComplete();
      break;
      
    case GameState.InRound:
      round.fireMissile(mouseX, mouseY);
      break;
      
    case GameState.BetweenRounds:
      timer = 0;
      break;
      
    case GameState.Over:
      setup();
      roundComplete();
      break;
  }
}

void betweenRoundsTimerTick()
{
  if(timer == 0) 
  {
    rebuildCity();
    startNextRound();
  }
  timer--;
}

void gameOver()
{
  state = GameState.Over;
}

void roundComplete()
{
  state = GameState.BetweenRounds;
  timer = DELAY_BETWEEN_ROUNDS;
  sound.startup();
}

void startNextRound()
{
  round = new Round(round.number + 1);
  state = GameState.InRound;
}

ArrayList<City> createCities() 
{
  ArrayList<City> cities = new ArrayList<City>();
  
  for(int i=0; i<City.MAX_CITIES; i++)
  {
    cities.add(new City(i));
  }
  
  return cities;
}

void rebuildCity()
{
  if(cities.size() == City.MAX_CITIES)
  {
    return;
  }
  
  for(int i=0; i<cities.size(); i++)
  {
    if(cities.get(i).number != i+1)
    {
      cities.add(i, new City(i+1));
      System.out.println("Rebuilt city: " + i);
      return;
    }
  }
}
