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

//Formula usada
float calcularConcentracionQuantaEquilibrada(int PersonasInfectadas){
  float tasaEmisionPorHora = tasaEmisionQuanta * PersonasInfectadas;
  float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  float quantaEquilibradaPorHora = tasaEmisionPorHora / tasaEliminacionPorHora;
  float quantaEquilibradaPorMinuto = quantaEquilibradaPorHora / 60;
  return quantaEquilibradaPorMinuto;
}

//Se remueve la variable personas
float calcularConcentracionQuantaEquilibradaIndividual(){
  float tasaEmisionPorHora = tasaEmisionQuanta;
  float tasaEliminacionPorHora = tasaDeVentilacion + 0.24; // 0.24 = Tasa de deposición de los aerosoles en el ambiente
  float quantaEquilibradaPorHora = tasaEmisionPorHora / tasaEliminacionPorHora;
  float quantaEquilibradaPorMinuto = quantaEquilibradaPorHora / 60;
  return quantaEquilibradaPorMinuto;
}

//Que tanto quantum se enferma?

/*
Cantidad de quanta necesaria para infectarse:
1 quantum inhalado ≈ 63% de probabilidad de infección.
2 quanta inhalados ≈ 86% de probabilidad de infección.
3 quanta inhalados ≈ 95% de probabilidad de infección.

Yo diria 1 o 2 quanta, talvez 1.5?

Falta hacer la emision de quanta por los infectados
 pero es parecido a la tasa de inhalacion
*/



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

float quantaInhalada(float distancia){
  float concentracionQuanta = calcularConcentracionQuantaEquilibradaIndividual();
  float tasaInhalacion = tasaInhalacion(estado);
  float ajusteDistancia = ajusteDistancia(distancia);
  
  return concentracionQuanta * tasaInhalacion * (1 - eficienciaMascarilla) * ajusteDistancia;
}
