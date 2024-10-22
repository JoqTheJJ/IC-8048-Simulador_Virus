



class AgentSystem{
  
  ArrayList<Agent> agents;
  
  
  
  
  
  //Variables contagio
  float tasaDeVentilacion = 3; // (ACH) Cantidad de cambios de aire por hora
  float radioDeInfeccion = 50;
  float tasaDeInfeccion = tasaDeTiempo; //Cantidad de minutos por segundo de la simulacion
  
  int numPersonas;
  int numPersonasInfectadas;
  int numPersonasMascarilla;
  
  
  
  
  
  
  
  
  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################
  
  AgentSystem(){
    agents = new ArrayList<Agent>();
    
    numPersonas = 0;
    numPersonasInfectadas = 0;
    numPersonasMascarilla = 0;
  }
  
  void run(){
    
    int size = agents.size();
    
    float seekX = scene.concertX + scene.concertW/2;
    float seekY = scene.concertY + scene.concertH/2;
    
    for (int i = 0; i < size; i++) {
      Agent a1 = agents.get(i);
      a1.run();
      a1.wander();
      //a1.seek(mouseX, mouseY);
      //a1.arrive(mouseX, mouseY);
      
      if(scene.concertX < a1.pos.x && a1.pos.x < scene.concertX+ scene.w3X
      && scene.concertY < a1.pos.y && a1.pos.y < height){
        a1.arrive(seekX, seekY);
      }
      
      
      
      
      
      
      //Infeccion
      
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
            
            if(sano.infectado()){
              numPersonasInfectadas += 1;
            }
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
  
  void addAgent(float x, float y, boolean infectado, float eficienciaMascarilla){
    agents.add(new Agent(x, y, infectado, eficienciaMascarilla, State.CONCERT));
  }
  
  void reset(){
    agents.clear();
  }
  
  void alterColorMode(){
    if(colorMode == ColorMode.INFECTION){
      colorMode = ColorMode.MASK;
    } else if (colorMode == ColorMode.MASK) {
      colorMode = ColorMode.INFECTION;
    }
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
    
    //Por segundo * tasaDeInfeccion
    // tasaDeInfeccion controla la velocidad de la simulacion
    // tasaDeInfeccion (Tiempo(m) / s)
    return quantaEquilibradaPorHora * tasaDeInfeccion / 3600; 
  }
  
  void contagio(Agent contagiado, Agent sano, float distancia){
    float tasaExhalacion = contagiado.calcularTasaExhalacion();
    float tasaInhalacion = sano.calcularTasaInhalacion();
    
    float concentracionQuanta = calcularConcentracionQuanta(tasaExhalacion);
    
    float ajusteDistancia = ajusteDistancia(distancia);
    
    float quantaInhalada = concentracionQuanta * tasaInhalacion * ajusteDistancia;
    
    sano.contagiar(quantaInhalada);
  }
  
  void simulacion1(){
    sys.reset();
    
    
    numPersonas = 1000;
    numPersonasInfectadas = 500;
    numPersonasMascarilla = (mascarillas.get(3) > 0) ? numPersonas : 0;
    
    for (int i = 0; i < numPersonas - numPersonasInfectadas; i++){
      float x = random(scene.w3X - scene.concertW -50) + scene.concertW +25;
      float y = random(height - scene.concertY -50) + scene.concertY +25;
      agents.add(new Agent(x, y, false, mascarillas.get(3), State.CONCERT));
    }
    
    for (int i = 0; i < numPersonasInfectadas; i++){
      float x = random(scene.w3X - scene.concertW -50) + scene.concertW +25;
      float y = random(height - scene.concertY -50) + scene.concertY +25;
      agents.add(new Agent(x, y, true, mascarillas.get(3), State.CONCERT));
    }
    
    //Reset time
    resetTime();
  }
}
