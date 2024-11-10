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

 <!>
  Se debe instalar ControlP5 para utilizar el programa desde
  las bibliotecas de Processing

##################################################################################################*/
//Import
import controlP5.*;

//Simulacion
boolean start = true;
boolean ayuda = false;
boolean luces = true;
boolean pause = false;
boolean statShow = false;
boolean click = false;

boolean debug = false;
boolean debugAgent = false;

boolean finish = true;
boolean finishOg = finish;

//Tasa de Tiempo
float tasaDeTiempo = 60; //Segundos de simulacion por segundo real

//Control P5
ControlP5 cp5;
float scrollValue = 0;

//Sliders
Slider sEficiencia;
Slider sVentilacion;
Slider sPersonas;
Slider sContagiados;
Slider sPorcentajeMascarilla;
float eficienciaMascarilla = 0;
float porcentajeMascarilla = 0;
float tasaDeVentilacion = 1;// (ACH) Cantidad de cambios de aire por hora
int totalSanos = 100;
int totalContagiados = 100;

//Sprites
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

//Sistema
AgentSystem sys;
ColorMode colorMode;
Scene scene;
Fila fila;
ArrayList<Repeledor> repeledores;
ArrayList<FoodAttractor> foodAttractors;
ArrayList<Tienda> tiendas;
ArrayList<Float> mascarillas;
ArrayList<Actor> actores;

//Tiempo Transcurrido
int startFrame;
int finishFrame;
int startTime;
int elapsedTime;



void setup() {
  //size(1920, 1080);
  fullScreen();
  
  //Inicializar ControlP5
  cp5 = new ControlP5(this);
  print("\n\n\n\n\n\n\n\n");
  
  //Cargar Sprites
  imagenVentilacion = loadImage("ventilacion.png");
  imagenProhibido = loadImage("no.png");
  cesped1 = loadImage("c1.png");
  cesped2 = loadImage("c2.png");
  cesped3 = loadImage("c3.png");
  cesped4 = loadImage("c4.png");
  cesped5 = loadImage("c5.png");
  cesped6 = loadImage("c6.png");
  
  //Añadir Sliders
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
    .setRange(100, 200)
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
  
  //Añadir Variables Globales (Funciones Principales)
  addColorsInfection();
  addColorsMask();
  colorMode = ColorMode.MASK;
  
  //Reiniciar tiempo
  startFrame = 0;
  finishFrame = 0;
  startTime = 0;
  elapsedTime = 0;
  
  //Inicializar sistema
  sys = new AgentSystem();
  scene = new Scene();
  fila = new Fila();
  
  //Añadir Variables Globales (Funciones Principales)
  addTiendas();
  addActores();
  addRepeledores();
}

void draw() {
  if(start) { //Menu Inicial
    background(#CECECE);
    menuPrincipal();
    
  } else if (ayuda) { //Menu Ayuda
    background(#CECECE);
    menuAyuda();
    
  } else { //Simulación Normal
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
    
    //Actualización de estadisticas
    estadisticas();
    if (statShow){
      scene.colorStats();
    }
  }
}

void keyPressed() {
  if (start && key == '\n') {
    //Enter para cerrar el menu principal
    cerrarMenuPrincipal();
  }

  if (key == ' ') {
    //Espacio para pausar el sistema
    pause = !pause;
  }
  
  if (key == 'r' || key == 'R') {
    //Reiniciar la simulación
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
    //Activa/Desactiva el mouse
    click = !click;
  }
  
  if (key == 'h' || key == 'H'){
    //Activa/Desactiva el menu de ayuda
    ayuda = !ayuda;
  }
  
  if (key == 'l' || key == 'L'){
    //Activa/Desactiva el mouse
    luces = !luces;
  }
  
  if (key == 'e' || key == 'E'){
    //Activa/Desactiva las estadisticas individuales
    statShow = !statShow;
  }
  
  if (key == 'm' || key == 'M'){
    //Activa/Desactiva las mascarillas
    sys.alterColorMode();
  }
  
  if (key == 'z' || key == 'Z'){
    //Activa/Desactiva los campos de flujo
    debug = !debug;
  }
  
  if (key == 'x' || key == 'X'){
    //Activa/Desactiva la direccion de los agentes
    debugAgent = !debugAgent;
  }
}

void resetTime(){
  //Reinicia el tiempo de la simulación
  if(finishOg) {
    finish = true;
  }
  startFrame = frameCount;
  finishFrame = startFrame;
  startTime = millis();
  sys.waitingTime = sys.initialWaitingTime;
}

void estadisticas() {
  //Imprime las estadisticas de la simulación
  
  //Manejo del tiempo
  int elapsedFrames = finishFrame - startFrame;
  int elapsedTimeFrames = elapsedFrames / 60; //frames to ms
  int seconds = elapsedTimeFrames;
  int minutes = seconds / 60;
  
  //Manejo del tiempo
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
  
  //text("Presiona [H] por ayuda", 15, height -220);

  text("Tiempo: "+time, 15, height -190);
  text("Simulacion: "+sd+":"+simulationTime, 15, height -170);
  
  text("Nivel de Ventilación: "+(int)tasaDeVentilacion, 15, height -130);
  text("Eficiencia Mascarilla: "+(int)(100*eficienciaMascarilla)+"%", 15, height -110);
  text("Población con Mascarilla: "+(int)(100*porcentajeMascarilla)+"%", 15, height -90);
  
  text("Personas Totales: "+sys.numPersonas, 15, height -60);
  text("Personas Totales: "+sys.numPersonas, 15, height -60);
  
  int total = sys.numPersonas;
  int infectados = sys.numPersonasInfectadas;
  int porcentajeInfeccion = 100*infectados/total;
  text("Enfermos: "+porcentajeInfeccion+"%", 15, height -40);
  text("Sanos: "+(100-porcentajeInfeccion)+"%", 15, height -20);
}
