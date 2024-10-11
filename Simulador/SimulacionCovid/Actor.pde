enum Rol {
  CANTANTE,
  SECUNDARIO,
  BATERISTA,
  GUITARRISTA,
  TECLADISTA,
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
        cantantePrincipal();
        break;
        
      case SECUNDARIO:
        cantanteSecundario();
        break;
        
      case BATERISTA:
        baterista();
        break;
        
      case GUITARRISTA:
        guitarrista();
        break;
        
      case TECLADISTA:
        tecladista();
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
  
  
  void cantantePrincipal(){
    offsetX = map(noise(noiseXOffset), 0, 1, -15, 55);
    offsetY = map(noise(noiseYOffset), 0, 1, -35, 35);
    
    noiseXOffset += 0.004;
    noiseYOffset += 0.005;
  }
  
  void cantanteSecundario(){
    offsetX = map(noise(noiseXOffset), 0, 1, -10, 30);
    offsetY = map(noise(noiseYOffset), 0, 1, -25, 25);
    
    noiseXOffset += 0.003;
    noiseYOffset += 0.004;
  }
  
  void guitarrista(){
    offsetX = map(noise(noiseXOffset), 0, 1, -10, 20);
    offsetY = map(noise(noiseYOffset), 0, 1, -15, 15);
    
    noiseXOffset += 0.02;
    noiseYOffset += 0.01;
  }
  
  void tecladista(){
    offsetX = 0;
    offsetY = map(noise(noiseYOffset), 0, 1, -10, 10);
    
    noiseYOffset += 0.02;
  }
  
  void baterista(){
    offsetX = map(noise(noiseXOffset), 0, 1, 0, 5);
    offsetY = map(noise(noiseYOffset), 0, 1, -5, 5);
    
    noiseXOffset += 0.021;
    noiseYOffset += 0.022;
  }
  
  void noMovement(){
    offsetX = 0;
    offsetY = 0;
  }
}
