class Markov {
  int state = 0;
  int previousState = 0;
  //TODO proper matrix implementation
  int[] states = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
  double[][] probabilities = {
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //A
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //Bb
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //B
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //C
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //Db
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //D
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //Eb
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //E
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //F
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //Gb
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}, //G
                               {30, 5, 10, 30, 5, 30, 10, 30, 10, 5, 10, 5}  //Ab
                             };
  
  EnumeratedIntegerDistribution[] distributions = {
    new EnumeratedIntegerDistribution(states, probabilities[0]),
    new EnumeratedIntegerDistribution(states, probabilities[1]),
    new EnumeratedIntegerDistribution(states, probabilities[2]),
    new EnumeratedIntegerDistribution(states, probabilities[3]),
    new EnumeratedIntegerDistribution(states, probabilities[4]),
    new EnumeratedIntegerDistribution(states, probabilities[5]),
    new EnumeratedIntegerDistribution(states, probabilities[6]),
    new EnumeratedIntegerDistribution(states, probabilities[7]),
    new EnumeratedIntegerDistribution(states, probabilities[8]),
    new EnumeratedIntegerDistribution(states, probabilities[9]),
    new EnumeratedIntegerDistribution(states, probabilities[10]),
    new EnumeratedIntegerDistribution(states, probabilities[11])
  };
  
  Markov() {
    initDistributions();
  }
  
  void initDistributions() {
    
  }
  
  int getState() {
    return state;
  }
  
  int getNext() {
    previousState = state;
    int s = distributions[state].sample();
    state = s;
    return s;
  }
  
  
}