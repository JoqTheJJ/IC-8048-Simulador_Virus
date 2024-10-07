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
    
    tasaDeVentilacion = 3;
    radioDeInfeccion = 30;
    
    
  }
  
  void run(){
    
    int size = agents.size();
    
    for (int i = 0; i < size; i++) {
      Agent a1 = agents.get(i);
      a1.run();
      
      if(frameCount % 60 == 0){ //Infeccion 1 vez por segundo
      
      for (int j = i+1; j < size; j++) {
        Agent a2 = agents.get(j);
        boolean infeccion = false;
        
        
        Agent infectado = a1;
        Agent sano = a1;
        if (a1.infectado() && !a2.infectado()){
          infectado = a1;
          sano = a2;
          infeccion = true;
        } else if (a2.infectado() && !a1.infectado()) {
          infectado = a2;
          sano = a1;
          infeccion = true;
        }
        
        if(infeccion){
          float distancia = PVector.sub(a1.pos,a2.pos).mag();
          
          if (distancia < radioDeInfeccion && distancia > -radioDeInfeccion){
            contagio(infectado, sano, distancia);
          }
        }
        
      }
      }
    }
  }
  
  void display(){
    for (Agent a : agents){
      a.display();
    }
  }
  
  void addAgent(float x, float y, boolean infectado){
    agents.add(new Agent(x, y, infectado, 0.3, State.CONCERT));
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
  
  void contagio(Agent contagiado, Agent sano, float distancia){
    float tasaExhalacion = contagiado.calcularTasaExhalacion();
    float tasaInhalacion = sano.calcularTasaInhalacion();
    
    float concentracionQuanta = calcularConcentracionQuanta(tasaExhalacion);
    
    float ajusteDistancia = ajusteDistancia(distancia);
    
    float quantaInhalada = concentracionQuanta * tasaInhalacion * ajusteDistancia;
    
    sano.contagiar(quantaInhalada);
  }
}
