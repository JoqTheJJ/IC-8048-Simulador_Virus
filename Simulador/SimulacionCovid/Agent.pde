enum State {
  CONCERT,    //Shouting and being in the concert
  WANDER,     //Walking around slowly and aimlessly
  STILL,      //Still or sitting without motion
  UNAVAILABLE //Bathroom state where no activity is shown
}

enum Humor {
  NOTTIRED,
  TIRED,
  RESTING,
  REFRESHED,
  UNAVAILABLE
}

enum Hambre {
  HAMBRIENTO,
  COMPRANDO,
  COMIENDO,
  SATISFECHO,
  UNAVAILABLE
}

class Agent {
  
  //Variables estado
  State estado;
  Humor humor;
  Hambre estadoHambre;
  //Medidores estado (0-100)
  float energia;
  float hambre;
  //Temporizadores
  int bebida;
  int hamburguesa;
  int comiendo;
  
  //Tienda
  int numTienda = 0;
  int tiempoCompra;
  
  // Variables Movimiento
  PVector pos;
  PVector vel;
  PVector acc;
  float maxSpeed = 1;
  float followSpeed;
  
  int filaPos = 0;
  
  float radio = 10;
  float damp = 1;
  float mass = 1;
  
  //Variables movimiento autonomo
  float maxSteeringForce = 0.005;
  float arrivalRadius = 50;

  float wanderLookAhead = 30;
  float wanderRadius = 4;
  float wanderNoiseT = random(0,100);
  float wanderNoiseTInc = 0.005;
  
  float alignmentRadio = 60;
  float alignmentRatio = 1;

  float separationRadio = 50;
  float separationRatio = 11;

  float cohesionRadio = 80;
  float cohesionRatio = 1;
  
  // Variables Contagio
  float eficienciaMascarilla;
  float quanta;           // Que tan enfermo esta
  float quantaMaxima = 3; // Limite para que se enferme
  
  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################
  
  Agent(float x, float y, boolean infectado, float eficienciaMascarilla, State estado, int posFila) {
    pos = new PVector(x, y);
    vel = PVector.random2D().setMag(1);
    //vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    vel.limit(maxSpeed);
    followSpeed = random(0.2, 0.7);
    
    this.eficienciaMascarilla = eficienciaMascarilla;
    this.estado = estado;
    filaPos = posFila;
    
    //Variables estado del agente
    energia = random(20, 80);
    hambre = random(20, 80);
    
    tiempoCompra = 0;
    bebida = 0;
    hamburguesa = 0;
    comiendo = 0;
    
    humor = Humor.NOTTIRED;
    estadoHambre = Hambre.SATISFECHO;
    
    if (infectado) {
      quanta = quantaMaxima;
    } else {
      quanta = 0;
    }
  }
  
  Agent(float x, float y, boolean infectado, float eficienciaMascarilla, State estado) {
    this(x, y, infectado, eficienciaMascarilla, estado, 0);
  }
  
