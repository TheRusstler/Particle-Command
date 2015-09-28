class SoundEffect
{
  Minim minim;
  AudioPlayer player;
  
  public SoundEffect(Minim minim)
  {
    this.minim = minim;
  }
  
  void startup()
  {
    playFile("sounds/startup.wav");
  }
  
  void missile()
  {
    playFile("sounds/missile.mp3");
  }
  
  void explosion()
  {
    playFile("sounds/explosion.wav");
  }
  
  void upgrade()
  {
    playFile("sounds/upgrade.wav");
  }
  
  void playFile(String path)
  {
    player = minim.loadFile(path, 2048);
    player.play();
  }
}
