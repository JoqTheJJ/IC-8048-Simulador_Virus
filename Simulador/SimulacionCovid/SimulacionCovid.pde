// Simulacion
boolean pause = false;
AgentSystem sys;
Scene scene;


ArrayList<Float> mascarillas;
ArrayList<Actor> actores;

void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.0); //Sin mascarilla
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
  addColors();
  addMascarillas();
  
  sys = new AgentSystem();
  scene = new Scene();
  
  actores = new ArrayList<Actor>();
  actores.add(new Actor( //Cantante
    scene.concertW/2 +30,
    (scene.concertY+scene.concertH)/2,
    #FFFFFF,
    Rol.CANTANTE)
    );
    /*
  actores.add(new Actor( //Guitarrista
    scene.concertW/2 +30,
    (scene.concertY+scene.concertH)/2,
    #FFFFFF,
    Rol.GUITARRISTA)
    );*/
}

void draw(){
  background(#CECECE);
  
  
  
  if (!pause){
    sys.run();
    scene.run();
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




void mousePressed(){
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
