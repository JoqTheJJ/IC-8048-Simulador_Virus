enum State {
  CONCERT,    //Shouting and being in the concert
  WANDER,     //Walking around slowly and aimlessly
  STILL,      //Still or sitting without motion
  UNAVAILABLE //Bathroom state where no activity is shown
}


// Parámetros del ambiente
float tasaDeVentilacion = 3.0;    // ACH (air changes per hour)
float tasaEmisionQuanta = 100.0;  // Quanta emitida por persona infectada
int numPersonasInfectadas = 1;    // Número de personas infectadas

// Parámetros de la persona sana
float tasaInhalacion = 0.5;       // Volumen de aire inhalado por la persona sana (m3/h)
float eficienciaMascarilla = 0.3; // Eficiencia del filtrado (30% de aerosoles filtrados)
float distancia = 2.0;            // Distancia en metros a la persona infectada
State estado;

//Se remueve la variable volumen de la ecuación original
float calcularConcentracionQuantaEquilibrada(int PersonasInfectadas){
  float tasaEmisionPorHora = tasaEmisionQuanta * PersonasInfectadas;
  float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  float quantaEquilibradaPorHora = tasaEmisionPorHora / tasaEliminacionPorHora;
  float quantaEquilibradaPorMinuto = quantaEquilibradaPorHora / 60;
  return quantaEquilibradaPorMinuto;
}




//Renovado
float ajusteDistancia(float distancia){
  return max(1 / pow(distancia, 2), 0.1);
}

float tasaInhalacion(State estado){
  switch (estado){
    case CONCERT:
    //Realizar ejercicio moderado
      return 2.35;
      
    case WANDER:
    //Caminar lentamente + alteracion
      return 0.92;
      
    case STILL:
    //Estar parado
      return 0.54;
      
    case UNAVAILABLE:
    //Ausencia de presencia
      return 0;
      
    default:
      println("Estado del agente invalido");
      return 9999;
  }
}

float quantaInhalada(float distancia, int personasInfectadas){
  float concentracionQuanta = calcularConcentracionQuantaEquilibrada(personasInfectadas);
  float tasaInhalacion = tasaInhalacion(estado);
  float ajusteDistancia = ajusteDistancia(distancia);
  
  return concentracionQuanta * tasaInhalacion * (1 - eficienciaMascarilla) * ajusteDistancia;
}



//Pre-Codigo Abajo v3
//##################################################################################################
//##################################################################################################
//##################################################################################################

/*

//Codigo original
float calcularProbabilidadInfeccionOG(int numPersonasInfectadas) {
  float concentracionQuanta = calcularConcentracionQuantaEquilibrada(numPersonasInfectadas);
                                                          
  // Ajustar por la eficiencia de la mascarilla y distancia
  float ajusteMascarilla = 1 - eficienciaMascarilla;
  float ajusteDistancia = max(1 / pow(distancia, 2), 0.1); // Asume dispersión cuadrática
  
  // Calcular cuántas quanta inhala la persona sana
  // Infection rate
  float quantaInhaladas = tasaInhalacion * concentracionQuanta * ajusteMascarilla * ajusteDistancia;
  
  // Aplicar la fórmula de probabilidad de Wells-Riley
  // Poisson (quitar)
  float probabilidad = 1 - exp(-quantaInhaladas);
  return probabilidad;
}

*/

//Pre-Codigo Abajo v2
//##################################################################################################
//##################################################################################################
//##################################################################################################

/*

//Ecuacion original
float calcularConcentracionQuanta(float tasaEmision, float ventilacion, float volumen, float tiempo) {
  float lambda = ventilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  return (tasaEmision / (lambda * volumen)) * (1 - exp(-lambda * tiempo / 60.0));
}

//Se remueve la variable tiempo de la ecuacion original
float calcularConcentracionQuantaEquilibradaAmbiente(){
  float tasaEmisionPorHora = tasaEmisionQuanta * numPersonasInfectadas;
  float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  float quantaEquilibradaPorHora = tasaEmisionPorHora / (tasaEliminacionPorHora * volumenAmbiente);
  float quantaEquilibradaPorMinuto = quantaEquilibradaPorHora / 60;
  return quantaEquilibradaPorMinuto;
}

//Se remueve la variable volumen de la ecuación original
float calcularConcentracionQuantaEquilibrada(){
  float tasaEmisionPorHora = tasaEmisionQuanta * numPersonasInfectadas;
  float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  float quantaEquilibradaPorHora = tasaEmisionPorHora / tasaEliminacionPorHora;
  float quantaEquilibradaPorMinuto = quantaEquilibradaPorHora / 60;
  return quantaEquilibradaPorMinuto;
}

*/

//Pre-Codigo Abajo
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################
//##################################################################################################






void setup(){
  size(500, 100);
}


void draw() {
  
  // Mostrar la probabilidad de infección
  background(255);
  fill(0);
  textSize(16);
  text("Probabilidad de Infección: " + nf(1 * 100, 1, 2) + "%", 50, 50);
  
  noLoop();
}
