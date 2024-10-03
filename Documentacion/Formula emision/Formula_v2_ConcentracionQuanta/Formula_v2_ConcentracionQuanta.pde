// Parámetros del ambiente
float tasaDeVentilacion = 3.0;    // ACH (air changes per hour)
float tasaEmisionQuanta = 100.0;  // Quanta emitida por persona infectada
int numPersonasInfectadas = 1;    // Número de personas infectadas

//Descartados
float volumenAmbiente = 50.0;     // Volumen de la sala en metros cúbicos
float tiempoExposicion = 120;     // Tiempo de exposición en minutos

// Parámetros de la persona sana
float tasaInhalacion = 0.5;       // Volumen de aire inhalado por la persona sana (m3/h)
float eficienciaMascarilla = 0.3; // Eficiencia del filtrado (30% de aerosoles filtrados)
float distancia = 2.0;            // Distancia en metros a la persona infectada



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


// Método para calcular la concentración de quanta en el aire
/*
float calcularConcentracionQuanta(float tasaEmision, float ventilacion, float volumen, float tiempo) {
  float lambda = ventilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  return (tasaEmision / (lambda * volumen)) * (1 - exp(-lambda * tiempo / 60.0));
}
*/

float calcularProbabilidadInfeccion() {
  float concentracionQuanta = calcularConcentracionQuanta(
    tasaEmisionQuanta * numPersonasInfectadas, 
    tasaDeVentilacion, 
    volumenSala, 
    tiempoExposicion);
                                                          
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




void setup(){
  size(500, 100);
}


void draw() {
  // Calcular la probabilidad de infección en cada ciclo
  float probabilidadInfeccion = calcularProbabilidadInfeccion();
  
  // Mostrar la probabilidad de infección
  background(255);
  fill(0);
  textSize(16);
  text("Probabilidad de Infección: " + nf(probabilidadInfeccion * 100, 1, 2) + "%", 50, 50);
  
  noLoop();
}
