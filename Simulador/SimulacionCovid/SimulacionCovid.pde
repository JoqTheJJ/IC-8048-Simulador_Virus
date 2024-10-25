import controlP5.*;


// Simulacion
boolean start = true;
boolean finish = false;
boolean finishOg = finish;
boolean pause = false;
boolean debug = true;



//Control P5
ControlP5 cp5;
float scrollValue = 0;

Slider sEficiencia;


AgentSystem sys;
ArrayList<Repeledor> repeledores;
Scene scene;

int startFrame;
int finishFrame;
int startTime;
int elapsedTime;
float tasaDeTiempo = 60; //Segundos de simulacion por segundo real

ArrayList<Float> mascarillas;
ArrayList<Actor> actores;
ColorMode colorMode;


void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.0); //Sin mascarilla
  mascarillas.add(0.3); //Generica
  mascarillas.add(0.6); //Quirurgica
  mascarillas.add(0.9); //N95
}

float eficienciaMascarilla;
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
  
  cp5 = new ControlP5(this);
  
  PFont font = createFont("Arial", 1);
  
  sEficiencia = cp5.addSlider("setEficienciaMascarilla")
    .setPosition(width/2 - 250, height/2 +150)
    .setSize(200, 50)
    .setRange(0, 0.99)
    .setValue(eficienciaMascarilla)
    .setCaptionLabel("")
    .setFont(font);

                  
                  
                  
                  
  
  addColorsInfection();
  addColorsMask();
  //addMascarillas();
  
  
  startFrame = 0;
  finishFrame = 0;
  startTime = 0;
  elapsedTime = 0;
  
  colorMode = ColorMode.INFECTION;
  
  sys = new AgentSystem();
  scene = new Scene();
  
  repeledores = new ArrayList<Repeledor>();
  repeledores.add(new Repeledor(width/2+50, height/2+50, 200, 300, 1, new PVector(0, -1), sys));
  
  repeledores.add(new Repeledor(0, scene.w1Y-50, scene.w1W-20, 50,
  0.13, new PVector(0, -1), sys));
  repeledores.add(new Repeledor(scene.w2X+20, scene.w2Y-50, width, 50,
  0.13, new PVector(0, -1), sys));
  
  repeledores.add(new Repeledor(0, scene.w1Y +scene.w1H, scene.w1W-20, 50,
  0.13, new PVector(0, 1), sys));
  repeledores.add(new Repeledor(scene.w2X+20, scene.w2Y +scene.w2H, width, 50,
  0.13, new PVector(0, 1), sys));
  
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
  
  if(start){ //Menu Inicial
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

      for (Repeledor r: repeledores){
        r.update();
        if (debug)
          r.display();
      }
      
      
      sys.run();
      scene.update();
      scene.display();
      
      
      for (Actor a: actores){
        a.run();
      }
      
      
      
      
    } else { //PAUSA
      
      for (Repeledor r: repeledores){
        if (debug)
          r.display();
      }


      sys.display();
      scene.display();
      
      
      for (Actor a: actores){
        a.display();
      }
    }
    
    
    
    estadisticas();
    
    
    if (mousePressed && mouseButton == LEFT) {
      sys.addAgent(mouseX, mouseY, false, eficienciaMascarilla);
      if(eficienciaMascarilla > 0){
        sys.numPersonasMascarilla += 1;
      }
      sys.numPersonas += 1;
    }
    
    if (mousePressed && mouseButton == RIGHT) {
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
  
  
  /*
  if(mouseButton == RIGHT){
    sys.addAgent(mouseX, mouseY, true, eficienciaMascarilla);
    if(eficienciaMascarilla > 0){
      sys.numPersonasMascarilla += 1;
    }
    sys.numPersonas += 1;
    sys.numPersonasInfectadas += 1;
  }*/
}



void keyPressed() {
  
  if (start && key == '\n') {
    cerrarMenuPrincipal();
  }

  if (key == ' ') {
    pause = !pause;
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
  int realSeconds = elapsedTime / 1000;
  int realMinutes = realSeconds / 60;
  int realHours   = realMinutes / 60;
  
  int elapsedFrames = finishFrame - startFrame;
  int elapsedTimeFrames = elapsedFrames / 60; //frames to ms
  int seconds = elapsedTimeFrames;
  int minutes = seconds / 60;
  
  //Simulation time tasaDeTiempo
  elapsedTimeFrames = elapsedFrames *1000 /60;
  int ss = (int)(elapsedTimeFrames * tasaDeTiempo /1000);
  int sm = (int)(ss /60);
  int sh = (int)(sm / 60);
  int sd = (int)(sh / 24);
  
  //Timer
  String realTime = String.format("%02d:%02d:%02d", realHours, realMinutes %60, realSeconds %60);;
  String time = String.format("%02d:%02d", minutes, seconds %60);
  String simulationTime = String.format("%02d:%02d:%02d", sh %24, sm %60, ss %60);
  
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

void setEficienciaMascarilla(float value){
  eficienciaMascarilla = value;
}

void menuPrincipal(){
  
  PVector pos = new PVector(width/2 - 150, height/2);
  float radio = 100;
  PFont menuFont = createFont("8bitOperatorPlus8-Regular.ttf", 50);
  textFont(menuFont);
  fill(#000000);
  
  
  text("PRESIONA ENTER PARA INICIAR", width/2 - 350, pos.y + 450);
  
  
  
  
  
  text((int)(eficienciaMascarilla*100) + "%", pos.x - 50, pos.y + 250);
  
  strokeWeight(20);
  stroke(#000000);
  
  fill(colorsInfection.get(0));
  circle(pos.x, pos.y, radio*2);
  
  fill(#000000);
  rect(pos.x-30, pos.y-40, 10, 14); //Ojos
  rect(pos.x+30, pos.y-40, 10, 14); //Ojos
  
  int m = int(map(eficienciaMascarilla, 0, 1, 0, 4));
    
  if(m > 0){
    fill(colorsMask.get(m-1));
    
    strokeWeight(15);
    line(pos.x-radio, pos.y -5, pos.x+radio, pos.y -5);
    line(pos.x-radio, pos.y +15, pos.x+radio, pos.y +15);
    arc(pos.x, pos.y, radio*1.5, radio*1.5, 0, PI, CHORD);
  }
}

void cerrarMenuPrincipal(){
  
  textFont(createFont("SansSerif", 12));
  
  sEficiencia.hide();
  start = false;
}
