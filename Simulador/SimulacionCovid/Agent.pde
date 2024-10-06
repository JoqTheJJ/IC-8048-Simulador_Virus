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
    
    
    
    
    //Scenario
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
      
      
      
      
      

    float w1X = 0;
    float w1Y = height/2 - 210;
    float w1W = width/2;
    float w1H = 10;
    if (pos.x + radio > w1X && pos.x - radio < w1X + w1W) {
      if (pos.y - radio < w1Y + w1H && pos.y + radio > w1Y) {
        vel.y *= -1; //Vertical
      }
    }
    if (pos.y + radio > w1Y && pos.y - radio < w1Y + w1H) {
      if (pos.x - radio < w1X + w1W && pos.x + radio > w1X) {
        vel.x *= -1; //Horizontal
      }
    }
    
    
    float w2X = width/2 +100;
    float w2Y = height/2 -210;
    float w2W = width/2 -100;
    float w2H = 10;
    if (pos.x + radio > w2X && pos.x - radio < w2X + w2W) {
      if (pos.y - radio < w2Y + w2H && pos.y + radio > w2Y) {
        vel.y *= -1; //Vertical
      }
    }
    if (pos.y + radio > w2Y && pos.y - radio < w2Y + w2H) {
      if (pos.x - radio < w2X + w2W && pos.x + radio > w2X) {
        vel.x *= -1; //Horizontal
      }
    }
    
    float w3X = width*3/4;
    float w3Y = height/2 -210;
    float w3W = 10;
    float w3H = 260;
    if (pos.x + radio > w3X && pos.x - radio < w3X + w3W) {
      if (pos.y - radio < w3Y + w3H && pos.y + radio > w3Y) {
        vel.y *= -1; //Vertical
      }
    }
    if (pos.y + radio > w3Y && pos.y - radio < w3Y + w3H) {
      if (pos.x - radio < w3X + w3W && pos.x + radio > w3X) {
        vel.x *= -1; //Horizontal
      }
    }
    
    float w4X = width*3/4;
    float w4Y = height/2 +150;
    float w4W = 10;
    float w4H = height/2 -150;
    if (pos.x + radio > w4X && pos.x - radio < w4X + w4W) {
      if (pos.y - radio < w4Y + w4H && pos.y + radio > w4Y) {
        vel.y *= -1; //Vertical
      }
    }
    if (pos.y + radio > w4Y && pos.y - radio < w4Y + w4H) {
      if (pos.x - radio < w4X + w4W && pos.x + radio > w4X) {
        vel.x *= -1; //Horizontal
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
