enum Rol {
  CANTANTE,
  BATERISTA,
  GUITARRISTA,
  OTRO
}

class Actor extends Agent{
  
  color c;
  Rol rol;
  float offsetX;
  float offsetY;
  
  //noise
  float noiseXOffset = random(100);
  float noiseYOffset = random(100);
  
  Actor(float x, float y, color c, Rol rol){
    super(x, y, false, 1, State.UNAVAILABLE);
    vel.setMag(0);
    this.c = c;
    this.rol = rol;
    
    offsetX = 0;
    offsetY = 0;
  }
  
  
  void run(){
    switch(rol){
      case CANTANTE:
        cantante();
        break;
        
      case BATERISTA:
        noMovement();
        break;
        
      case GUITARRISTA:
        guitarrista();
        break;
        
      case OTRO:
        noMovement();
        break;
        
      default:
        noMovement();
    }
    display();
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);

    fill(c);
    circle(pos.x + offsetX, pos.y + offsetY, radio*2);
  }
  
  
  void cantante(){
    offsetX = map(noise(noiseXOffset), 0, 1, -35, 35);
    offsetY = map(noise(noiseYOffset), 0, 1, -35, 35);
    
    noiseXOffset += 0.005;
    noiseYOffset += 0.005;
  }
  
  void guitarrista(){
    offsetX = map(noise(noiseXOffset), 0, 1, -15, 15);
    offsetY = map(noise(noiseYOffset), 0, 1, -15, 15);
    
    noiseXOffset += 0.01;
    noiseYOffset += 0.01;
  }
  
  void noMovement(){
    offsetX = 0;
    offsetY = 0;
  }
}
