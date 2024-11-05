/*##################################################################################################
       _______. __  .___  ___.  __    __   __          ___       _______   ______   .______      
      /       ||  | |   \/   | |  |  |  | |  |        /   \     |       \ /  __  \  |   _  \     
     |   (----`|  | |  \  /  | |  |  |  | |  |       /  ^  \    |  .--.  |  |  |  | |  |_)  |    
      \   \    |  | |  |\/|  | |  |  |  | |  |      /  /_\  \   |  |  |  |  |  |  | |      /     
  .----)   |   |  | |  |  |  | |  `--'  | |  `----./  _____  \  |  '--'  |  `--'  | |  |\  \----.
  |_______/    |__| |__|  |__|  \______/  |_______/__/     \__\ |_______/ \______/  | _| `._____|


        ______     ______     __   __     ______   ______     ______     __     ______    
       /\  ___\   /\  __ \   /\ "-.\ \   /\__  _\ /\  __ \   /\  ___\   /\ \   /\  __ \   
       \ \ \____  \ \ \/\ \  \ \ \-.  \  \/_/\ \/ \ \  __ \  \ \ \__ \  \ \ \  \ \ \/\ \  
        \ \_____\  \ \_____\  \ \_\\"\_\    \ \_\  \ \_\ \_\  \ \_____\  \ \_\  \ \_____\ 
         \/_____/   \/_____/   \/_/ \/_/     \/_/   \/_/\/_/   \/_____/   \/_/   \/_____/ 


        CCCCCCCCCCCCC     OOOOOOOOO     VVVVVVVV           VVVVVVVVIIIIIIIIIIDDDDDDDDDDDDD        
     CCC::::::::::::C   OO:::::::::OO   V::::::V           V::::::VI::::::::ID::::::::::::DDD     
   CC:::::::::::::::C OO:::::::::::::OO V::::::V           V::::::VI::::::::ID:::::::::::::::DD   
  C:::::CCCCCCCC::::CO:::::::OOO:::::::OV::::::V           V::::::VII::::::IIDDD:::::DDDDD:::::D  
 C:::::C       CCCCCCO::::::O   O::::::O V:::::V           V:::::V   I::::I    D:::::D    D:::::D 
C:::::C              O:::::O     O:::::O  V:::::V         V:::::V    I::::I    D:::::D     D:::::D
C:::::C              O:::::O     O:::::O   V:::::V       V:::::V     I::::I    D:::::D     D:::::D
C:::::C              O:::::O     O:::::O    V:::::V     V:::::V      I::::I    D:::::D     D:::::D
C:::::C              O:::::O     O:::::O     V:::::V   V:::::V       I::::I    D:::::D     D:::::D
C:::::C              O:::::O     O:::::O      V:::::V V:::::V        I::::I    D:::::D     D:::::D
C:::::C              O:::::O     O:::::O       V:::::V:::::V         I::::I    D:::::D     D:::::D
 C:::::C       CCCCCCO::::::O   O::::::O        V:::::::::V          I::::I    D:::::D    D:::::D 
  C:::::CCCCCCCC::::CO:::::::OOO:::::::O         V:::::::V         II::::::IIDDD:::::DDDDD:::::D  
   CC:::::::::::::::C OO:::::::::::::OO           V:::::V          I::::::::ID:::::::::::::::DD   
     CCC::::::::::::C   OO:::::::::OO              V:::V           I::::::::ID::::::::::::DDD     
        CCCCCCCCCCCCC     OOOOOOOOO                 VVV            IIIIIIIIIIDDDDDDDDDDDDD        

####################################################################################################

 Elaborado por:
  <[  Jocelyn Gómez  ]>
  <[  Alison Solano  ]>
  <[   Tzu Rue Hsu   ]>
  <[   Josué Soto    ]>




 Controles Simulación:
  -Presiona [H] dentro de la simulación para ver los controles

##################################################################################################*/
//Import
import controlP5.*;

//Simulacion
boolean start = true;
boolean ayuda = false;
boolean luces = true;
boolean finish = false;
boolean finishOg = finish;
boolean pause = false;
boolean statShow = false;
boolean click = false;

boolean debug = false;
boolean debugAgent = false;

float tasaDeTiempo = 30; //Segundos de simulacion por segundo real

//Sliders default
float eficienciaMascarilla = 0;
float porcentajeMascarilla = 0;
float tasaDeVentilacion = 1;// (ACH) Cantidad de cambios de aire por hora
int totalSanos = 100;
int totalContagiados = 1;

