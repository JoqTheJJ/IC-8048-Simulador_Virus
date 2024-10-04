class Scene{
  
  float wall1x1;
  float wall1y1;
  float wall1x2;
  float wall1y2;
  
  Scene(){
    /*
    wall1x1 = 0;
    wall1y1 = height/2 +5;
    wall1x2 = width/2;
    wall1y2 = height/2 -5;
    */
  }
  
  
  void run(){
    display();
  }
  
  void display(){
    noStroke();
    fill(#A5A5A5);
    rectMode(CORNERS);
    //rect(height/2 +5, 0, height/2 -5, width/2);
    //Ancho puerta = 100
    
    //W1 Upper wall left
    rect(0, height/2 -210, width/2, height/2 -200);
    
    //W2 Upper wall right
    rect(width/2 +100, height/2 -210, width, height/2 -200);
    
    //W3 Down wall up
    rect(width*3/4, height/2 -210, width*3/4+10, height/2 +50);
    
    //W4 Down wall down
    rect(width*3/4, height/2 +150, width*3/4+10, height);
    
    //Concierto
    rect(0, height/2 -210, +300, height);
  }
}
