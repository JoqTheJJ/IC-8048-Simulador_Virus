enum Comida {
  HAMBURGUESA,
  BEBIDA
}

class Tienda{
  float centerX;
  float centerY;
  float alto  = 50;
  float ancho = 100;
  float x;
  float y;
  int n;
  Comida c;
  
  Tienda(float x, float y, Comida c, int n){
    this.n = n;
    this.x = x;
    this.y = y;
    this.c = c;
    centerX = x + ancho/2;
    centerY = y + alto;
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);
    
    
    //Tienda
    if (c == Comida.HAMBURGUESA){
      fill(#F0A22E);
      rect(x, y, ancho, alto);
      
      pushMatrix();
      
      translate(x + ancho/16, y + alto/2);
      rotate(-QUARTER_PI/2);
      
      strokeWeight(3);
      stroke(#000000);
      fill(#FFD089);
      rect(0, 0, 12, 6); //Pan
      rect(0, 11, 12, 6); //Pan
      fill(#5D0909);
      rect(0, 6, 12, 5); //Carne
      
      rotate(QUARTER_PI/2);
      translate(12.25*ancho/16 +2, -4);
      rotate(QUARTER_PI/2);
      
      strokeWeight(3);
      stroke(#000000);
      fill(#FFD089);
      rect(0, 0, 12, 6); //Pan
      rect(0, 11, 12, 6); //Pan
      fill(#5D0909);
      rect(0, 6, 12, 5); //Carne
      
      popMatrix();
      
      
    } else {
      fill(#2EF0EB);
      rect(x, y, ancho, alto);
      
      pushMatrix();
      
      translate(x + ancho/16, y + alto/2);
      
      strokeWeight(3);
      stroke(#000000);
      fill(#FF0000);
      rect(0, 0, 10, 15); //Vaso
      fill(#D8D8D8);
      rect(-1, 0, 12, 5); //Tapa
      fill(#FFFFFF);
      rect(3, -6, 4, 6); //Pajilla
      
      translate(12.25*ancho/16, 0);
      
      strokeWeight(3);
      stroke(#000000);
      fill(#FF0000);
      rect(0, 0, 10, 15); //Vaso
      fill(#D8D8D8);
      rect(-1, 0, 12, 5); //Tapa
      fill(#FFFFFF);
      rect(3, -6, 4, 6); //Pajilla

      popMatrix();
    }
    
    
    
    //Ventana
    strokeWeight(3);
    stroke(#000000);
    
    fill(#000000);
    rect(x + 25, y + 10, ancho - 50, alto - 30);
    
    
    
    //Chef
    float cY = 27;
    fill(#79F211);
    circle(centerX, cY, 20);
    fill(#000000);
    rect(centerX-3, cY-4, 0.5, 0.7);//Ojos
    rect(centerX+3, cY-4, 0.5, 0.7);//Ojos
    fill(#FFFFFF);
    rect(centerX-4, cY-18, 8, 10);
    
    
    
    //Mostrador
    noStroke();
    if (c == Comida.HAMBURGUESA){
      fill(#F0A22E);
    } else {
      fill(#2EF0EB);
    }
    rect(x+ancho/4, cY + 5, ancho/2, alto/2 - 9);
  }
}



class Fila{
  
  PVector[] posiciones;
  int numPosiciones = 188;
  PVector max = new PVector(width*3/4+5 + 450, 370);
  int col = 0;
  
  //Center
  PVector c = new PVector(width*3/4+5, height/2 +100);
  
  
  Fila(){
    posiciones = new PVector[numPosiciones];
    
    int i;
    posiciones[0] = new PVector(c.x, c.y);
    
    for (i = 1; i < 16; i++){//Pone 15
      posiciones[i] = new PVector(c.x + 30, c.y + (i-1)*30);
    }
    
    //Columna arriba
    posiciones[i] = new PVector(c.x + 60, c.y + 420);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 90, c.y + 420 - j*30);
      i++;
    }
    
    //Columna abajo
    posiciones[i] = new PVector(c.x + 120, 370);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 150, 370 + j*30);
      i++;
    }
    
    //Columna arriba
    posiciones[i] = new PVector(c.x + 180, c.y + 420);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 210, c.y + 420 - j*30);
      i++;
    }
    
    //Columna abajo
    posiciones[i] = new PVector(c.x + 240, 370);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 270, 370 + j*30);
      i++;
    }
    
    //Columna arriba
    posiciones[i] = new PVector(c.x + 300, c.y + 420);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 330, c.y + 420 - j*30);
      i++;
    }
    
    //Columna abajo
    posiciones[i] = new PVector(c.x + 360, 370);// +1
    i++;
    for (int j = 0; j < 24; j++){//Pone 24
      posiciones[i] = new PVector(c.x + 390, 370 + j*30);
      i++;
    }
    
    //Columna arriba
    posiciones[i] = new PVector(c.x + 420, c.y + 420);// +1
    i++;
    for (int j = 0; j < 21; j++){//Pone 21
      posiciones[i] = new PVector(c.x + 450, c.y + 420 - j*30);
      i++;
    }
  }
  
  void display(){
    noStroke();
    col = (frameCount/60) % 8;
    nextColor();
    
    for(int i = 1; i < numPosiciones; i++){
      PVector pos = posiciones[i];
      circle(pos.x, pos.y, 25);
      nextColor();
    }
  }
  
  void nextColor(){
    if (col == 0){
      fill(#FAEA56);//Amarillo
    } else if (col == 1){
      fill(#58FA56);//Verde
    } else if (col == 2){
      fill(#56F6FA);//Celeste
    } else if (col == 3){
      fill(#5884FA);//Azul
    } else if (col == 4){
      fill(#7B56FA);//Morado
    } else if (col == 5){
      fill(#FA56E7);//Rosado
    } else if (col == 6){
      fill(#FA5656);//Rojo
    } else if (col == 7){
      fill(#FAB056);//Naranja
    }
    col = (col - 1 + 8) % 8;
  }
}






class Scene{

  //Concert coordinates
  float concertX = 0;
  float concertY = height/2 -200;
  float concertW = 300;
  float concertH = height - concertY;
  
  //W1 Upper wall left
  float w1X = 0;
  float w1Y = height/2 - 210;
  float w1W = width/2;
  float w1H = 10;
  
  //W2 Upper wall right
  float w2X = width/2 +100;
  float w2Y = height/2 -210;
  float w2W = width/2 -100;
  float w2H = 10;
  
  //W3 Down wall up
  float w3X = width*3/4;
  float w3Y = height/2 -200;
  float w3W = 10;
  float w3H = 253;
  
  //W4 Down wall down
  float w4X = width*3/4;
  float w4Y = height/2 +158;
  float w4W = 10;
  float w4H = height/2 -150;
  
  //Radio del reflector
  ArrayList<Reflector> reflectores;
  float reflectorRadio = 200;
  float reflectorVelocidadBase = 2;
  
  //r1 Reflector 1
  float r1X = width/2 + 0;
  float r1Y = height/2 + 0;
  
  //r2 Reflector 2
  float r2X = width/2 + 150;
  float r2Y = height/2 + 150;
  
  //r3 Reflector 3
  float r3X = width/2 + 150;
  float r3Y = height/2 - 150;
  
  //r4 Reflector 4
  float r4X = width/2 - 150;
  float r4Y = height/2 + 150;
  
  //r5 Reflector 5
  float r5X = width/2 - 150;
  float r5Y = height/2 - 150;
  
  //Radio persona
  float radio = 10;
  float diametro = radio*2;
  
  //Ancho puerta = 100
  
  Scene(){
    reflectores = new ArrayList<Reflector>();
    
    reflectores.add(new Reflector(r1X, r1Y, reflectorRadio, reflectorVelocidadBase, color(255, 255, 255, 50)));
    reflectores.add(new Reflector(r2X, r2Y, reflectorRadio, reflectorVelocidadBase, color(0, 255, 255, 50)));
    reflectores.add(new Reflector(r3X, r3Y, reflectorRadio, reflectorVelocidadBase, color(255, 0, 192, 50)));
    reflectores.add(new Reflector(r4X, r4Y, reflectorRadio, reflectorVelocidadBase, color(0, 255, 40, 50)));
    reflectores.add(new Reflector(r5X, r5Y, reflectorRadio, reflectorVelocidadBase, color(252, 240, 0, 50)));
  }
  
  void update(){
    for (Reflector r : reflectores){
      r.update();
    }
  }
  
  void colorStats(){
    //Color stadistics
    strokeWeight(3);
    stroke(#000000);
    
    
    fill(#FF0000); //HAMBRIENTO
    rect(10, concertY + 40, 20, 20);
    text("HAMBRIENTO", 35, concertY + 60);
    
    fill(#FFC400); //COMPRANDO
    rect(10, concertY + 70, 20, 20);
    text("COMPRANDO", 35, concertY + 90);
    
    fill(#76FF00); //COMIENDO
    rect(10, concertY + 100, 20, 20);
    text("COMIENDO", 35, concertY + 120);
    
    fill(#00FFDF); //SATISFECHO
    rect(10, concertY + 130, 20, 20);
    text("SATISFECHO", 35, concertY + 150);
    
    fill(#FFFFFF); //UNAVAILABLE
    rect(10, concertY + 160, 20, 20);
    text("UNAVAILABLE", 35, concertY + 180);
    
    
    
    
    fill(#76FF00); //NOTTIRED
    rect(10, concertY + 200, 20, 20);
    text("NOTTIRED", 35, concertY + 220);
    
    fill(#FF0000); //TIRED
    rect(10, concertY + 230, 20, 20);
    text("TIRED", 35, concertY + 250);
    
    fill(#00FFEC); //RESTING
    rect(10, concertY + 260, 20, 20);
    text("RESTING", 35, concertY + 280);
    
    fill(#0017FF); //REFRESHED
    rect(10, concertY + 290, 20, 20);
    text("REFRESHED", 35, concertY + 310);
    
    fill(#FFFFFF); //UNAVAILABLE
    rect(10, concertY + 320, 20, 20);
    text("UNAVAILABLE", 35, concertY + 340);
  }
  
  void display(){

    noStroke();
    
    //Area del Concierto
    fill(#343434);
    rect(concertX, concertY, concertW, concertH);
    
    //Walls color
    fill(#A5A5A5);
    
    //W1 Upper wall left
    rect(w1X, w1Y, w1W, w1H);
    //W2 Upper wall right
    rect(w2X, w2Y, w2W, w2H);
    //W3 Down wall up
    rect(w3X, w3Y, w3W, w3H);
    //W4 Down wall down
    rect(w4X, w4Y, w4W, w4H);
    
    
    
    
    
    // ################################### //
    // ########## Instrumentos ########### //
    // ################################### //
    
    strokeWeight(3);
    stroke(#000000);


    //Bateria
    //Externa
    fill(#C1C1C1);
    circle(concertW/2 +30, (2*concertY+concertH)/2 +131  -30, diametro); // 2
    circle(concertW/2 +30, (2*concertY+concertH)/2 +149  -30, diametro); // 3
    //Interna
    fill(#F2F2F2);
    circle(concertW/2 +30, (2*concertY+concertH)/2 +131  -30, radio); // 2
    circle(concertW/2 +30, (2*concertY+concertH)/2 +149  -30, radio); // 3
    //Platillos
    fill(#FFC400);
    circle(concertW/2 +20, (2*concertY+concertH)/2 +160  -30, diametro*0.8); // 4
    circle(concertW/2 +20, (2*concertY+concertH)/2 +120  -30, diametro*0.8); // 1
    

    //Piano
    fill(#03FF11);
    strokeWeight(2);
    rect(concertW/2 +21, (2*concertY+concertH)/2 -140  -45, diametro*0.7, diametro*1.5);
    //Superficie
    fill(#FFFFFF);
    strokeWeight(0);
    rect(concertW/2 +23, (2*concertY+concertH)/2 -140  -42, diametro*0.4, diametro*1.2);
    //Teclas
    fill(#000000);
    rect(concertW/2 +23, (2*concertY+concertH)/2 -140  -28, radio*0.5, 3);
    rect(concertW/2 +23, (2*concertY+concertH)/2 -140  -23, radio*0.5, 3);
    rect(concertW/2 +23, (2*concertY+concertH)/2 -140  -35, radio*0.5, 3);
    rect(concertW/2 +23, (2*concertY+concertH)/2 -140  -40, radio*0.5, 3);
    
    //Luces
    for (Reflector r : reflectores){
      r.display();
    }
  }
  
  void upperWall(){
    strokeWeight(3);
    stroke(#A5A5A5);
    noStroke();
    fill(#A5A5A5);
    rect(0, 0, width, 50);
  }
}





class Reflector {
  PVector pos;
  PVector vel;
  float radio;
  color c;
  
  
  Reflector(float x, float y, float radio, float velocity, color c){
    pos = new PVector(x,y);
    float velX = random(1) > 0.5 ? 1 : -1;
    float velY = random(1) > 0.5 ? 1 : -1;
    vel = new PVector(velX, velY);
    vel.setMag(velocity + random(velocity));
    
    this.radio = radio;
    this.c = c;
  }
  
  void update(){
    pos.add(vel);
     
    if (pos.x < 0 || pos.x > width) {
      pos.x = constrain(pos.x, 0, width);
      vel.x *= -1;
    }
    if (pos.y < 0 || pos.y > height) {
      pos.y = constrain(pos.y, 0, height);
      vel.y *= -1;
    }
  }
  
  void display(){
    noStroke();
    fill(c);
    circle(pos.x, pos.y, radio*2);
  }
}
