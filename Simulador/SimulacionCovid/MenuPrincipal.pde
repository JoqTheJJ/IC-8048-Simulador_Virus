



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
  
  
  text((int)(tasaDeVentilacion), pos.x + 730, pos.y + 240);
  pushMatrix();
  translate(pos.x + 400 + 350, pos.y);
  rotate(rotacionVentilador);
  image(imagenVentilacion, -100, -100, 200, 200);
  rotacionVentilador += 0.01 * 1.5 * tasaDeVentilacion;
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
