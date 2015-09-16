// Global vars: 
Particle[] particles;
int waveSize = 5;

void setup() {
  size(displayWidth/2, displayHeight/2);
  particles = getWave(5);
}

void draw() {
  background(128);
  //text("Velocity: (" + p.velocity.x + ", " + p.velocity.y + ")", 0, 10);
  drawParticles();
}

void drawParticles() {
  for(int i=0; i<particles.length; i++) {
    Particle p = particles[i];
    p.integrate();
    ellipse(p.position.x, p.position.y, p.getDiameter(), p.getDiameter());
  }
}

Particle[] getWave(int size) {
  Particle[] particles = new Particle[size];
  for(int i=0; i<waveSize; i++) {
    particles[i] = new Particle((int)random(width/4, width*3/4), 
                                  -10, 
                                  random(-1f, 1f), 
                                  random(0, 2f), 
                                  random(10, 50));
  }
  return particles;
}

void mousePressed() {
}

void mouseReleased() {
}
