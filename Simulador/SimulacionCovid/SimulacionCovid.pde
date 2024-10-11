// Simulacion
boolean start = true;
boolean pause = false;
AgentSystem sys;
Scene scene;


ArrayList<Float> mascarillas;
ArrayList<Actor> actores;
ColorMode colorMode;

/*
void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.0); //Sin mascarilla
  mascarillas.add(0.3); //Generica
  mascarillas.add(0.6); //Quirurgica
  mascarillas.add(0.9); //N95
}*/
void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.9); //Sin mascarilla
  mascarillas.add(0.9); //Generica
  mascarillas.add(0.9); //Quirurgica
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
  actores.add(new Actor( //Baterista
    scene.concertW/2 +10,
    (2*scene.concertY+scene.concertH)/2 +140  -30,
    #00FFFD,
    Rol.BATERISTA)
    );
    /*
  actores.add(new Actor( //Bateria
    scene.concertW/2 +20,
    (2*scene.concertY+scene.concertH)/2-30 -70,
    #0BB7B5,
    Rol.GUITARRISTA)
    );*/
}

void draw(){
  background(#CECECE);
  
  if(start){
    menuPrincipal();
  } else {
  
    if (!pause){
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
  }
}




void mousePressed(){
  start = false;
  
  if(mouseButton == RIGHT){
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



void keyPressed() {

  if (key == ' ') {
    pause = !pause;
  }
  
  if (key == 'r' || key == 'R') {
    sys.reset();
    sys.numPersonas = 0;
    sys.numPersonasInfectadas = 0;
    sys.numPersonasMascarilla = 0;
  }
  
  if (key == 'm' || key == 'M'){
    sys.alterColorMode();
  }
  
}

void estadisticas(){
  textSize(20);
  fill(#FFFFFF);
  text("Personas Totales: "+sys.numPersonas, 15, height -100);
  
  text("Infectados: "+sys.numPersonasInfectadas, 15, height -80);
  text("Sanos: "+(sys.numPersonas-sys.numPersonasInfectadas), 15, height -60);
  
  text("Personas con mascarilla: "+sys.numPersonasMascarilla, 15, height -40);
  text("Personas sin mascarilla: "+(sys.numPersonas-sys.numPersonasMascarilla), 15, height -20);
}

void menuPrincipal(){
  
}
