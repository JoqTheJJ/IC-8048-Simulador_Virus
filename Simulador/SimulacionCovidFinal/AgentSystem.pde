enum ColorMode {
  INFECTION,
    MASK
}

class AgentSystem {
  ArrayList<Agent> agents;
  IntList randomPos;

  boolean advanceLine;
  int initialWaitingTime = 600;
  int waitingTime = initialWaitingTime;

  //Variables contagio
  float radioDeInfeccion = 40;
  float tasaDeInfeccion = tasaDeTiempo; //Cantidad de minutos por segundo de la simulacion

  int numPersonas;
  int numPersonasInfectadas;
  int numPersonasMascarilla;

  // ############################  ############################
  // ################## METODOS PRINCIPALES ###################
  // ############################  ############################

  AgentSystem() {
    agents = new ArrayList<Agent>();
    randomPos = new IntList();

    numPersonas = 0;
    numPersonasInfectadas = 0;
    numPersonasMascarilla = 0;
  }

  void run() {
    int size = agents.size();

    waitingTime--;
    for (int i = 0; i < size; i++) {
      Agent a1 = agents.get(i);

      int posicionFila = a1.filaPos;
      if (posicionFila > 0) { //Estan haciendo fila

        a1.humor = Humor.UNAVAILABLE;
        a1.estadoHambre = Hambre.UNAVAILABLE;
        a1.hambre = 100;
        a1.energia = 100;
        if (posicionFila < fila.numPosiciones) { //Pos cualquira
          PVector coordenadaFila = fila.posiciones[posicionFila - 1];
          a1.estado = State.STILL;
          a1.followLine(coordenadaFila.x, coordenadaFila.y);
        } else if (posicionFila == fila.numPosiciones) { //Pos max
          PVector coordenadaFila = fila.posiciones[posicionFila - 1];
          a1.estado = State.STILL;
          a1.follow(coordenadaFila.x, coordenadaFila.y);
          a1.follow(coordenadaFila.x, coordenadaFila.y);
        } else { //Entrada concierto
          a1.follow(fila.max.x, fila.max.y);
        }

        if (waitingTime <= 0 && advanceLine) {
          a1.filaPos -= 1;
          if (a1.filaPos == 0) {
            a1.follow(fila.posiciones[0].x - 2, fila.posiciones[0].y);
            a1.estado = State.CONCERT;
            a1.humor = Humor.NOTTIRED;
            a1.estadoHambre = Hambre.SATISFECHO;
            a1.hambre = random(40, 100);
            a1.energia = random(80, 120);
          }
        }
        // *********************************************** //
      } else { //Estan en la simulacion
        a1.wander();
        a1.separate(agents);

        if (a1.pos.y > scene.w1Y) { //Is in concert area
          a1.estado = State.CONCERT;
        } else { //Is in resting area
          a1.estado = State.WANDER;
        }

        if (a1.estado == State.CONCERT) {
          float friction = map(a1.pos.x, scene.concertX, scene.w3X, 0.01, 0);
          a1.applyFriction(friction);
        }

        if (a1.humor == Humor.NOTTIRED && a1.pos.y < scene.w1Y - 25) {
          a1.humor = Humor.RESTING;
        }

        if (a1.humor == Humor.TIRED) {
          a1.seek(scene.w1W + 50, scene.w1Y - 20);
          if (a1.pos.y < scene.w1Y - 25) {
            a1.humor = Humor.RESTING;
          }
        } else if (a1.humor == Humor.REFRESHED) {
          a1.seek(scene.w1W + 50, scene.w1Y + 40);
          if (a1.pos.y > scene.w1Y + 20) {
            a1.humor = Humor.NOTTIRED;
          }
        }

        if (a1.estadoHambre == Hambre.COMPRANDO) {
          Tienda tienda = tiendas.get(a1.numTienda);
          a1.follow(tienda.centerX, tienda.centerY);
          if(dist(tienda.centerX, tienda.centerY, a1.pos.x, a1.pos.y) < 50){
            a1.follow(a1.pos.x, a1.pos.y-100);
            a1.follow(a1.pos.x, a1.pos.y-100);
          }
        } else if (a1.estadoHambre == Hambre.HAMBRIENTO) {
          a1.seek(scene.w1W + 50, scene.w1Y - 20);
          if (a1.humor == Humor.RESTING) {
            if (a1.pos.x < scene.w1W + 50) {
              if (a1.pos.x > 150) {
                a1.follow(a1.pos.x - 70, 65);
              } else {
                a1.follow(150, 55);
              }
            } else {
              if (a1.pos.x < width - 150) {
                a1.follow(a1.pos.x + 70, 65);
              } else {
                a1.follow(width - 150, 55);
              }
            }
          }
        }
      }
      a1.run();
      advanceLine = false;

      //Infeccion
      if (frameCount % 60 == 0) { //Infeccion 1 vez por segundo
        advanceLine = true;

        for (int j = i+1; j < size; j++) {
          Agent a2 = agents.get(j);
          boolean infeccion = false;

          Agent infectado = a1;
          Agent sano = a1;
          if (a1.infectado() && !a2.infectado()) {
            infectado = a1;
            sano = a2;
            infeccion = true;
          } else if (a2.infectado() && !a1.infectado()) {
            infectado = a2;
            sano = a1;
            infeccion = true;
          }

          if (infeccion) {
            float distancia = PVector.sub(a1.pos, a2.pos).mag();
            if (distancia < radioDeInfeccion && distancia > -radioDeInfeccion) {
              contagio(infectado, sano, distancia);
              if (sano.infectado()) {
                numPersonasInfectadas += 1;
              }
            }
          }
        }
      }
    }
  }

