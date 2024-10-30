
ArrayList<Integer> colorsInfection;
void addColorsInfection(){
  colorsInfection = new ArrayList();
  colorsInfection.add(color(10, 154, 67));  //Verde
  colorsInfection.add(color(103, 186, 61)); //Verde claro
  colorsInfection.add(color(168, 208, 57)); //Verde muy claro
  colorsInfection.add(color(247, 230, 51)); //Amarillo
  colorsInfection.add(color(240, 159, 44)); //Naranja claro
  colorsInfection.add(color(232, 83, 37));  //Naranja oscuro
  colorsInfection.add(color(222, 38, 38));  //Rojo
}

ArrayList<Integer> colorsMask;
void addColorsMask(){
  colorsMask = new ArrayList();
  colorsMask.add(#FFFFFF); //Blanco
  colorsMask.add(#337CFF); //Azul Claro
  colorsMask.add(#0A3BD8); //Azul
}


void addMascarillas(){
  mascarillas = new ArrayList();
  mascarillas.add(0.0); //Sin mascarilla
  mascarillas.add(0.3); //Generica
  mascarillas.add(0.6); //Quirurgica
  mascarillas.add(0.9); //N95
}





void addActores(){
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
  actores.add(new Actor( //Cantante secundario
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
  
  
  actores.add(new Actor( //Guarda
    width*3/4+5,
    height/2 +50,
    #2382FA,
    Rol.GUARDA)
    );
  actores.add(new Actor( //Guarda
    width*3/4+5,
    height/2 +150,
    #2382FA,
    Rol.GUARDA)
    );
}



void addRepeledores(){
  repeledores = new ArrayList<Repeledor>();
  
  //Muro 1 superior
  repeledores.add(new Repeledor(0, scene.w1Y-50, scene.w1W-20, 50,
  0.13, new PVector(0, -1), sys));
  //Muro 1 Inferior
  repeledores.add(new Repeledor(0, scene.w1Y +scene.w1H, scene.w1W-20, 50,
  0.13, new PVector(0, 1), sys));
  
  
  //Muro 2 superior
  repeledores.add(new Repeledor(scene.w2X+20, scene.w2Y-50, width, 50,
  0.13, new PVector(0, -1), sys));
  //Muro 2 Inferior
  repeledores.add(new Repeledor(scene.w2X+20, scene.w2Y +scene.w2H, scene.w3X - scene.w2X+20, 50,
  0.13, new PVector(0, 1), sys));
  
  
  //Muro 3 y 4 Izquierda
  repeledores.add(new Repeledor(scene.w3X-50, scene.w3Y, 50, height - scene.w3Y,
  0.11, new PVector(-1, 0), sys));  
  
  //Entrada
  repeledores.add(new Repeledor(scene.w4X, scene.w4Y - 100, 200, 100,
  0.15, new PVector(-1, 0), sys));  
}













// ############################  ############################ //
// ###################### MENU PRINCIPAL #################### //
// ############################  ############################ //



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
