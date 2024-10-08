// Simulacion
boolean pause = false;
AgentSystem sys;
Scene scene;






void setup() {
  //size(800, 800);
  fullScreen();
  addColors();
  sys = new AgentSystem();
  scene = new Scene();
}

void draw(){
  background(#CECECE);
  
  
  
  if (!pause){
    sys.run();
    scene.run();
  } else {
    sys.display();
    scene.display();
  }
  
  textSize(32);
  fill(0);
  text("Personas: "+sys.numPersonas, 15, height/2 -110);
  text("Infectados: "+sys.numPersonasInfectadas, 15, height/2 -10);
  text("Sanos: "+(sys.numPersonas-sys.numPersonasInfectadas), 15, height/2 +90);
  
  
  if (mousePressed && mouseButton == LEFT) {
    sys.addAgent(mouseX, mouseY, false);
    sys.numPersonas += 1;
  }
}




void mousePressed(){
  if(mouseButton == RIGHT){
    sys.addAgent(mouseX, mouseY, true);
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
