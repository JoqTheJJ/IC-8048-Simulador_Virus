class Scene{
  
  
  float concertX = 0;
  float concertY = height/2 -200;
  float concertW = 300;
  float concertH = height/2 +210;
  
  //W1 Upper wall left
  float w1X = 0;
  float w1Y = height/2 - 210;
  float w1W = width/2;
  float w1H = 10;
  
  //W2 Upper wall right
  float w2X = width/2 +100;
  float w2Y = height/2 -210;
  float w2W = width/2 -100;
  float w2H = 10;
  
  //W3 Down wall up
  float w3X = width*3/4;
  float w3Y = height/2 -210;
  float w3W = 10;
  float w3H = 253;
  
  //W4 Down wall down
  float w4X = width*3/4;
  float w4Y = height/2 +158;
  float w4W = 10;
  float w4H = height/2 -150;
  
  float radio = 10;
  
  Scene(){
    /*
    wall1x1 = 0;
    wall1y1 = height/2 +5;
    wall1x2 = width/2;
    wall1y2 = height/2 -5;
    */
  }
  
  void display(){
    
    //Ancho puerta = 100
    noStroke();
    
    //Concierto
    fill(#242424);
    rect(concertX, concertY, concertW, concertH);
    
    //Walls
    fill(#A5A5A5);
    
    //W1 Upper wall left
    rect(w1X, w1Y, w1W, w1H);
    //W2 Upper wall right
    rect(w2X, w2Y, w2W, w2H);
    //W3 Down wall up
    rect(w3X, w3Y, w3W, w3H);
    //W4 Down wall down
    rect(w4X, w4Y, w4W, w4H);
    
    
    
    //Personas
    float radio = this.radio * 2;
    strokeWeight(3);
    stroke(#000000);


    //Artistas
    fill(#0BB7B5);
    circle(concertW/2 +20, (2*concertY+concertH)/2 +120  -30, radio); // 1
    circle(concertW/2 +30, (2*concertY+concertH)/2 +132  -30, radio); // 2
    circle(concertW/2 +30, (2*concertY+concertH)/2 +148  -30, radio); // 3
    circle(concertW/2 +20, (2*concertY+concertH)/2 +160  -30, radio); // 4
    
    fill(#00FFFD);
    circle(concertW/2 +10, (2*concertY+concertH)/2 +140  -30, radio);
    
    fill(#6203FF);
    circle(concertW/2 +20, (2*concertY+concertH)/2 +70  -30, radio);
    
    fill(#FFFFFF);
    //circle(concertW/2 +30, (2*concertY+concertH)/2 +0, radio);
    
    fill(#FE00FF);
    //circle(concertW/2 +20, (2*concertY+concertH)/2 -70  -30, radio);
    
    fill(#03FF11);
    circle(concertW/2 +10, (2*concertY+concertH)/2 -140  -30, radio);
    
    //Guardas
    fill(#0A39F0);
    circle(width*3/4+5, height/2 +50, radio);
    circle(width*3/4+5, height/2 +150, radio);
  }
}
