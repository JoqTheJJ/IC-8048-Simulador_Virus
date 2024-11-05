enum Rol {
  CANTANTE,
  BAJISTA,
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
  
  int bebida;
  int cooldown;
  
  //noise
  float noiseXOffset = random(100);
  float noiseYOffset = random(100);
  
  Actor(float x, float y, color c, Rol rol){
    pos = new PVector(x, y);
    this.c = c;
    this.rol = rol;
    
    offsetX = 0;
    offsetY = 0;
    
    bebida = 0;
    cooldown = (int)random(300, 900);
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);

    fill(c);
    circle(pos.x + offsetX, pos.y + offsetY, radio*2);

    
    strokeWeight(3);
    fill(#000000);
    if (rol == Rol.GUARDA) {
      rect(pos.x-9   + offsetX, pos.y-4 + offsetY, 18, 0.5);
      rect(pos.x-4.5   + offsetX, pos.y-4 + offsetY, 3, 4);
      rect(pos.x+2.5 + offsetX, pos.y-4 + offsetY, 3, 4);
      strokeWeight(0);
      fill(#FFFFFF);
      rect(pos.x-4.5   + offsetX, pos.y-4 + offsetY, 2, 2);//Brillo
      rect(pos.x+2.5   + offsetX, pos.y-4 + offsetY, 2, 2);//Brillo
      fill(#000000);
      arc(pos.x+ offsetX, pos.y+ offsetY +3, radio*1.8, radio*1.8, 0, PI, CHORD); //Traje
      
      if (bebida > 0) {
        if (!pause) {
          bebida--;
        }
        cooldown = (int)random(600, 1800);
        strokeWeight(2);
        stroke(#000000);
        fill(#FF0000);
        rect(pos.x + radio - 4, pos.y +1, 7, 10); //Vaso
        strokeWeight(1);
        fill(#D8D8D8);
        rect(pos.x + radio - 4, pos.y +1, 7, 2.5); //Tapa
        fill(#FFFFFF);
        rect(pos.x + radio - 1, pos.y -3, 2, 4); //Pajilla
      } else {
        if (!pause) {
          cooldown--;
        }
        if (cooldown < 0) {
          bebida = (int)random(600, 900);
        }
      }
    } else {
      fill(#000000);
      rect(pos.x-3 + offsetX, pos.y-4 + offsetY, 0.5, 0.7); //Ojos
      rect(pos.x+3 + offsetX, pos.y-4 + offsetY, 0.5, 0.7); //Ojos
    }
    
    if (rol == Rol.CANTANTE) { //Microfono
      strokeWeight(2);
      fill(#9B9B9B);
      rect(pos.x +offsetX +5, pos.y +offsetY +3, 3.8, 8);
      strokeWeight(2);
      fill(#2C2C2C);
      circle(pos.x +offsetX +7, pos.y +offsetY +3, 7);
    }
    
    if (rol == Rol.BAJISTA) { //Bajo
      PVector pos = new PVector(this.pos.x, this.pos.y + 5);

      fill(c);
      
      strokeWeight(2);
      circle(pos.x+offsetX - 2, pos.y+offsetY + 2, 12);
      
      strokeWeight(1);
      circle(pos.x+offsetX - 2, pos.y+offsetY + 2, 6);
      
      stroke(0);
      strokeWeight(6);
      line(pos.x+offsetX - 3  , pos.y+offsetY + 3, pos.x+offsetX + 13  , pos.y+offsetY - 13);
      
      stroke(c);
      strokeWeight(4);
      line(pos.x+offsetX - 4  , pos.y+offsetY + 4, pos.x+offsetX + 13  , pos.y+offsetY - 13);
      
      stroke(0);
      strokeWeight(1);
      line(pos.x+offsetX - 6  , pos.y+offsetY + 4, pos.x+offsetX + 13, pos.y+offsetY - 15);
      line(pos.x+offsetX - 5  , pos.y+offsetY + 5, pos.x+offsetX + 15, pos.y+offsetY - 15);
      line(pos.x+offsetX - 4  , pos.y+offsetY + 6, pos.x+offsetX + 15, pos.y+offsetY - 13);
    }
    
    if (rol == Rol.GUITARRISTA) { //Guitarra
      PVector pos = new PVector(this.pos.x, this.pos.y + 5);
      fill(c);
      strokeWeight(1);
      beginShape();
      vertex(pos.x+offsetX - 5  , pos.y+offsetY + 5);
      vertex(pos.x+offsetX - 12 , pos.y+offsetY + 3);
      
      vertex(pos.x+offsetX - 4  , pos.y+offsetY - 2);
      vertex(pos.x+offsetX + 10, pos.y+offsetY - 12);
      
      vertex(pos.x+offsetX + 10, pos.y+offsetY - 15);
      vertex(pos.x+offsetX + 15  , pos.y+offsetY - 15);
      vertex(pos.x+offsetX + 15, pos.y+offsetY - 10);
      
      vertex(pos.x+offsetX + 12, pos.y+offsetY - 10);
      vertex(pos.x+offsetX + 2  , pos.y+offsetY + 4);
      
      vertex(pos.x+offsetX - 2  , pos.y+offsetY + 12);
      endShape(CLOSE);
      
      fill(#904289);
      circle(pos.x+offsetX - 2, pos.y+offsetY + 2, 6);
      
      line(pos.x+offsetX - 7  , pos.y+offsetY + 4, pos.x+offsetX + 13  , pos.y+offsetY - 15);
      line(pos.x+offsetX - 5  , pos.y+offsetY + 5, pos.x+offsetX + 15  , pos.y+offsetY - 15);
      line(pos.x+offsetX - 4  , pos.y+offsetY + 7, pos.x+offsetX + 15  , pos.y+offsetY - 13);
    }
  }
  
  void run() {
    switch(rol) {
      case CANTANTE:
        cantantePrincipal();
        break;
        
      case BAJISTA:
        bajista();
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
  
  
  void cantantePrincipal() {
    offsetX = map(noise(noiseXOffset), 0, 1, -15, 55);
    offsetY = map(noise(noiseYOffset), 0, 1, -35, 35);
    
    noiseXOffset += 0.004;
    noiseYOffset += 0.005;
  }
  
  void bajista() {
    offsetX = map(noise(noiseXOffset), 0, 1, -10, 30);
    offsetY = map(noise(noiseYOffset), 0, 1, -25, 25);
    
    noiseXOffset += 0.003;
    noiseYOffset += 0.004;
  }
  
  void guitarrista() {
    offsetX = map(noise(noiseXOffset), 0, 1, -10, 20);
    offsetY = map(noise(noiseYOffset), 0, 1, -15, 15);
    
    noiseXOffset += 0.02;
    noiseYOffset += 0.01;
  }
  
  void tecladista() {
    offsetY = map(noise(noiseYOffset), 0, 1, -10, 10);
    
    noiseYOffset += 0.02;
  }
  
  void baterista() {
    offsetX = map(noise(noiseXOffset), 0, 1, 0, 5);
    offsetY = map(noise(noiseYOffset), 0, 1, -5, 5);
    
    noiseXOffset += 0.02;
    noiseYOffset += 0.03;
  }
  
  void noMovement() {
  }
}
