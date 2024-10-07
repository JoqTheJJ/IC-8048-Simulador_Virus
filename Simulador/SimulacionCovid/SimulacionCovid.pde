// Simulacion
boolean pause = false;
AgentSystem sys;
Scene scene;






void setup() {
  size(800, 800);
  //fullScreen();
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
  
  if (mousePressed && mouseButton == LEFT) {
    sys.addAgent(mouseX, mouseY, false);
  }
}




void mousePressed(){
  if(mouseButton == RIGHT){
    sys.addAgent(mouseX, mouseY, true);
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
