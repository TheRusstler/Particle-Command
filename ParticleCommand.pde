Particle[] particles;
int waveSize = 20;

void setup() {
  size(displayWidth/2, displayHeight/2);
  particles = getWave(waveSize);
}

void draw() {
  background(128);
  //text("Velocity: (" + p.velocity.x + ", " + p.velocity.y + ")", 0, 10);
  drawParticles();
}

void drawParticles() {
  for(int i=0; i<waveSize; i++) {
    Particle p = particles[i];
    p.integrate();
    ellipse(p.position.x, p.position.y, p.diameter, p.diameter);
  }
}

Particle[] getWave(int size) {
  Particle[] particles = new Particle[size];
  
  for(int i=0; i<waveSize; i++) {
    int xStart = (int)random(0, width);
    float xVelocity = random(0, 1f);
    
    // Particles starting at the left/right of the screen
    // should have a positive/negative velocity respectively.
    if(xStart < width/2 && xVelocity < 0 || xStart > width/2 && xVelocity > 0) {
      xVelocity *= -1;
    }
    
    particles[i] = new Particle(xStart, 
                                (int)random(-500, -20), 
                                //20,
                                xVelocity, 
                                random(0, 1f), 
                                random(2, 8));
  }
  
  return particles;
}

void mousePressed() {
}

void mouseReleased() {
}