PImage imagenProhibido;

PImage imagenVentilacion;
float rotacionVentilador = 0;

//Sprites cesped
PImage cesped1;
PImage cesped2;
PImage cesped3;
PImage cesped4;
PImage cesped5;
PImage cesped6;

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

ArrayList<Float> mascarillas;
ArrayList<Actor> actores;
ColorMode colorMode;
Fila fila;

void setup() {
  //size(1920, 1080);
  fullScreen();
  
  cp5 = new ControlP5(this);
  print("\n\n\n\n\n\n\n\n");
  
  imagenVentilacion = loadImage("ventilacion.png");
  imagenProhibido = loadImage("no.png");
  PFont font = createFont("Arial", 1);
  
  cesped1 = loadImage("c1.png");
  cesped2 = loadImage("c2.png");
  cesped3 = loadImage("c3.png");
  cesped4 = loadImage("c4.png");
  cesped5 = loadImage("c5.png");
  cesped6 = loadImage("c6.png");
  
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

void draw() {
  if(start) { //Menu Inicial
    background(#CECECE);
    menuPrincipal();
    
  } else if (ayuda) {
    background(#CECECE);
    menuAyuda();
    
  } else {
    background(#92D050);
    
    if (finish) {
      if (sys.numPersonas > 1 && sys.numPersonas == sys.numPersonasInfectadas){
        pause = true;
        finish = false;
      }
    }
  
    if (!pause) {
      finishFrame += 1;
      for (Repeledor r: repeledores) {
        r.update();
        if (debug){
          r.display();
        }
      }
      for (FoodAttractor a: foodAttractors) {
        a.update();
        if (debug){
          a.display();
        }
      }
      
      scene.preDisplay();
      for (Tienda t: tiendas) {
        t.display();
      }
      
      fila.display();
      sys.run();
      scene.update();
      scene.display();
      
      if(luces) {
        scene.luces();
      }
      
      for (Actor a: actores) {
        a.run();
      }
    } else { // Pausa [||]
      if (debug) {
        for (Repeledor r: repeledores){
          r.display();
        }
        for (FoodAttractor a: foodAttractors){
          a.display();
        }
      }
      
      scene.preDisplay();
      for (Tienda t: tiendas) {
        t.display();
      }
      

      fila.display();
      sys.display();
      scene.display();
      
      if(luces) {
        scene.luces();
      }
      
      
      for (Actor a: actores) {
        a.display();
      }
    }
    
    estadisticas();

    if (click && mousePressed && mouseButton == LEFT) {
      sys.addAgent(mouseX, mouseY, false, eficienciaMascarilla);
      if(eficienciaMascarilla > 0){
        sys.numPersonasMascarilla += 1;
      }
      sys.numPersonas += 1;
    }
    if (click && mousePressed && mouseButton == RIGHT) {
      sys.addAgent(mouseX, mouseY, true, eficienciaMascarilla);
      if(eficienciaMascarilla > 0){
        sys.numPersonasMascarilla += 1;
      }
      sys.numPersonas += 1;
      sys.numPersonasInfectadas += 1;
    }
    if (statShow){
      scene.colorStats();
    }
  }
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
  
  if (key == 'c' || key == 'C'){
    click = !click;
  }
  
  if (key == 'h' || key == 'H'){
    ayuda = !ayuda;
  }
  
  if (key == 'l' || key == 'L'){
    luces = !luces;
  }
  
  if (key == 'e' || key == 'E'){
    statShow = !statShow;
  }
  
  if (key == 'm' || key == 'M'){
    sys.alterColorMode();
  }
  
  if (key == 'z' || key == 'Z'){
    debug = !debug;
  }
  
  if (key == 'x' || key == 'X'){
    debugAgent = !debugAgent;
  }
}

void resetTime(){
  if(finishOg) {
    finish = true;
  }
  startFrame = frameCount;
  finishFrame = startFrame;
  startTime = millis();
  sys.waitingTime = sys.initialWaitingTime;
}

void estadisticas() {
  elapsedTime = millis() - startTime;
  
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
  String time = String.format("%02d:%02d", minutes, seconds %60);
  String simulationTime = String.format("%02d:%02d:%02d", sh %24, sm %60, ss %60);
  
  textSize(20);
  fill(#FFFFFF);
  
  text("Presiona [H] por ayuda", 15, height -210);

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
