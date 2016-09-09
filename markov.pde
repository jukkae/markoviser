enum Order {
  FIRST, SECOND;
}

class Markov {
  Order order = Order.SECOND;
  int state = 0;
  int previousState = 0;
  //TODO proper matrix implementation
  int[] states = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
  double[][] firstOrderProbabilities = {//A  Bb B  C  Db D  Eb E  F  Gb G  Ab
                                         {1, 3, 2, 3, 0, 0, 0, 3, 0, 0, 0, 0}, //A
                                         {1, 3, 0, 0, 4, 0, 0, 0, 3, 0, 0, 0}, //Bb
                                         {1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0}, //B
                                         {1, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 0}, //C
                                         {1, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0}, //Db
                                         {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //D
                                         {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //Eb
                                         {1, 0, 0, 3, 0, 0, 0, 1, 5, 0, 0, 0}, //E
                                         {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0}, //F
                                         {1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0}, //Gb
                                         {1, 0, 0, 0, 0, 5, 0, 0, 0, 4, 0, 0}, //G
                                         {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}  //Ab
                                       };
                             
  double[][][] secondOrderProbabilities = {
                                            {               //cur  last
                                              {0, 1, 1, 1}, //A <- A
                                              {1, 0, 0, 0}, //A <- C
                                              {1, 0, 0, 0}, //A <- D
                                              {1, 0, 0, 0}  //A <- E
                                            }, {  
                                              {1, 0, 0, 0}, //C <- A
                                              {1, 0, 0, 0}, //C <- C
                                              {1, 0, 0, 0}, //C <- D
                                              {1, 0, 0, 0}  //C <- E
                                            }, {
                                              {1, 0, 0, 0}, //D <- A
                                              {1, 0, 0, 0}, //D <- C
                                              {1, 0, 0, 0}, //D <- D
                                              {1, 0, 0, 0}  //D <- E
                                            }, {
                                              {1, 0, 0, 0}, //E <- A
                                              {1, 0, 0, 0}, //E <- C
                                              {1, 0, 0, 0}, //E <- D
                                              {1, 0, 0, 0}  //E <- E
                                            }
                                          };
  
  EnumeratedIntegerDistribution[]   firstOrderDistributions; 
  EnumeratedIntegerDistribution[][] secondOrderDistributions;
  
  Markov() {
    initFirstOrderDistributions();
    initSecondOrderDistributions();
  }
  
  void initFirstOrderDistributions() {
    firstOrderDistributions = new EnumeratedIntegerDistribution[12];
    for(int i = 0; i < firstOrderDistributions.length; i++) {
      firstOrderDistributions[i] = new EnumeratedIntegerDistribution(states, firstOrderProbabilities[i]);
    }
  }
  
  void initSecondOrderDistributions() {
    int[] secOrdStates = {0, 3, 5, 7};
    secondOrderDistributions = new EnumeratedIntegerDistribution[4][4];
    for(int i = 0; i < 4; i++) {
      for(int j = 0; j < 4; j++) {
        secondOrderDistributions[i][j] = new EnumeratedIntegerDistribution(secOrdStates, secondOrderProbabilities[i][j]);
      }
    }
  }
  
  int getState() {
    return state;
  }
  
  int getNext() {
    switch (order) {
      case FIRST:
        return getNextFirstOrder();
      case SECOND:
        return getNextSecondOrder();
      default:
        return state;
    }
    
  }
  
  private int getNextFirstOrder() {
    previousState = state;
    int s = firstOrderDistributions[state].sample();
    state = s;
    println("previous state: " + previousState);
    println(" current state: " + state);
    return s;
  }
  
  //TODO ughh
  private int getNextSecondOrder() {
    int i = 0;
    switch(previousState) {
      case 0: i = 0; break;
      case 3: i = 1; break;
      case 5: i = 2; break;
      case 7: i = 3; break;
    }
    int j = 0;
    switch(state) {
      case 0: j = 0; break;
      case 3: j = 1; break;
      case 5: j = 2; break;
      case 7: j = 3; break;      
    }
    previousState = state;
    int s = secondOrderDistributions[j][i].sample();
    state = s;
    println("previous state: " + previousState);
    println(" current state: " + state);
    return s;
  }
  
  
}