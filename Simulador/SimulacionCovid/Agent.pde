enum State {
  CONCERT,    //Shouting and being in the concert
  WANDER,     //Walking around slowly and aimlessly
  STILL,      //Still or sitting without motion
  UNAVAILABLE //Bathroom state where no activity is shown
}

enum ColorMode {
  INFECTION,
  MASK
}

ArrayList<Integer> colorsInfection;
void addColorsInfection(){
  colorsInfection = new ArrayList();
  colorsInfection.add(color(10, 154, 67));  //Verde
  colorsInfection.add(color(103, 186, 61)); //Verde claro
  colorsInfection.add(color(168, 208, 57)); //Verde muy claro
  colorsInfection.add(color(247, 230, 51)); //Amarillo
  colorsInfection.add(color(240, 159, 44)); //Naranja claro
  colorsInfection.add(color(232, 83, 37));  //Naranja oscuro
  colorsInfection.add(color(222, 38, 38));  //Rojo
}

ArrayList<Integer> colorsMask;
void addColorsMask(){
  colorsMask = new ArrayList();
  colorsMask.add(#FFFFFF); //Blanco
  colorsMask.add(#337CFF); //Azul Claro
  colorsMask.add(#0A3BD8); //Azul
}

class Agent{
  
  boolean debug = false;
  
  // Variables Movimiento
  PVector pos;
  PVector lastPos;
  PVector vel;
  PVector acc;
  float maxSpeed = 3;
  
  float radio = 10;
  float damp = 1;
  float mass = 1;
  
  //Variables movimiento autonomo
  float maxSteeringForce = 0.1;
  
  float arrivalRadius = 150;
  
  float wanderLookAhead = 30;
  float wanderRadius = 15;
  float wanderNoiseT = random(0,100);
  float wanderNoiseTInc = 0.005;
  
  
  // Variables
  State estado;
  
  
  
  // Variables Contagio
  float eficienciaMascarilla;
  
  float quanta;           // Que tan enfermo esta
  float quantaMaxima = 3; // Limite para que se enferme
  
  
  
  
  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################
  
  Agent(float x, float y, boolean infectado, float eficienciaMascarilla, State estado){
    pos = new PVector(x, y);
    lastPos = pos.copy();
    vel = PVector.random2D().setMag(3);
    acc = new PVector(0, 0);
    
    vel.limit(maxSpeed);
    
    this.eficienciaMascarilla = eficienciaMascarilla;
    
    this.estado = estado;
    
    if(infectado){
      quanta = quantaMaxima;
    } else {
      quanta = 0;
    }
  }
  
  void run(){
    
    borders();
    
    lastPos = pos.copy();
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    strokeWeight(3);
    stroke(#000000);
    

    int c = int(map(quanta, 0, 3, 0, 5));
    c = min(c, 5);
    if (quanta >= quantaMaxima)
      c = 6;
    fill(colorsInfection.get(c));
    circle(pos.x, pos.y, radio*2);
    
    fill(#000000);
    square(pos.x-3, pos.y-3, 0.6); //Ojos
    square(pos.x+3, pos.y-3, 0.6); //Ojos
    
    if(colorMode == ColorMode.MASK){
      int m = int(map(eficienciaMascarilla, 0, 1, 0, 4));
      
      if(m > 0){
        fill(colorsMask.get(m-1));
        
        strokeWeight(1);
        line(pos.x-radio, pos.y     , pos.x+radio, pos.y);
        line(pos.x-radio, pos.y +2.5, pos.x+radio, pos.y +2.5);
        arc(pos.x, pos.y, radio*1.3, radio*1.3, 0, PI, CHORD);
      }
    }
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);
    
    int c = int(map(quanta, 0, 3, 0, 5));
    c = min(c, 5);
    if (quanta >= quantaMaxima)
      c = 6;
    fill(colorsInfection.get(c));
    circle(pos.x, pos.y, radio*2);
    
    fill(#000000);
    rect(pos.x-3, pos.y-4, 0.5, 0.7); //Ojos
    rect(pos.x+3, pos.y-4, 0.5, 0.7); //Ojos
    
    if(colorMode == ColorMode.MASK){
      int m = int(map(eficienciaMascarilla, 0, 1, 0, 4));
      
      if(m > 0){
        fill(colorsMask.get(m-1));
        
        strokeWeight(1);
        line(pos.x-radio, pos.y     , pos.x+radio, pos.y);
        line(pos.x-radio, pos.y +2.5, pos.x+radio, pos.y +2.5);
        arc(pos.x, pos.y, radio*1.3, radio*1.3, 0, PI, CHORD);
      }
    }
  }
  
  
  
  // ############################  ############################
  // ################### METODOS MOVIMIENTO ###################
  // ############################  ############################
  
  void addForce(PVector f) {
    PVector dif = f.copy();
    dif.div(mass);
    acc.add(dif);
  }
  
  void seek(float x, float y) {
    PVector target = new PVector(x, y);
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxSteeringForce);
    addForce(steering);
  }
  
  void arrive(float x, float y) {
    PVector target = new PVector(x, y);
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    float dist = pos.dist(target);
    if (dist <= arrivalRadius) {
      vel.limit(max(0, map(dist, 0, arrivalRadius, 0, maxSpeed)));
    }
    steering.limit(maxSteeringForce);
    addForce(steering);
  }
  
  void wander() {
    PVector future = vel.copy();
    future.setMag(wanderLookAhead);
    future.add(pos);
    if (debug) {
      stroke(255);
      strokeWeight(1);
      line(pos.x, pos.y, future.x, future.y);
      noFill();
      ellipse(future.x, future.y, wanderRadius * 2, wanderRadius * 2);
    }
    PVector target = vel.copy();
    target.setMag(wanderRadius);
    target.rotate(map(noise(wanderNoiseT), 0, 1, -PI -HALF_PI, PI + HALF_PI));
    wanderNoiseT += wanderNoiseTInc;
    target.add(future);
    
    if (debug) {
      strokeWeight(6);
      point(target.x, target.y);
    }
    seek(target.x, target.y);
  }
  
  // ############################  ############################
  // #################### METODOS CONTAGIO ####################
  // ############################  ############################
  
  boolean infectado(){
    return quanta >= quantaMaxima;
  }
  
  float calcularTasaExhalacion(){
    float tasaExhalacion;
    switch (estado){
      case CONCERT:
      //Realizar ejercicio moderado
        tasaExhalacion = 170;
        break;
        
      case WANDER:
      //Caminar lentamente + alteracion
        tasaExhalacion = 11.4;
        break;
        
      case STILL:
      //Estar parado
        tasaExhalacion = 2.3;
        break;
        
      case UNAVAILABLE:
      //Ausencia de presencia
        tasaExhalacion = 0;
        break;
        
      default:
        println("Estado del agente invalido en exhalacion");
        tasaExhalacion = 0;
    }
    
    return tasaExhalacion * (1 - eficienciaMascarilla);
  }
  
  float calcularTasaInhalacion(){
    float tasaInhalacion;
    switch (estado){
      case CONCERT:
      //Realizar ejercicio moderado
        tasaInhalacion = 2.75;
        break;
        
      case WANDER:
      //Caminar lentamente + alteracion
        tasaInhalacion = 0.92;
        break;
        
      case STILL:
      //Estar parado
        tasaInhalacion = 0.54;
        break;
        
      case UNAVAILABLE:
      //Ausencia de presencia
        tasaInhalacion = 0;
        break;
        
      default:
        println("Estado del agente invalido en inhalacion");
        tasaInhalacion = 9999;
    }
    
    return tasaInhalacion * (1 - eficienciaMascarilla);
  }
  
  void contagiar(float quantaInhalada){
    quanta += quantaInhalada;
  }
  
  
  
  // ############################ #############################
  // ######################## BORDERS #########################
  // ############################ #############################
  
  
  
  void borders() {
    PVector dir = PVector.sub(lastPos, pos);
    
    if (pos.x < radio || pos.x > width - radio) {
      pos.x = constrain(pos.x, radio, width - radio);
      vel.x *= -damp;
    }
    if (pos.y < radio || pos.y > height - radio) {
      pos.y = constrain(pos.y, radio, height - radio);
      vel.y *= -damp;
    }
    
    
    
    
    //Scenario
    if (pos.y-radio > height/2-210 && pos.x -radio < 300){//Hay colision
      //Colision lateral
      pos.x = 300 + radio;
      vel.x *= -damp;
    }
    
    float w1X = 0;               //CoordenadaX del muro 1
    float w1Y = height/2 - 210;  //CoordenadaY del muro 1
    float w1W = width/2;         //Ancho del muro 1
    float w1H = 10;              //Altura del muro 1
    if (pos.x + radio > w1X && pos.x - radio < w1X + w1W &&
      pos.y + radio > w1Y && pos.y - radio < w1Y + w1H) {//Hay colision
      if (w1Y < lastPos.y+radio && w1Y+w1H > lastPos.y-radio && dir.x > 0){//Colison izquierda
        pos.x = constrain(pos.x, w1X+radio, width);
        vel.x *= -damp;
      } //No hay colision derecha

      if (dir.y > 0) {//Colision inferior
        pos.y = constrain(pos.y, w1Y+w1H-radio+5, height);
        vel.y *= -damp;
      } else {//Colision superior
        pos.y = constrain(pos.y, 0, w1Y+radio-5);
        vel.y *= -damp;
      }
      
    }
    
    float w2X = width/2 +100;   //CoordenadaX del muro 2
    float w2Y = height/2 -210;  //CoordenadaY del muro 2
    float w2W = width/2 -100;   //Ancho del muro 2
    float w2H = 10;             //Altura del muro 2
    if (pos.x + radio > w2X && pos.x - radio < w2X + w2W &&
      pos.y + radio > w2Y && pos.y - radio < w2Y + w2H) {//Hay colision
      if (w2Y < lastPos.y+radio && w2Y+w2H > lastPos.y-radio && dir.x < 0){//Colison izquierda
        pos.x = constrain(pos.x, 0, w2X-radio);
        vel.x *= -damp;
      } //No hay colision derecha

      if (dir.y > 0) {//Colision inferior
        pos.y = constrain(pos.y, w2Y+w2H-radio+5, height);
        vel.y *= -damp;
      } else {//Colision superior
        pos.y = constrain(pos.y, 0, w2Y+radio-5);
        vel.y *= -damp;
      }
      
    }
    
    float w3X = width*3/4;       //CoordenadaX del muro 3
    float w3Y = height/2 -200 +2*radio;   //CoordenadaY del muro 3
    float w3W = 10;              //Ancho del muro 3
    float w3H = 260;             //Altura del muro 3
    if (pos.x + radio > w3X && pos.x - radio < w3X + w3W &&
      pos.y + radio > w3Y && pos.y - radio < w3Y + w3H) {//Hay colision
      if(dir.x > 0) {
        pos.x = constrain(pos.x, w3X-radio-5, width);
        vel.x *= -damp;
      } else {
        pos.x = constrain(pos.x, 0, w3X+radio+5);
        vel.x *= -damp;
      }
      
      if(lastPos.x+radio > w3X && lastPos.x-radio < w3X+w3W && dir.y > 0){
        pos.y = constrain(pos.y, w3Y+radio+5, height);
        vel.y *= -damp;
      }
    }
    
    float w4X = width*3/4;       //CoordenadaX del muro 4
    float w4Y = height/2 +150;   //CoordenadaY del muro 4
    float w4W = 10;              //Ancho del muro 4
    float w4H = height/2 -150;   //Altura del muro 4
    if (pos.x + radio > w4X && pos.x - radio < w4X + w4W &&
      pos.y + radio > w4Y && pos.y - radio < w4Y + w4H) {//Hay colision
      if(dir.x > 0) {
        pos.x = constrain(pos.x, w4X-radio-5, width);
        vel.x *= -damp;
      } else {
        pos.x = constrain(pos.x, 0, w4X+radio+5);
        vel.x *= -damp;
      }
      
      if(lastPos.x+radio > w4X && lastPos.x-radio < w4X+w4W && dir.y < 0){
        pos.y = constrain(pos.y, 0, w4Y-radio-5);
        vel.y *= -damp;
      }
    }
    
    
  }
  
}
