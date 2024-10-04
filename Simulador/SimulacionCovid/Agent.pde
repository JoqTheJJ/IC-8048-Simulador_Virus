enum State {
  CONCERT,    //Shouting and being in the concert
  WANDER,     //Walking around slowly and aimlessly
  STILL,      //Still or sitting without motion
  UNAVAILABLE //Bathroom state where no activity is shown
}

ArrayList<Integer> colors;

void addColors(){
  colors = new ArrayList<>();
  colors.add(color(222, 38, 38));  //Rojo
  colors.add(color(232, 83, 37));  //Naranja oscuro
  colors.add(color(240, 159, 44)); //Naranja claro
  colors.add(color(247, 230, 51)); //Amarillo
  colors.add(color(168, 208, 57)); //Verde muy calro
  colors.add(color(103, 186, 61)); //Verde claro
  colors.add(color(10, 154, 67));  //Verde
}


class Agent{
  
  // Variables Movimiento
  PVector pos;
  PVector vel;
  PVector acc;
  float maxSpeed;
  float radio;
  
  float damp;
  //float mass;
  
  
  
  
  // Variables
  State estado;
  
  
  // Variables Contagio
  float eficienciaMascarilla;
  
  float quanta;       // Que tan enfermo esta
  float quantaMaxima; // Limite para que se enferme
  
  
  
  
  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################
  
  Agent(float x, float y, boolean infectado, float eficienciaMascarilla, State estado){
    pos = new PVector(x, y);
    vel = PVector.random2D().setMag(5);
    acc = new PVector(0, 0);
    
    radio = 10;
    damp = 1;
    
    maxSpeed = 20;
    vel.limit(maxSpeed);
    
    this.eficienciaMascarilla = eficienciaMascarilla;
    
    this.estado = estado;
    
    quantaMaxima = 3;
    if(infectado){
      quanta = quantaMaxima;
    } else {
      quanta = random(0,3);
    }
  }
  
  void run(){
    pos.add(vel);
    vel.add(acc);
    
    borders();
    
    strokeWeight(3);
    stroke(#000000);
    int c = int(map(quanta, 0, 3, 0, 6));
    fill(colors.get(c));
    circle(pos.x, pos.y, radio);
  }
  
  void display(){
    strokeWeight(3);
    stroke(#000000);
    int c = int(map(quanta, 0, 3, 0, 7));
    fill(colors.get(c));
    circle(pos.x, pos.y, radio);
  }
  
  
  
  
  
  
  
  
  void borders() {
    if (pos.x < radio/2 || pos.x > width - radio/2) {
      pos.x = constrain(pos.x, radio/2, width - radio/2);
      vel.x *= -damp;
    }
    if (pos.y < radio/2 || pos.y > height - radio/2) {
      pos.y = constrain(pos.y, radio/2, height - radio/2);
      vel.y *= -damp;
    }
    
    if (pos.y+radio/2 > height/2-210 && pos.x -radio/2 < 300){ //Colision escenario lateral
    
      if (pos.x > 300){
        pos.x = 300 + radio/2;
        vel.x *= -damp;
      }
      
      if(pos.y < height/2-210){
        pos.y = height/2-210 - radio/2;
        vel.y *= -damp;
      }
    }
      
      
      
      
      

    float w1x = 0;
    float w1y = height/2 -210;
    float w1height = 10;
    float w1width = width/2;
    
    if (pos.x + radio > w1x && pos.x - radio < w1x + w1width &&
      pos.y + radio > w1y && pos.y - radio < w1y + w1width) {
    
        
    // Verificar la dirección del movimiento
    if (pos.x < w1x) { // Colisión por la izquierda
      pos.x = w1x - radio; // Ajustar la posición
      vel.x *= -damp; // Invertir la velocidad en x
    } else if (pos.x > w1x + w1width) { // Colisión por la derecha
      pos.x = w1x + w1width + radio; // Ajustar la posición
      vel.x *= -damp; // Invertir la velocidad en x
    }

    if (pos.y < w1y) { // Colisión por arriba
      pos.y = w1y - radio; // Ajustar la posición
      vel.y *= -damp; // Invertir la velocidad en y
    } else if (pos.y > w1y + w1height) { // Colisión por abajo
      pos.y = w1y + w1height + radio; // Ajustar la posición
      vel.y *= -damp; // Invertir la velocidad en y
    }
  }


  }
  
  
  
  
  
  // ############################  ############################
  // ################### METODOS MOVIMIENTO ###################
  // ############################  ############################
  
  
  
  
  
  
  // ############################  ############################
  // #################### METODOS CONTAGIO ####################
  // ############################  ############################
  
  float calcularTasaExhalacion(){
    float tasaExhalacion;
    switch (estado){
      case CONCERT:
      //Realizar ejercicio moderado
        tasaExhalacion = 170;
        
      case WANDER:
      //Caminar lentamente + alteracion
        tasaExhalacion = 11.4;
        
      case STILL:
      //Estar parado
        tasaExhalacion = 2.3;
        
      case UNAVAILABLE:
      //Ausencia de presencia
        tasaExhalacion = 0;
        
      default:
        println("Estado del agente invalido");
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
        
      case WANDER:
      //Caminar lentamente + alteracion
        tasaInhalacion = 0.92;
        
      case STILL:
      //Estar parado
        tasaInhalacion = 0.54;
        
      case UNAVAILABLE:
      //Ausencia de presencia
        tasaInhalacion = 0;
        
      default:
        println("Estado del agente invalido");
        tasaInhalacion = 9999;
    }
    
    return tasaInhalacion * (1 - eficienciaMascarilla);
  }
  
  void contagiar(float quantaInhalada){
    quanta += quantaInhalada;
  }
  
}