  void display() {
    for (Agent a : agents) {
      a.display();
    }
  }

  void addAgent(float x, float y, boolean infectado, float eficienciaMascarilla) {
    agents.add(new Agent(x, y, infectado, eficienciaMascarilla, State.CONCERT));
  }

  void reset() {
    agents.clear();
    numPersonas = 0;
    numPersonasInfectadas = 0;
    numPersonasMascarilla = 0;
  }

  void alterColorMode() {
    if (colorMode == ColorMode.INFECTION) {
      colorMode = ColorMode.MASK;
    } else if (colorMode == ColorMode.MASK) {
      colorMode = ColorMode.INFECTION;
    }
  }

  // ############################  ############################
  // #################### METODOS CONTAGIO ####################
  // ############################  ############################

  float ajusteDistancia(float distancia) {
    return max(1 / pow(distancia, 2), 0.1);
  }

  float calcularConcentracionQuanta(float tasaExhalacion) {
    float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
    float quantaEquilibradaPorHora = tasaExhalacion / tasaEliminacionPorHora;

    //Por segundo * tasaDeInfeccion
    // tasaDeInfeccion controla la velocidad de la simulacion
    // tasaDeInfeccion (Tiempo(m) / s)
    return quantaEquilibradaPorHora * tasaDeInfeccion / 3600;
  }

  void contagio(Agent contagiado, Agent sano, float distancia) {
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

  void simulacion(int sanos, int contagiados) {
    reset();
    float x = fila.max.x - 25;
    float y = fila.max.y + 13;

    numPersonas = sanos + contagiados;
    numPersonasInfectadas = contagiados;
    
    randomPos.clear();
    randomPos.append(IntList.fromRange(1, numPersonas + 1));
    randomPos.shuffle();

    int posFila = 1;

    int sanosMascarilla = (int)((numPersonas - numPersonasInfectadas)*porcentajeMascarilla);
    int contagiadosMascarilla = (int)((numPersonasInfectadas)*porcentajeMascarilla);

    numPersonasMascarilla = sanosMascarilla + contagiadosMascarilla;

    for (int i = 0; i < numPersonas - numPersonasInfectadas; i++) {
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;


      if (sanosMascarilla > 0) {
        sanosMascarilla--;
        agents.add(new Agent(x, y, false, eficienciaMascarilla, estado, randomPos.get(posFila - 1)));
      } else {
        agents.add(new Agent(x, y, false, 0, estado, randomPos.get(posFila - 1)));
      }
      posFila++;
    }

    for (int i = 0; i < numPersonasInfectadas; i++) {
      State estado = State.STILL;
      if (posFila > fila.numPosiciones)
        estado = State.UNAVAILABLE;

      if (contagiadosMascarilla > 0) {
        contagiadosMascarilla--;
        agents.add(new Agent(x, y, true, eficienciaMascarilla, estado, randomPos.get(posFila - 1)));
      } else {
        agents.add(new Agent(x, y, true, 0, estado, randomPos.get(posFila - 1)));
      }
      posFila++;
    }
    //Reset time
    resetTime();
  }
}