  void run() {
    if (filaPos < 1) {
      borders();
    }
    
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    strokeWeight(3);
    stroke(#000000);
    
    //Nivel Energia
    if (humor == Humor.NOTTIRED) {
      if (energia < 0){
        humor = Humor.TIRED;
      }
      
    } else if (humor == Humor.RESTING){
      energia += random(0.03, 0.04);
      if (energia > 80){
        humor = Humor.REFRESHED;
      }
    } else if (humor == Humor.REFRESHED){
      energia += random(0.04, 0.05);
    }
    
    //Nivel Hambre
    if (estadoHambre == Hambre.COMPRANDO){
      tiempoCompra--;
      if (tiempoCompra < 0){
        hambre = random(80, 120);
        energia += random(50, 70);
        estadoHambre = Hambre.COMIENDO;
        comiendo = 300;
        if (numTienda % 2 == 0){
          hamburguesa = (int)random(1800, 7200);
        } else {
          bebida = (int)random(1800, 7200);
        }
      }
    }
    
    if (hambre < 0 && estadoHambre != Hambre.COMPRANDO){
      estadoHambre = Hambre.HAMBRIENTO;
    }
    
    comiendo--;
    if (comiendo == 0){
      estadoHambre = Hambre.SATISFECHO;
    }
    
    bebida--;      //Temporicador bebida
    hamburguesa--; //Temporicador hamburguesa
    
    energia     -= random(0.03);  //Stat energia
    hambre      -= random(0.025); //Stat hambre
    
    int c = int(map(quanta, 0, 3, 0, 5));
    c = min(c, 5);
    if (quanta >= quantaMaxima)
      c = 6;
    fill(colorsInfection.get(c));  //Color segun estado infeccion
    circle(pos.x, pos.y, radio*2); //Cuerpo
    
    fill(#000000);
    rect(pos.x-3, pos.y-4, 0.5, 0.7); //Ojos
    rect(pos.x+3, pos.y-4, 0.5, 0.7); //Ojos
    
    if (statShow) {
      //Stat Hambre Izquierda
      fill(hambreColor());
      rect(pos.x-10, pos.y+radio, 10, 10);
      
      //Stat Humor Derecha
      fill(humorColor());
      rect(pos.x, pos.y+radio, 10, 10);
    }
    
    if (bebida > 0) {
      strokeWeight(2);
      stroke(#000000);
      fill(#FF0000);
      rect(pos.x + radio - 4, pos.y, 7, 10); //Vaso
      strokeWeight(1);
      fill(#D8D8D8);
      rect(pos.x + radio - 4, pos.y, 7, 2.5); //Tapa
      fill(#FFFFFF);
      rect(pos.x + radio - 1, pos.y - 4, 2, 4); //Pajilla
    }
    
    if (hamburguesa > 0) {
      strokeWeight(1);
      stroke(#000000);
      fill(#FFD089);
      rect(pos.x - radio - 3, pos.y    , 7, 3); //Pan
      rect(pos.x - radio - 3, pos.y + 5, 7, 2); //Pan
      fill(#5D0909);
      rect(pos.x - radio - 3, pos.y + 3, 7, 2); //Carne
    }
    
    if(colorMode == ColorMode.MASK && eficienciaMascarilla > 0){
      int m = int(map(eficienciaMascarilla, 0, 1, 1, 4));
        
      fill(colorsMask.get(m-1));
        
      strokeWeight(1);
      line(pos.x-radio, pos.y     , pos.x+radio, pos.y);
      line(pos.x-radio, pos.y +2.5, pos.x+radio, pos.y +2.5);
      arc(pos.x, pos.y, radio*1.3, radio*1.3, 0, PI, CHORD);
    }
  }
  
  void display() {
    strokeWeight(3);
    stroke(#000000);
    
    int c = int(map(quanta, 0, 3, 0, 5));
    c = min(c, 5);
    if (quanta >= quantaMaxima)
      c = 6;
    fill(colorsInfection.get(c));  //Color segun estado infeccion
    circle(pos.x, pos.y, radio*2); //Cuerpo
    
    fill(#000000);
    rect(pos.x-3, pos.y-4, 0.5, 0.7); //Ojos
    rect(pos.x+3, pos.y-4, 0.5, 0.7); //Ojos
    
    if(statShow){
      //Stat Hambre Izquierda
      fill(hambreColor());
      rect(pos.x-10, pos.y+radio, 10, 10);
      
      //Stat Humor Derecha
      fill(humorColor());
      rect(pos.x, pos.y+radio, 10, 10);
    }
    
    if (bebida > 0) {
      strokeWeight(2);
      stroke(#000000);
      fill(#FF0000);
      rect(pos.x + radio - 4, pos.y, 7, 10); //Vaso
      strokeWeight(1);
      fill(#D8D8D8);
      rect(pos.x + radio - 4, pos.y, 7, 2.5); //Tapa
      fill(#FFFFFF);
      rect(pos.x + radio - 1, pos.y - 4, 2, 4); //Pajilla
    }
    
    if (hamburguesa > 0) {
      strokeWeight(1);
      stroke(#000000);
      fill(#FFD089);
      rect(pos.x - radio - 3, pos.y    , 7, 3); //Pan
      rect(pos.x - radio - 3, pos.y + 5, 7, 2); //Pan
      fill(#5D0909);
      rect(pos.x - radio - 3, pos.y + 3, 7, 2); //Carne
    }
    
    if (colorMode == ColorMode.MASK && eficienciaMascarilla > 0) {
      int m = int(map(eficienciaMascarilla, 0, 1, 1, 4));
        
      fill(colorsMask.get(m-1));
        
      strokeWeight(1);
      line(pos.x-radio, pos.y     , pos.x+radio, pos.y);
      line(pos.x-radio, pos.y +2.5, pos.x+radio, pos.y +2.5);
      arc(pos.x, pos.y, radio*1.3, radio*1.3, 0, PI, CHORD);
    }
  }
  
  // ############################  ############################
  // ################### METODOS MOVIMIENTO ###################
  // ############################  ############################
  
  void addForce(PVector f) {
    PVector dif = f.copy();
    //dif.div(mass);
    acc.add(dif);
  }
  
  void applyFriction(float c) {
    PVector fric = vel.copy();
    fric.normalize();
    fric.mult(-c);
    addForce(fric);
  }
  
  void seek(float x, float y) {
    PVector target = new PVector(x, y);
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxSteeringForce);
    if (debugAgent){
      stroke(#000000);
      strokeWeight(3);
      fill(#FC00E4);
      circle(x, y, 7);
    }
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
  
  void followLine(float x, float y) {
    PVector target = new PVector(x, y);
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    float dist = pos.dist(target);
    if (dist <= arrivalRadius) {
      vel.limit(max(0, map(dist, 0, arrivalRadius, 0, maxSpeed)));
    }
    if (debugAgent){
      stroke(#000000);
      strokeWeight(3);
      fill(#FC00E4);
      circle(x, y, 7);
    }
    steering.limit(followSpeed);
    addForce(steering);
  }
  
  void follow(float x, float y) {
    PVector target = new PVector(x, y);
    PVector desired = PVector.sub(target, pos);
    PVector steering = PVector.sub(desired, vel);
    float dist = pos.dist(target);
    if (dist <= arrivalRadius) {
      vel.limit(max(0, map(dist, 0, arrivalRadius, 0, maxSpeed*3)));
    }
    if (debugAgent){
      stroke(#000000);
      strokeWeight(3);
      fill(#FC00E4);
      circle(x, y, 7);
    }
    addForce(steering);
  }
  
  void wander() {
    PVector future = vel.copy();
    future.setMag(wanderLookAhead);
    future.add(pos);

    PVector target = vel.copy();
    target.setMag(wanderRadius);
    target.rotate(map(noise(wanderNoiseT), 0, 1, -PI -HALF_PI, PI + HALF_PI));
    wanderNoiseT += wanderNoiseTInc;
    target.add(future);
    
    seek(target.x, target.y);
  }
  
  void flocking(ArrayList<Agent> agents){
    PVector align = new PVector(0, 0);
    PVector separate = new PVector(0, 0);
    PVector cohere = new PVector(0, 0);
    
    int nA = 0;
    int nS = 0;
    int nC = 0;
    
    for (Agent a : agents) {
      if (this != a && pos.dist(a.pos) < alignmentRadio) {
        align.add(a.vel);
        nA++;
      }
      
      if (this != a && pos.dist(a.pos) < separationRadio) {
        PVector dif = PVector.sub(pos, a.pos);
        dif.normalize();
        dif.div(pos.dist(a.pos));
        separate.add(dif);
        nS++;
      }
      
      if (this != a && pos.dist(a.pos) < cohesionRadio) {
        cohere.add(a.pos);
        nC++;
      }
    }
    
    if (nA > 0) {
      align.div(nA);
      align.setMag(alignmentRatio);
      align.limit(maxSteeringForce);
      addForce(align);
    }
    
    if (nS > 0) {
      separate.div(nS);
      separate.setMag(separationRatio);
      separate.limit(maxSteeringForce);
      addForce(separate);
    }
    
    if (nC > 0) {
      cohere.div(nC);
      PVector dif = PVector.sub(cohere, pos);
      dif.setMag(cohesionRatio);
      dif.limit(maxSteeringForce);
      addForce(dif);
    }
  }
  
  void separate(ArrayList<Agent> agents) {
    PVector result = new PVector(0, 0);
    int n = 0;
    for (Agent a : agents) {
      if (this != a && pos.dist(a.pos) < separationRadio) {
        PVector dif = PVector.sub(pos, a.pos);
        dif.normalize();
        dif.div(pos.dist(a.pos));
        result.add(dif);
        n++;
      }
    }
    if (n > 0) {
      result.div(n);
      result.setMag(separationRatio);
      result.limit(maxSteeringForce);
      addForce(result);
    }
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
    PVector dir = vel.copy().normalize(); //Obtener direccion

    if (pos.x < radio || pos.x > width - radio) {
      pos.x = constrain(pos.x, radio, width - radio);
      vel.x *= -damp;
    }
    if (pos.y < radio + 50 || pos.y > height - radio) {
      pos.y = constrain(pos.y, radio + 50, height - radio);
      vel.y *= -damp;
    }
    
    //Escenario
    if (pos.y-radio > height/2-210 && pos.x -radio < 300) { //Hay colision
      //Colision lateral
      pos.x = 300 + radio;
      vel.x *= -damp;
    }
    
    float w1X = 0;               //CoordenadaX del muro 1
    float w1Y = height/2 - 210;  //CoordenadaY del muro 1
    float w1W = width/2;         //Ancho del muro 1
    float w1H = 10;              //Altura del muro 1
    if (pos.x < w1X + w1W && pos.y + radio > w1Y && pos.y - radio < w1Y + w1H) { 
      if (dir.y > 0) { //Colision superior
        pos.y = constrain(pos.y,  0, w1Y-radio-1);
        vel.y *= -damp;
      } else if (dir.y < 0) { //Colision inferior
        pos.y = constrain(pos.y, w1Y+w1H+radio+1, height);
        vel.y *= -damp;
      }
    }
    
    if (pos.x - radio < w1X + w1W && pos.y + radio > w1Y && pos.y - radio < w1Y + w1H) { 
      if (dir.x < 0) { //Colision derecha
        pos.x = constrain(pos.x, w1W+radio+1, width);
        vel.x *= -damp;
      } //No hay colision izquierda
    }
    
    float w2X = width/2 +100;   //CoordenadaX del muro 2
    float w2Y = height/2 -210;  //CoordenadaY del muro 2
    float w2W = width/2 -100;   //Ancho del muro 2
    float w2H = 10;             //Altura del muro 2
    if (pos.x > w2X && pos.y + radio > w2Y && pos.y - radio < w2Y + w2H) { 
      if (dir.y > 0) { //Colision superior
        pos.y = constrain(pos.y, 0, w2Y-radio-1);
        vel.y *= -damp;
      } else if (dir.y < 0) { //Colision inferior
        pos.y = constrain(pos.y, w2Y+w2H+radio+1, height);
        vel.y *= -damp;
      }
    }
    
    if (pos.x + radio > w2X && pos.y + radio > w2Y && pos.y - radio < w2Y + w2H) {
      if (dir.x > 0) { //Colision izquierda
        pos.x = constrain(pos.x, 0, w2X-radio-1);
        vel.x *= -damp;
      }
    }
    
    float w3X = width * 3/4;              //CoordenadaX del muro 3
    float w3Y = height/2 -200;            //CoordenadaY del muro 3
    float w3W = 10;                       //Ancho del muro 3
    float w3H = 253;                      //Altura del muro 3
    if (pos.x + radio > w3X && pos.x - radio < w3X + w3W && pos.y - radio < w3Y + w3H && pos.y + radio > w3Y) { 
      if (dir.x < 0) { //Colision derecha
        pos.x = constrain(pos.x, w3X+w3W+radio+1, width);
        vel.x *= -damp;
      } else if (dir.x > 0) { //Colision izquierda
        pos.x = constrain(pos.x, 0, w3X-radio-1);
        vel.x *= -damp;
      }
    }
    if (pos.x + radio > w3X && pos.x - radio < w3X + w3W && pos.y - radio * 2 < w3Y + w3H && pos.y + radio > w3Y) { 
      if (dir.y < 0) { //Colision inferior
       pos.y = constrain(pos.y, w3Y+w3H+radio*2+1, height);
       vel.y *= -damp;
      }
    }
    
    float w4X = width*3/4;       //CoordenadaX del muro 4
    float w4Y = height/2 +150;   //CoordenadaY del muro 4
    float w4W = 10;              //Ancho del muro 4
    float w4H = height/2 -150;   //Altura del muro 4
    if (pos.x + radio > w4X && pos.x - radio < w4X + w4W && pos.y + radio > w4Y) { 
      if (dir.x < 0) { //Colision derecha
        pos.x = constrain(pos.x, w4X+w4W+radio+1, width);
        vel.x *= -damp;
      } else if (dir.x > 0) { //Colision izquierda
        pos.x = constrain(pos.x, 0, w4X-radio-1);
        vel.x *= -damp;
      }
    }
    if (pos.x + radio > w4X && pos.x - radio < w4X + w4W && pos.y + radio * 2 > w4Y) {
      if (dir.y > 0) { //Colision superior
        pos.y = constrain(pos.y, 0, w4Y+radio*2+1);
        vel.y *= -damp;
      }
    }
  }
  
  color hambreColor() {
    color c = #FFFFFF;
    switch (estadoHambre) {
      case SATISFECHO:
        c = lerpColor(#FF6600, #00FFDF, hambre/50);
        break;
      case HAMBRIENTO:
        c = #FF0000;
        break;
      case COMPRANDO:
        c = #FFC400;
        break;
      case COMIENDO:
        c = #76FF00;
        break;
      case UNAVAILABLE:
        c = #FFFFFF;
        break;
    }
    return c;
  }
  
  color humorColor() {
    color c = #FFFFFF;
    switch (humor) {
      case REFRESHED:
        c = #00B050;
        break;
      case NOTTIRED:
        c = lerpColor(#FF6600, #76FF00, energia/50);
        break;
      case TIRED:
        c = #FF0000;
        break;
      case RESTING:
        c = #00FFEC;
        break;
      case UNAVAILABLE:
        c = #FFFFFF;
        break;
    }
    return c;
  }
}
