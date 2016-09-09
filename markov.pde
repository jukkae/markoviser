class Markov {
  int state = 0;
  int previousState = 0;
  //TODO proper matrix implementation
  int[] states = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
  double[][] probabilities = {//A  Bb B  C  Db D  Eb E  F  Gb G  Ab
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //A
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //Bb
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //B
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //C
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //Db
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //D
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //Eb
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //E
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //F
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //Gb
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //G
                               {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}  //Ab
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