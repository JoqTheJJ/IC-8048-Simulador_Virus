
class FoodAttractor{
  AgentSystem system;
  PVector pos;
  float radio;
  Tienda t;
  
  FoodAttractor(Tienda t, AgentSystem system){
    this.t = t;
    pos = new PVector(t.centerX, t.centerY);
    this.system = system;
    radio = 50;
  }
  
  void display(){
    noStroke();
    fill(0, 5, 242, 50);
    circle(pos.x, pos.y, radio*2);
  }
  
  private boolean isIn(Agent a){
    return radio + a.radio > dist(pos.x, pos.y, a.pos.x, a.pos.y);
  }
  
  void update(){
    for (Agent a : system.agents) {
      if (a.eHambre != Hambre.COMIENDO && a.eHambre != Hambre.COMPRANDO && isIn(a)) {
        a.eHambre = Hambre.COMPRANDO;
        a.numTienda = t.n;
        a.tiempoCompra = (int)random(120, 300);
      }
    }
  }
}

class Atractor extends Repeledor{  
  
  Atractor(float x, float y, float ancho, float alto, float force, PVector dir, AgentSystem system){
    super(x, y, ancho, alto, force, dir, system);
    c = color(136, 255, 139, 150);
  }
  
  void update(){
    for (Agent a : system.agents) {
      if (super.isIn(a)) {
        PVector f = dir.copy();
        f.mult(force * a.mass);
        f.limit(a.maxSteeringForce);
        a.addForce(f);
      }
    }
  }
}


class Repeledor {
  AgentSystem system;
  PVector center;
  PVector pos;
  PVector dir;
  float force;
  float ancho;
  float alto;
  color c;
  
  
  Repeledor(float x, float y, float ancho, float alto, float force, PVector dir, AgentSystem system){
    pos = new PVector(x, y);
    center = new PVector(x+(ancho/2), y+(alto/2));
    this.force = force;
    this.system = system;
    this.ancho = ancho;
    this.alto = alto;
    this.dir = dir.mult(force);
    c = color(255, 140, 137, 150);
  }
  
  private boolean isIn(Agent a){
    return pos.x < a.pos.x + a.radio
    && a.pos.x - a.radio < pos.x + ancho
    && pos.y             < a.pos.y + a.radio
    && a.pos.y - a.radio < pos.y + alto;
  }
  
  void update(){
    for (Agent a : system.agents) {
      if (isIn(a)) {
        PVector f = dir.copy();
        f.mult(force * a.mass);
        a.addForce(f);
      }
    }
  }
  
  void display(){
    noStroke();
    fill(c);
    rect(pos.x, pos.y, ancho, alto);
  }
}
