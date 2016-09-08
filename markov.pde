class Markov {
  int state = 0;
  int previousState = 0;
  //TODO proper matrix implementation
  int[] states = { 0, 1, 2, 3 };
  double[][] probabilities = {
                               {0.3, 0.3, 0.3, 0.1},
                               {0.3, 0.3, 0.3, 0.1},
                               {0.3, 0.3, 0.3, 0.1},
                               {0.1, 0.1, 0.1, 0.7}
                             };
  
  EnumeratedIntegerDistribution[] distributions = {
    new EnumeratedIntegerDistribution(states, probabilities[0]),
    new EnumeratedIntegerDistribution(states, probabilities[1]),
    new EnumeratedIntegerDistribution(states, probabilities[2]),
    new EnumeratedIntegerDistribution(states, probabilities[3])
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