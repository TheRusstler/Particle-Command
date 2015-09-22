class SoundEffect
{
  Minim minim;
  AudioPlayer player;
  
  public SoundEffect(Minim minim)
  {
    this.minim = minim;
  }
  
  void missile()
  {
    playFile("sounds/missile.mp3");
  }
  
  void explosion()
  {
    playFile("sounds/explosion.mp3");
  }
  
  void playFile(String path)
  {
    player = minim.loadFile(path, 2048);
    player.play();
  }
}
