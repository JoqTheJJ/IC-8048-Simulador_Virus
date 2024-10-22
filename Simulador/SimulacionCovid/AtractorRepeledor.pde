class Atractor {
  AgentSystem system;
  PVector center;
  float mass;
  float g;
  float radius;

  Atractor(float x, float y, float mass, float radius, AgentSystem system) {
    center = new PVector(x, y);
    this.mass = mass;
    this.system = system;
    this.radius = radius;
    g = 9.78;
  }

  void update() {
    for (Agent a : system.agents) {
      PVector r = PVector.sub(center, a.pos);
      if (r.mag() < radius) {
        float d2 = constrain(r.magSq(), 1, 2000);
        r.normalize();
        r.mult(g * mass * a.mass / d2);
        a.addForce(r);
      }
    }
  }
  
  void display() {
    noStroke();
    fill(color(136, 255, 139, 150));
    circle(center.x, center.y, radius*2);
  }
}


class Repeledor extends Atractor {
  
  
  Repeledor(float x, float y, float mass, float radius, AgentSystem system) {
    super(x, y, mass, radius, system);
    g *= -1;
  }
  
  void display() {
    noStroke();
    fill(color(255, 140, 137, 150));
    circle(center.x, center.y, radius*2);
  }
}

class RepeledorCuadrado {
  AgentSystem system;
  PVector center;
  float mass;
  float g;
  float ancho;
  float alto;
  
  RepeledorCuadrado(float x, float y, float mass, float ancho, float alto, AgentSystem system){
    center = new PVector(x, y);
    this.mass = mass;
    this.system = system;
    g = 9.78;
    this.ancho = ancho;
    this.alto = alto;
  }
  
  private boolean isIn(Agent a){
    return center.x < a.pos.x;
  }
  
  void update(){
    for (Agent a : system.agents) {
      PVector r = PVector.sub(center, a.pos);
      if (isIn(a)) {
        float d2 = constrain(r.magSq(), 1, 2000);
        r.normalize();
        r.mult(g * mass * a.mass / d2);
        a.addForce(r);
      }
    }
  }
}
