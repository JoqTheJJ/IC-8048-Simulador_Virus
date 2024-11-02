import controlP5.*;


// Simulacion
boolean start = true;
boolean finish = false;
boolean finishOg = finish;
boolean pause = false;
boolean debug = false;


float eficienciaMascarilla = 0;
float porcentajeMascarilla = 0;
float tasaDeVentilacion = 1;// (ACH) Cantidad de cambios de aire por hora
int totalSanos = 100;
int totalContagiados = 1;

PImage imagenProhibido;

PImage imagenVentilacion;
float rotacionVentilador = 0;

//Control P5
ControlP5 cp5;
float scrollValue = 0;

Slider sEficiencia;
Slider sVentilacion;
Slider sPersonas;
Slider sContagiados;
Slider sPorcentajeMascarilla;

AgentSystem sys;
ArrayList<Repeledor> repeledores;
ArrayList<FoodAttractor> foodAttractors;
ArrayList<Tienda> tiendas;
Scene scene;

int startFrame;
int finishFrame;
int startTime;
int elapsedTime;
float tasaDeTiempo = 60; //Segundos de simulacion por segundo real

ArrayList<Float> mascarillas;
ArrayList<Actor> actores;
ColorMode colorMode;
Fila fila;




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
  print("\n\n\n\n\n\n\n\n");
  
  imagenVentilacion = loadImage("ventilacion.png");
  imagenProhibido = loadImage("no.png");
  PFont font = createFont("Arial", 1);
  
  sEficiencia = cp5.addSlider("setEficienciaMascarilla")
    .setPosition(width/2 - 450, height/2 +200)
    .setSize(200, 50)
    .setRange(0, 0.99)
    .setValue(eficienciaMascarilla)
    .setCaptionLabel("")
    .setFont(font);
    
  sVentilacion = cp5.addSlider("setTasaDeVentilacion")
    .setPosition(width/2 + 300, height/2 +200)
    .setSize(200, 50)
    .setRange(1, 12)
    .setValue(tasaDeVentilacion)
    .setCaptionLabel("")
    .setFont(font);
    
  sPersonas = cp5.addSlider("setTotalSanos")
    .setPosition(width/2 - 250, height/2 -200)
    .setSize(200, 50)
    .setRange(100, 400)
    .setValue(totalSanos)
    .setCaptionLabel("")
    .setFont(font);

  sContagiados = cp5.addSlider("setTotalContagiados")
    .setPosition(width/2 + 100, height/2 -200)
    .setSize(200, 50)
    .setRange(1, 200)
    .setValue(totalContagiados)
    .setCaptionLabel("")
    .setFont(font);
    
  sPorcentajeMascarilla = cp5.addSlider("setPorcentajeMascarilla")
    .setPosition(width/2 - 75, height/2 +200)
    .setSize(200, 50)
    .setRange(0, 1)
    .setValue(porcentajeMascarilla)
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
  fila = new Fila();
  
  addTiendas();
  addActores();
  addRepeledores();
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
        if (debug){
          r.display();
        }
      }
      for (FoodAttractor a: foodAttractors){
        a.update();
        if (debug){
          a.display();
        }
      }
      
      scene.upperWall();
      for (Tienda t: tiendas){
        t.display();
      }
      
      fila.display();
      sys.run();
      scene.update();
      scene.display();
      
      
      for (Actor a: actores){
        a.run();
      }
      
      
      
      
    } else { //PAUSA
      
      if (debug){
        for (Repeledor r: repeledores){
          r.display();
        }
        for (FoodAttractor a: foodAttractors){
          a.display();
        }
      }
      
      scene.upperWall();
      for (Tienda t: tiendas){
        t.display();
      }
      

      fila.display();
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
    
    scene.colorStats();
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
    start = true;
    
    sEficiencia.show();
    sVentilacion.show();
    sPersonas.show();
    sContagiados.show();
    sPorcentajeMascarilla.show();
    
    resetTime();
    
    sys.reset();
  }
  
  if (key == 'm' || key == 'M'){
    sys.alterColorMode();
  }
  
  if (key == 's' || key == 'S'){
    sys.simulacion(totalSanos, totalContagiados);
  }
}





void resetTime(){
  if(finishOg){
    finish = true;
  }
  startFrame = frameCount;
  finishFrame = startFrame;
  startTime = millis();
  sys.waitingTime = sys.initialWaitingTime;
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
  
  text("Tiempo real: "+realTime, 15, height -200);
  text("Tiempo: "+time, 15, height -180);
  text("Simulacion: "+sd+":"+simulationTime, 15, height -160);
  
  text("Nivel de Ventilación: "+(int)tasaDeVentilacion, 15, height -130);
  
  
  text("Personas Totales: "+sys.numPersonas, 15, height -100);
  text("Personas Totales: "+sys.numPersonas, 15, height -100);
  
  text("Infectados: "+sys.numPersonasInfectadas, 15, height -80);
  text("Sanos: "+(sys.numPersonas-sys.numPersonasInfectadas), 15, height -60);
  
  text("Personas con mascarilla: "+sys.numPersonasMascarilla, 15, height -40);
  text("Personas sin mascarilla: "+(sys.numPersonas-sys.numPersonasMascarilla), 15, height -20);
}
