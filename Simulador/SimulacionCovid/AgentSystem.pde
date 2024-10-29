enum ColorMode {
  INFECTION,
  MASK
}



class AgentSystem{
  
  ArrayList<Agent> agents;
  
  boolean advanceLine;
  
  //Variables contagio
  float radioDeInfeccion = 70;
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
      
      //a1.seek(seekX, seekY);
      //a1.seek(mouseX, mouseY);
      //a1.arrive(mouseX, mouseY);
      
      /*
      if(scene.concertX < a1.pos.x && a1.pos.x < scene.concertX+ scene.w3X
      && scene.concertY < a1.pos.y && a1.pos.y < height){
        a1.arrive(seekX, seekY);
      }*/
      
      
      
      int posicionFila = a1.filaPos;
      if (posicionFila > 0){
        
        if (posicionFila < fila.numPosiciones){
          PVector coordenadaFila = fila.posiciones[posicionFila - 1];
          a1.estado = State.STILL;
          a1.followLine(coordenadaFila.x, coordenadaFila.y);
        } else {
          a1.followLine(fila.max.x, fila.max.y);
        }
        
        if (advanceLine){
          a1.filaPos -= 1;
          if (a1.filaPos == 0){
            a1.followLine(fila.posiciones[0].x - 100, fila.posiciones[0].y);
            a1.estado = State.CONCERT;
          }
        }
        
      } else {
        a1.wander();
      }
      
      a1.run();
      advanceLine = false;
      
      
      //Infeccion
      
      if(frameCount % 60 == 0){ //Infeccion 1 vez por segundo
      
        advanceLine = true;
      
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
    agents.add(new Agent(x, y, infectado, eficienciaMascarilla, State.CONCERT, 0));
  }
  
  void reset(){
    agents.clear();
    numPersonas = 0;
    numPersonasInfectadas = 0;
    numPersonasMascarilla = 0;
  }
  
  void alterColorMode(){
    if(colorMode == ColorMode.INFECTION){
      colorMode = ColorMode.MASK;
    } else if (colorMode == ColorMode.MASK) {
      colorMode = ColorMode.INFECTION;
    }
  }
  
  
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
  

  // ############################  ############################
  // ##################### METODOS SISTEMA ####################
  // ############################  ############################
  
  void advanceLine(){
    advanceLine = true;
  }
  
  void spawn(boolean infectado, int posFila){
    float x = fila.max.x;
    float y = fila.max.y;
    
    State estado = State.STILL;
    if (posFila > fila.numPosiciones)
      estado = State.UNAVAILABLE;
    
    agents.add(new Agent(x, y, false, eficienciaMascarilla, estado, posFila));
  }
  
  void simulacion1(int sanos, int contagiados){
    sys.reset();
    
    
    numPersonas = sanos + contagiados;
    numPersonasInfectadas = contagiados;
    
    int posFila = 1;

    int sanosMascarilla = (int)((numPersonas - numPersonasInfectadas)*porcentajeMascarilla);
    int contagiadosMascarilla = (int)((numPersonasInfectadas)*porcentajeMascarilla);
    
    numPersonasMascarilla = sanosMascarilla + contagiadosMascarilla;
    
    for (int i = 0; i < numPersonas - numPersonasInfectadas; i++){
      float x = fila.max.x;
      float y = fila.max.y;
      
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;
      
      
      if (sanosMascarilla > 0){
        sanosMascarilla--;
        agents.add(new Agent(x, y, false, eficienciaMascarilla, estado, posFila));
      } else {
        agents.add(new Agent(x, y, false, 0, estado, posFila));
      }
      posFila++;
    }
    
    for (int i = 0; i < numPersonasInfectadas; i++){
      float x = fila.max.x;
      float y = fila.max.y;
      
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;
      
      if (contagiadosMascarilla > 0){
        contagiadosMascarilla--;
        agents.add(new Agent(x, y, true, eficienciaMascarilla, estado, posFila));
      } else {
        agents.add(new Agent(x, y, true, 0, estado, posFila));
      }
      posFila++;
    }
    
    //Reset time
    resetTime();
  }
  
  
  
  
  void simulacion(int sanos, int contagiados){
    sys.reset();
    
    
    numPersonas = sanos + contagiados;
    numPersonasInfectadas = contagiados;
    
    int posFila = 1;

    int sanosMascarilla = (int)((numPersonas - numPersonasInfectadas)*porcentajeMascarilla);
    int contagiadosMascarilla = (int)((numPersonasInfectadas)*porcentajeMascarilla);
    
    numPersonasMascarilla = sanosMascarilla + contagiadosMascarilla;
    
    for (int i = 0; i < numPersonas - numPersonasInfectadas; i++){
      float x = fila.max.x;
      float y = fila.max.y;
      
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;
      
      
      if (sanosMascarilla > 0){
        sanosMascarilla--;
        agents.add(new Agent(x, y, false, eficienciaMascarilla, estado, posFila));
      } else {
        agents.add(new Agent(x, y, false, 0, estado, posFila));
      }
      posFila++;
    }
    
    for (int i = 0; i < numPersonasInfectadas; i++){
      float x = fila.max.x;
      float y = fila.max.y;
      
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;
      
      if (contagiadosMascarilla > 0){
        contagiadosMascarilla--;
        agents.add(new Agent(x, y, true, eficienciaMascarilla, estado, posFila));
      } else {
        agents.add(new Agent(x, y, true, 0, estado, posFila));
      }
      posFila++;
    }
    
    //Reset time
    resetTime();
  }
  
  
  
  
  
}
