// Parámetros del ambiente
float tasaDeVentilacion = 3.0;  // ACH (air changes per hour)
float volumenSala = 50.0;       // Volumen de la sala en metros cúbicos
float tiempoExposicion = 120;   // Tiempo de exposición en minutos
float tasaEmisionQuanta = 100.0; // Quanta emitida por persona infectada
int numPersonasInfectadas = 1;  // Número de personas infectadas

// Parámetros de la persona sana
float tasaInhalacion = 0.5;     // Volumen de aire inhalado por la persona sana (m3/h)
float eficienciaMascarilla = 0.3; // Eficiencia del filtrado (30% de aerosoles filtrados)
float distancia = 2.0;          // Distancia en metros a la persona infectada

// Método para calcular la concentración de quanta en el aire
float calcularConcentracionQuanta(float tasaEmision, float ventilacion, float volumen, float tiempo) {
  float lambda = ventilacion + 0.24; // Incluye ventilación y decaimiento de quanta
  float C = (tasaEmision / (lambda * volumen)) * (1 - exp(-lambda * tiempo / 60.0)); // Ecuación adaptada
  return C;
}

// Método para calcular la probabilidad de contagio
float calcularProbabilidadInfeccion() {
  // Calcular concentración de quanta en el ambiente
  float concentracionQuanta = calcularConcentracionQuanta(tasaEmisionQuanta * numPersonasInfectadas, 
                                                          tasaDeVentilacion, 
                                                          volumenSala, 
                                                          tiempoExposicion);
                                                          
  // Ajustar por la eficiencia de la mascarilla y distancia
  float ajusteMascarilla = 1 - eficienciaMascarilla;
  float ajusteDistancia = max(1 / pow(distancia, 2), 0.1); // Asume dispersión cuadrática
  
  // Calcular cuántas quanta inhala la persona sana
  float quantaInhaladas = tasaInhalacion * concentracionQuanta * ajusteMascarilla * ajusteDistancia;
  
  // Aplicar la fórmula de probabilidad de Wells-Riley
  float probabilidad = 1 - exp(-quantaInhaladas);
  return probabilidad;
}

// Método principal de simulación
void draw() {
  // Calcular la probabilidad de infección en cada ciclo
  float probabilidadInfeccion = calcularProbabilidadInfeccion();
  
  // Mostrar la probabilidad de infección
  background(255);
  fill(0);
  textSize(16);
  text("Probabilidad de Infección: " + nf(probabilidadInfeccion * 100, 1, 2) + "%", 50, 50);
  
  noLoop();  // Para que corra una vez
}
