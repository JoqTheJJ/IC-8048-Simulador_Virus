class Scene{
  
  float wall1x1;
  float wall1y1;
  float wall1x2;
  float wall1y2;
  
  float concertX = 0;
  float concertY = height/2 -200;
  float concertW = 300;
  float concertH = height/2 +210;
  
  
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
    
    
    
    
    
    
    
    
    
    
    //rect(height/2 +5, 0, height/2 -5, width/2);
    //Ancho puerta = 100
    noStroke();
    
    
    //Concierto
    fill(#A5A5A5); 
    
    rect(concertX, concertY, concertW, concertH);
    
    
    //W1 Upper wall left
    float w1X = 0;
    float w1Y = height/2 - 210;
    float w1W = width/2;
    float w1H = 10;
    rect(w1X, w1Y, w1W, w1H);
    
    //W2 Upper wall right
    float w2X = width/2 +100;
    float w2Y = height/2 -210;
    float w2W = width/2 -100;
    float w2H = 10;
    rect(w2X, w2Y, w2W, w2H);
    
    //W3 Down wall up
    float w3X = width*3/4;
    float w3Y = height/2 -210;
    float w3W = 10;
    float w3H = 253;
    rect(w3X, w3Y, w3W, w3H);
    
    //W4 Down wall down
    float w4X = width*3/4;
    float w4Y = height/2 +158;
    float w4W = 10;
    float w4H = height/2 -150;
    rect(w4X, w4Y, w4W, w4H);
    
  }
}
