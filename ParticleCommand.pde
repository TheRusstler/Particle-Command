import ddf.minim.*;

final int delayBetweenRounds = 120;

Visualise visualise;
SoundEffect sound;

Round round;
int points, timer, state;
ArrayList<City> cities;

public ParticleCommand()
{
  visualise = new Visualise();
  sound     = new SoundEffect(new Minim(this));
}

void setup() 
{
  size(800, 600);
  noCursor();

  points = 0;
  cities = createCities();
  round  = new Round(0);
  state  = GameState.NotStarted;
  timer  = delayBetweenRounds;
}

void draw() 
{
  background(0);
  
  switch(state)
  {
    case GameState.NotStarted:
      visualise.startScreen();
      break;
      
    case GameState.InRound:
      round.update();
      visualise.cities(cities);
      visualise.particles(round.particles);
      visualise.missiles(round.missiles);
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.crosshair();
      break;
      
    case GameState.BetweenRounds:
      visualise.betweenRounds(round.number + 1);
      betweenRoundsTimerTick();
      break;
      
    case GameState.Over:
      visualise.statistics(round.number, points, round.missilesRemaining);
      visualise.gameOver();
      break;
  }
}

void betweenRoundsTimerTick()
{
  if(timer == 0) 
  {
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
  
  for(int i=0; i<City.MAX_CITIES; i++)
  {
    cities.add(new City(i));
  }
  
  return cities;
}

void mousePressed()
{
    switch(state)
  {
    case GameState.NotStarted:
      state = GameState.BetweenRounds;
      break;
      
    case GameState.InRound:
      round.fireMissile(mouseX, mouseY);
      break;
      
    case GameState.BetweenRounds:
      timer = 0;
      break;
      
    case GameState.Over:
      setup();
      state = GameState.BetweenRounds;
      break;
  }
}

void mouseReleased() 
{
}
