// Simulacion
boolean start = true;
boolean finish = false;
boolean finishOg = finish;
boolean pause = false;
AgentSystem sys;
Scene scene;

int startFrame;
int finishFrame;
int startTime;
int elapsedTime;
int tasaDeTiempo = 1; //Minutos de simulacion por segundo real

ArrayList<Float> mascarillas;
ArrayList<Actor> actores;
ColorMode colorMode;


void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.9); //Sin mascarilla
  mascarillas.add(0.3); //Generica
  mascarillas.add(0.6); //Quirurgica
  mascarillas.add(0.9); //N95
}


//#83FF99
//
// Cambiar color fondo
//
// < --------------------------------- >
// < --------------------------------- >
// < --------------------------------- >
// < --------------------------------- >
//

void setup() {
  //size(800, 800);
  fullScreen();
  addColorsInfection();
  addColorsMask();
  addMascarillas();
  
  startFrame = 0;
  finishFrame = 0;
  startTime = 0;
  elapsedTime = 0;
  
  colorMode = ColorMode.INFECTION;
  
  sys = new AgentSystem();
  scene = new Scene();
  
  actores = new ArrayList<Actor>();
  
  actores.add(new Actor( //Pianista
    scene.concertW/2 +10,
    (2*scene.concertY+scene.concertH)/2 -140  -30,
    #03FF11,
    Rol.TECLADISTA)
    );
  actores.add(new Actor( //Guitarrista
    scene.concertW/2 +20,
    (2*scene.concertY+scene.concertH)/2-30 -70,
    #FE00FF,
    Rol.GUITARRISTA)
    );
  actores.add(new Actor( //Cantante
    scene.concertW/2 +30,
    (2*scene.concertY+scene.concertH)/2 -30,
    #FFFFFF,
    Rol.CANTANTE)
    );
  actores.add(new Actor( //Cantante 2
    scene.concertW/2 +20,
    (2*scene.concertY+scene.concertH)/2 +70  -30,
    #6203FF,
    Rol.SECUNDARIO)
    );
  actores.add(new Actor( //Baterista
    scene.concertW/2 +10,
    (2*scene.concertY+scene.concertH)/2 +140  -30,
    #00FFFD,
    Rol.BATERISTA)
    );
}

void draw(){
  background(#CECECE);
  
  if(start){
    menuPrincipal();
  } else {
    if (finish) {
      if (sys.numPersonas > 1 && sys.numPersonas == sys.numPersonasInfectadas){
        pause = true;
        finish = false;
      }
    }
  
    if (!pause){
      finishFrame += 1;
      
      sys.run();
      scene.display();
      for (Actor a: actores){
        a.run();
      }
      
    } else {

      sys.display();
      scene.display();
      for (Actor a: actores){
        a.display();
      }
    }
    
    
    
    estadisticas();
    
    
    if (mousePressed && mouseButton == LEFT) {
      int mascarillaIndex = int(random(4));
      float eficienciaMascarilla = mascarillas.get(mascarillaIndex);
      sys.addAgent(mouseX, mouseY, false, eficienciaMascarilla);
      if(eficienciaMascarilla > 0){
        sys.numPersonasMascarilla += 1;
      }
      sys.numPersonas += 1;
    }
    
    if (mousePressed && mouseButton == RIGHT) {
      int mascarillaIndex = int(random(4));
      float eficienciaMascarilla = mascarillas.get(mascarillaIndex);
      sys.addAgent(mouseX, mouseY, true, eficienciaMascarilla);
      if(eficienciaMascarilla > 0){
        sys.numPersonasMascarilla += 1;
      }
      sys.numPersonas += 1;
      sys.numPersonasInfectadas += 1;
    }
  }
}




void mousePressed(){
  
  if(start){
    start = false;
    resetTime();
  }
  
  /*
  if(mouseButton == RIGHT){
    int mascarillaIndex = int(random(4));
    float eficienciaMascarilla = mascarillas.get(mascarillaIndex);
    sys.addAgent(mouseX, mouseY, true, eficienciaMascarilla);
    if(eficienciaMascarilla > 0){
      sys.numPersonasMascarilla += 1;
    }
    sys.numPersonas += 1;
    sys.numPersonasInfectadas += 1;
  }*/
}



void keyPressed() {

  if (key == ' ') {
    pause = !pause;
  }
  
  if (key == 'e') {
    println();
  }
  
  if (key == 'r' || key == 'R') {
    resetTime();
    
    sys.reset();
    sys.numPersonas = 0;
    sys.numPersonasInfectadas = 0;
    sys.numPersonasMascarilla = 0;
  }
  
  if (key == 'm' || key == 'M'){
    sys.alterColorMode();
  }
  
  if (key == 's' || key == 'S'){
    sys.simulacion1();
  }
}

void resetTime(){
  if(finishOg){
    finish = true;
  }
  startFrame = frameCount;
  finishFrame = startFrame;
  startTime = millis();
}




void estadisticas(){
  elapsedTime = millis() - startTime;
  int realSeconds = (elapsedTime / 1000) % 60;
  int realMinutes = (elapsedTime / 60000) % 60;
  int realHours   = (elapsedTime / 3600000);
  
  int elapsedFrames = finishFrame - startFrame;
  int elapsedTimeFrames = elapsedFrames * 1000 / 60; //frames to ms
  int seconds = (elapsedTimeFrames / 1000) % 60;
  int minutes = (elapsedTimeFrames / 60000) % 60;
  
  //Simulation time tasaDeTiempo
  int ss = (elapsedTimeFrames * tasaDeTiempo * 6 / 100) % 60;
  int sm = (elapsedTimeFrames * tasaDeTiempo / 1000) % 60;
  int sh = (elapsedTimeFrames * tasaDeTiempo / 60000) % 24;
  int sd = (elapsedTimeFrames * tasaDeTiempo / 1440000);
  
  //Timer
  String realTime = String.format("%02d:%02d:%02d", realHours, realMinutes, realSeconds);;
  String time = String.format("%02d:%02d", minutes, seconds);
  String simulationTime = String.format("%02d:%02d:%02d", sh, sm, ss);
  
  textSize(20);
  fill(#FFFFFF);
  
  text("Tiempo real: "+realTime, 15, height -170);
  text("Tiempo: "+time, 15, height -150);
  text("Simulacion: "+sd+":"+simulationTime, 15, height -130);
  
  
  text("Personas Totales: "+sys.numPersonas, 15, height -100);
  text("Personas Totales: "+sys.numPersonas, 15, height -100);
  
  text("Infectados: "+sys.numPersonasInfectadas, 15, height -80);
  text("Sanos: "+(sys.numPersonas-sys.numPersonasInfectadas), 15, height -60);
  
  text("Personas con mascarilla: "+sys.numPersonasMascarilla, 15, height -40);
  text("Personas sin mascarilla: "+(sys.numPersonas-sys.numPersonasMascarilla), 15, height -20);
}

void menuPrincipal(){
  
}
