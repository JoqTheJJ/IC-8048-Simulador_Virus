class AgentSystem{
  
  ArrayList<Agent> agents;
  
  
  
  
  
  //Variables contagio
  float tasaDeVentilacion; // (ACH) Cantidad de cambios de aire por hora
  float radioDeInfeccion;
  
  int numPersonasInfectadas;
  
  
  
  
  
  
  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################
  
  AgentSystem(){
    agents = new ArrayList<Agent>();
    
    tasaDeVentilacion = 3.0;
    radioDeInfeccion = 4.0;
    
    
  }
  
  void run(){
    for (Agent a : agents){
      a.run();
    }
  }
  
  void display(){
    for (Agent a : agents){
      a.display();
    }
  }
  
  void addAgent(float x, float y){
    agents.add(new Agent(x, y, false, 0.3, State.CONCERT));
  }
  
  void reset(){
    agents.clear();
  }
  

  // ############################  ############################
  // ################### METODOS MOVIMIENTO ###################
  // ############################  ############################
  
  
  
  
  
  
  
  // ############################  ############################
  // #################### METODOS CONTAGIO ####################
  // ############################  ############################
  
  float ajusteDistancia(float distancia){
    return max(1 / pow(distancia, 2), 0.1);
  }
  
  float calcularConcentracionQuanta(float tasaExhalacion){
    float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
    float quantaEquilibradaPorHora = tasaExhalacion / tasaEliminacionPorHora;
    
    return quantaEquilibradaPorHora / 60; //Por minuto
  }
  
  void contagio(Agent contagiado, Agent sano){
    float tasaExhalacion = contagiado.calcularTasaExhalacion();
    float tasaInhalacion = sano.calcularTasaInhalacion();
    
    float concentracionQuanta = calcularConcentracionQuanta(tasaExhalacion);
    
    PVector d = PVector.sub(contagiado.pos, sano.pos);
    float distancia = d.mag();
    float ajusteDistancia = ajusteDistancia(distancia);
    
    float quantaInhalada = concentracionQuanta * tasaInhalacion * ajusteDistancia;
    
    sano.contagiar(quantaInhalada);
  }
}
