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
int totalSanos = 800;
int totalContagiados = 50;

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
    .setRange(1, 6.2)
    .setValue(tasaDeVentilacion)
    .setCaptionLabel("")
    .setFont(font);
    
  sPersonas = cp5.addSlider("setTotalSanos")
    .setPosition(width/2 - 250, height/2 -200)
    .setSize(200, 50)
    .setRange(100, 800)
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
  
  repeledores = new ArrayList<Repeledor>();
  
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
    
  print("\n\n\n\n\n\n\n\n");
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

void setEficienciaMascarilla(float value){
  eficienciaMascarilla = value;
}

void setTasaDeVentilacion(float value){
  tasaDeVentilacion = value;
}

void setTotalSanos(float value){
  totalSanos = (int)value;
}

void setTotalContagiados(float value){
  totalContagiados = (int)value;
}

void setPorcentajeMascarilla(float value){
  porcentajeMascarilla = value;
}

void menuPrincipal(){
  
  //Center: (width/2 - 150, height/2 + 50)
  PVector pos = new PVector(width/2 - 350, height/2 + 50);
  PVector posS = new PVector(pos.x + 200      , pos.y - 400);
  PVector posC = new PVector(pos.x + 200 + 350, pos.y - 400);
  float radio = 100;
  PFont menuFont = createFont("8bitOperatorPlus8-Regular.ttf", 50);
  textFont(menuFont);
  fill(#000000);
  
  
  text("PRESIONA ENTER PARA INICIAR", width/2 - 350, pos.y + 450);
  
  
  
  text((int)(totalSanos),    pos.x - 50 + 200, pos.y - 160);
  strokeWeight(20);
  stroke(#000000);
  
  fill(colorsInfection.get(0));
  circle(posS.x, posS.y, radio*2); //Cuerpo
  
  fill(#000000);
  rect(posS.x-30, posS.y-40, 10, 14); //Ojos
  rect(posS.x+30, posS.y-40, 10, 14); //Ojos
  
  text((int)(totalContagiados), pos.x + 300 + 200, pos.y - 160);
  strokeWeight(20);
  stroke(#000000);
  
  fill(colorsInfection.get(6));
  circle(posC.x, posC.y, radio*2); //Cuerpo
  
  fill(#000000);
  rect(posC.x-30, posC.y-40, 10, 14); //Ojos
  rect(posC.x+30, posC.y-40, 10, 14); //Ojos
  
  
  text((int)(tasaDeVentilacion), pos.x + 740, pos.y + 240);
  pushMatrix();
  translate(pos.x + 400 + 350, pos.y);
  rotate(rotacionVentilador);
  image(imagenVentilacion, -100, -100, 200, 200);
  rotacionVentilador += 0.01 * 2 * tasaDeVentilacion;
  popMatrix();
  
  
  
  text((int)(porcentajeMascarilla*100) + "%", pos.x + 325, pos.y + 240);
  PVector center = new PVector(pos.x + 375, pos.y);
  PVector p1 = new PVector(center.x, center.y + 90);
  PVector p2 = new PVector(center.x - 100, center.y + 15);
  PVector p3 = new PVector(center.x + 100, center.y + 15);
  PVector p4 = new PVector(center.x - 62, center.y - 102);
  PVector p5 = new PVector(center.x + 62, center.y - 102);
  

  strokeWeight(18);
  stroke(#000000);
  
  
  
  fill(colorsInfection.get(0));
  circle(p1.x, p1.y, radio); //Cuerpo
  fill(#000000);
  rect(p1.x-15, p1.y-15, 5, 7); //Ojos
  rect(p1.x+15, p1.y-15, 5, 7); //Ojos
  
  fill(colorsInfection.get(0));
  circle(p2.x, p2.y, radio); //Cuerpo
  fill(#000000);
  rect(p2.x-15, p2.y-15, 5, 7); //Ojos
  rect(p2.x+15, p2.y-15, 5, 7); //Ojos
  
  fill(colorsInfection.get(0));
  circle(p3.x, p3.y, radio); //Cuerpo
  fill(#000000);
  rect(p3.x-15, p3.y-15, 5, 7); //Ojos
  rect(p3.x+15, p3.y-15, 5, 7); //Ojos
  
  fill(colorsInfection.get(0));
  circle(p4.x, p4.y, radio); //Cuerpo
  fill(#000000);
  rect(p4.x-15, p4.y-15, 5, 7); //Ojos
  rect(p4.x+15, p4.y-15, 5, 7); //Ojos
  
  fill(colorsInfection.get(0));
  circle(p5.x, p5.y, radio); //Cuerpo
  fill(#000000);
  rect(p5.x-15, p5.y-15, 5, 7); //Ojos
  rect(p5.x+15, p5.y-15, 5, 7); //Ojos
  
  int m = int(map(eficienciaMascarilla, 0, 1, 1, 4));
  fill(colorsMask.get(m-1));
  strokeWeight(5);
  
  if (porcentajeMascarilla > 0.20){
    line(p2.x-50, p2.y,     p2.x+50, p2.y);
    line(p2.x-50, p2.y +10, p2.x+50, p2.y +10);
    arc(p2.x, p2.y, radio*0.7, radio*0.7, 0, PI, CHORD);
  }
  if (porcentajeMascarilla > 0.40){
    line(p4.x-50, p4.y,     p4.x+50, p4.y);
    line(p4.x-50, p4.y +10, p4.x+50, p4.y +10);
    arc(p4.x, p4.y, radio*0.7, radio*0.7, 0, PI, CHORD);
  }
  if (porcentajeMascarilla > 0.60){
    line(p5.x-50, p5.y,     p5.x+50, p5.y);
    line(p5.x-50, p5.y +10, p5.x+50, p5.y +10);
    arc(p5.x, p5.y, radio*0.7, radio*0.7, 0, PI, CHORD);
  }
  if (porcentajeMascarilla > 0.80){
    line(p3.x-50, p3.y,     p3.x+50, p3.y);
    line(p3.x-50, p3.y +10, p3.x+50, p3.y +10);
    arc(p3.x, p3.y, radio*0.7, radio*0.7, 0, PI, CHORD);
  }
  if (porcentajeMascarilla > 0.99){
    line(p1.x-50, p1.y,     p1.x+50, p1.y);
    line(p1.x-50, p1.y +10, p1.x+50, p1.y +10);
    arc(p1.x, p1.y, radio*0.7, radio*0.7, 0, PI, CHORD);
  }
  
  
  
  
  
  
  fill(#000000);
  text((int)(eficienciaMascarilla*100) + "%", pos.x - 50, pos.y + 240);
    
  fill(colorsMask.get(m-1));
  
  strokeWeight(15);
  line(pos.x-radio+20, pos.y -5, pos.x+radio-20, pos.y -5);
  line(pos.x-radio+20, pos.y +15, pos.x+radio-20, pos.y +15);
  arc(pos.x, pos.y, radio*1.3, radio*1.3, 0, PI, CHORD);
  
  if (eficienciaMascarilla < 0.005){
    image(imagenProhibido, pos.x - 125, pos.y - 125, 250, 250);
  }
}

void cerrarMenuPrincipal(){
  
  textFont(createFont("SansSerif", 12));
  
  sEficiencia.hide();
  sVentilacion.hide();
  sPersonas.hide();
  sContagiados.hide();
  sPorcentajeMascarilla.hide();
  
  sys.simulacion(totalSanos, totalContagiados);
  
  start = false;
  pause = false;
  
  resetTime();
}
