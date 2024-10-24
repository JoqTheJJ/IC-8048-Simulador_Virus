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

class RepeledorMuroHorizontal {
  AgentSystem system;
  PVector center;
  PVector pos;
  PVector force;
  float mass;
  float g;
  float ancho;
  float alto;
  
  
  RepeledorMuroHorizontal(float x, float y, float mass, float ancho, float alto, PVector force, AgentSystem system){
    pos = new PVector(x, y);
    center = new PVector(x+(ancho/2), y+(alto/2));
    this.mass = mass;
    this.system = system;
    g = 2;
    this.ancho = ancho;
    this.alto = alto;
    this.force = force.mult(g);
  }
  
  private boolean isIn(Agent a){
    return pos.x < a.pos.x
    && a.pos.x < pos.x + ancho
    && pos.y < a.pos.y
    && a.pos.y < pos.y + alto;
  }
  
  void update(){
    for (Agent a : system.agents) {
      if (isIn(a)) {
        PVector dVector = PVector.sub(center, a.pos);
        float d2 = constrain(dVector.magSq(), 1, 2000);
        PVector f = force.copy();
        f.mult(g * mass * a.mass / d2);
        a.addForce(f);
      }
    }
  }
  
  void display(){
    noStroke();
    fill(color(255, 140, 137, 150));
    rect(pos.x, pos.y, ancho, alto);
    circle(center.x, center.y, 10);
  }
}
