//Alejandro David Diaz Palafox A2
//Programacion Orientada a Objetos
//NUA - 144206

import processing.video.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;

Box box;

ArrayList<Particle> particles;

Spring spring;

float xoff = 0;
float yoff = 1000;


PImage gota;
PImage planta;

Movie movie;
SoundFile file;

void setup() {
  size(600, 340);
  smooth();

  movie = new Movie(this, "fondo.mp4");
  movie.loop();
  
  file = new SoundFile(this, "music.mp3");
  file.loop();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.listenForCollisions();

  box = new Box(width/2, height/2);

  spring = new Spring();
  spring.bind(width/2, height/2, box);

  particles = new ArrayList<Particle>();
  boundaries = new ArrayList<Boundary>();


  boundaries.add(new Boundary(70, 180, 120, 10, 0));
  boundaries.add(new Boundary(230, 180, 120, 10, 0));
  boundaries.add(new Boundary(380, 180, 120, 10, 0));
  boundaries.add(new Boundary(530, 180, 120, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));

  gota= loadImage("gota.png");
  planta= loadImage("planta.png");
  
}

void draw() {

  box2d.setGravity(0, -10);
  image(movie, 0, 0);

  for (Boundary wall : boundaries) {
    wall.display();
  }

  if (random(1) < 0.2) {
    float sz = random(4, 8);
    particles.add(new Particle(width/2, -20, sz));
  }

  box2d.step();

  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;

  if (mousePressed) {
    spring.update(mouseX, mouseY);
    spring.display();
  } else {
    spring.update(x, y);
  }
  box.body.setAngularVelocity(0);

  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    if (p.done()) {
      particles.remove(i);
    }
  }
  
  pushMatrix();
  textSize(21);
  fill(random(0,255),0, random(0,255));
  text("Hacer clic en el Mouse", 30, 330);
  popMatrix();

  box.display();
}

void endContact(Contact cp) {
}

void movieEvent(Movie movie) {
  movie.read();
}