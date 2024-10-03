enum State {
  CONCERT,    //Shouting and being in the concert
  WANDER,     //Walking around slowly and aimlessly
  STILL,      //Still or sitting without motion
  UNAVAILABLE //Bathroom state where no activity is shown
}



class Agent{
  
  // Variables Movimiento
  PVector pos;
  PVector vel;
  PVector acc;
  float radius;
  
  
  
  // Variables
  State estado;
  
  
  // Variables Contagio
  float eficienciaMascarilla;
  float quanta;
  
  
  
  
  
  
  
  
  
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
