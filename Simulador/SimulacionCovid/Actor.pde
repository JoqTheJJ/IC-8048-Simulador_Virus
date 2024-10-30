enum Rol {
  CANTANTE,
  SECUNDARIO,
  BATERISTA,
  GUITARRISTA,
  TECLADISTA,
  GUARDA,
  OTRO
}



class Actor{
  PVector pos;
  float radio = 10;
  
  color c;
  Rol rol;
  float offsetX;
  float offsetY;
  
  //noise
  float noiseXOffset = random(100);
  float noiseYOffset = random(100);
  
  Actor(float x, float y, color c, Rol rol){
    pos = new PVector(x, y);
    this.c = c;
    this.rol = rol;
    
    offsetX = 0;
    offsetY = 0;
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);

    fill(c);
    circle(pos.x + offsetX, pos.y + offsetY, radio*2);
    
    fill(#000000);
    if (rol == Rol.GUARDA){
      rect(pos.x-9   + offsetX, pos.y-4 + offsetY, 18, 0.5);
      rect(pos.x-4.5   + offsetX, pos.y-4 + offsetY, 3, 4);
      rect(pos.x+2.5 + offsetX, pos.y-4 + offsetY, 3, 4);
      strokeWeight(0);
      fill(#FFFFFF);
      rect(pos.x-4.5   + offsetX, pos.y-4 + offsetY, 2, 2);//Brillo
      rect(pos.x+2.5   + offsetX, pos.y-4 + offsetY, 2, 2);//Brillo
      fill(#000000);
      arc(pos.x+ offsetX, pos.y+ offsetY +3, radio*1.8, radio*1.8, 0, PI, CHORD); //Traje
    } else {
      rect(pos.x-3 + offsetX, pos.y-4 + offsetY, 0.5, 0.7); //Ojos
      rect(pos.x+3 + offsetX, pos.y-4 + offsetY, 0.5, 0.7); //Ojos
    }
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
    offsetY = map(noise(noiseYOffset), 0, 1, -10, 10);
    
    noiseYOffset += 0.02;
  }
  
  void baterista(){
    offsetX = map(noise(noiseXOffset), 0, 1, 0, 5);
    offsetY = map(noise(noiseYOffset), 0, 1, -5, 5);
    
    noiseXOffset += 0.02;
    noiseYOffset += 0.03;
  }
  
  void noMovement(){
    
  }
}
