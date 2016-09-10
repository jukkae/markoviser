enum Order {
  FIRST, SECOND;
}

class Markov {
  Order order = Order.SECOND;
  int state = 0;
  int previousState = 0;
  int value = 4;
  int previousValue = 4;
  
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
                                            {//A  C  D  E  F  cur  last
                                              {1, 1, 0, 1, 0}, //A <- A
                                              {1, 0, 0, 0, 0}, //A <- C
                                              {4, 0, 2, 0, 1}, //A <- D
                                              {4, 0, 0, 0, 1}, //A <- E
                                              {1, 0, 0, 1, 0}  //A <- F
                                            }, {  
                                              {1, 0, 2, 0, 0}, //C <- A
                                              {1, 0, 0, 0, 0}, //C <- C
                                              {2, 0, 0, 1, 0}, //C <- D
                                              {1, 0, 0, 0, 0}, //C <- E
                                              {1, 0, 0, 0, 0}  //C <- F
                                            }, {
                                              {1, 0, 0, 0, 0}, //D <- A
                                              {0, 1, 1, 3, 0}, //D <- C
                                              {2, 2, 0, 0, 1}, //D <- D
                                              {0, 1, 0, 0, 0}, //D <- E
                                              {1, 0, 1, 0, 1}  //D <- F
                                            }, {
                                              {1, 0, 0, 1, 1}, //E <- A
                                              {1, 0, 0, 0, 0}, //E <- C
                                              {0, 0, 2, 0, 1}, //E <- D
                                              {2, 0, 2, 0, 1}, //E <- E
                                              {2, 1, 0, 0, 4}  //E <- F
                                            }, {
                                              {0, 0, 0, 1, 0}, //F <- A
                                              {0, 1, 0, 0, 0}, //F <- C
                                              {0, 1, 0, 1, 0}, //F <- D
                                              {0, 0, 0, 1, 1}, //F <- E
                                              {0, 0, 1, 1, 0}  //F <- F
                                            }
                                          };
  
  //TODO remove 8.!
  double[][][] secondOrderValueProbabilities = {
                                                 {//16 8  8. 4  4. 2  2. 1     cur  last
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //16 - 16
                                                   {1, 0, 0, 0, 0, 0, 0, 0}, //16 - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //16 - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 16
                                                   {0, 5, 0, 2, 0, 1, 0, 1}, //8  - 8
                                                   {0, 0, 0, 3, 0, 0, 1, 0}, //8  - 8.
                                                   {1, 3, 0, 0, 0, 0, 0, 0}, //8  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 4.
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //8  - 2
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //8  - 2.
                                                   {0, 1, 0, 0, 0, 0, 0, 0}  //8  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 16
                                                   {0, 0, 1, 0, 0, 0, 0, 0}, //8. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //8. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 16
                                                   {0, 2, 0, 8, 1, 0, 1, 1}, //4  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 8.
                                                   {0, 2, 0, 9, 1, 1, 1, 1}, //4  - 4
                                                   {0, 0, 0, 1, 1, 0, 0, 0}, //4  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 2
                                                   {0, 0, 0, 2, 0, 0, 1, 1}, //4  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //4  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 8.
                                                   {0, 0, 0, 0, 1, 0, 0, 0}, //4. - 4
                                                   {0, 0, 0, 1, 0, 0, 1, 0}, //4. - 4.
                                                   {0, 1, 0, 0, 1, 0, 0, 0}, //4. - 2
                                                   {0, 0, 0, 1, 1, 1, 0, 0}, //4. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //4. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 8.
                                                   {0, 1, 0, 1, 0, 2, 0, 0}, //2  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 4.
                                                   {0, 1, 0, 1, 1, 1, 1, 0}, //2  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //2  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 8.
                                                   {0, 1, 0, 1, 0, 0, 1, 0}, //2. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 2
                                                   {0, 1, 0, 2, 1, 0, 0, 0}, //2. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //2. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8.
                                                   {0, 1, 0, 3, 0, 0, 0, 0}, //1  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //1  - 1
                                                 }
                                               };
  
  EnumeratedIntegerDistribution[]   firstOrderDistributions; 
  EnumeratedIntegerDistribution[][] secondOrderDistributions;
  EnumeratedIntegerDistribution[][] rhythmDistributions;
  
  Markov() {
    initFirstOrderDistributions();
    initSecondOrderDistributions();
    initRhythmDistributions();
  }
  
  void initFirstOrderDistributions() {
    firstOrderDistributions = new EnumeratedIntegerDistribution[12];
    for(int i = 0; i < firstOrderDistributions.length; i++) {
      firstOrderDistributions[i] = new EnumeratedIntegerDistribution(states, firstOrderProbabilities[i]);
    }
  }
  
  void initSecondOrderDistributions() {
    int[] secOrdStates = {0, 3, 5, 7, 8};
    secondOrderDistributions = new EnumeratedIntegerDistribution[5][5];
    for(int i = 0; i < 5; i++) {
      for(int j = 0; j < 5; j++) {
        secondOrderDistributions[i][j] = new EnumeratedIntegerDistribution(secOrdStates, secondOrderProbabilities[i][j]);
      }
    }
  }
  
  //TODO variable naming! rhythm vs value etc
  void initRhythmDistributions() {
    int[] rhythmStates = {1, 2, 3, 4, 6, 8, 12, 16};
    rhythmDistributions = new EnumeratedIntegerDistribution[8][8];
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        rhythmDistributions[i][j] = new EnumeratedIntegerDistribution(rhythmStates, secondOrderValueProbabilities[i][j]);
      }
    }
  }
  
  int getState() {
    return state;
  }
  
  int getNextNote() {
    switch (order) {
      case FIRST:
        return getNextFirstOrderNote();
      case SECOND:
        return getNextSecondOrderNote();
      default:
        return state;
    }
    
  }
  
  private int getNextFirstOrderNote() {
    previousState = state;
    int s = firstOrderDistributions[state].sample();
    state = s;
    println("previous state: " + previousState);
    println(" current state: " + state);
    return s;
  }
  
  //TODO ughh
  private int getNextSecondOrderNote() {
    int i = 0;
    switch(previousState) {
      case 0: i = 0; break;
      case 3: i = 1; break;
      case 5: i = 2; break;
      case 7: i = 3; break;
      case 8: i = 4; break;
    }
    int j = 0;
    switch(state) {
      case 0: j = 0; break;
      case 3: j = 1; break;
      case 5: j = 2; break;
      case 7: j = 3; break;
      case 8: j = 4; break;
    }
    previousState = state;
    int s = secondOrderDistributions[j][i].sample();
    state = s;
    println("previous state: " + previousState);
    println(" current state: " + state);
    return s;
  }
  
  //TODO ehhh
  int getNextValue() {
    // 1 2 3 4 6 8 12 16
    int i = 3;
    switch(previousValue) {
      case 1:  i = 0; break;
      case 2:  i = 1; break;
      case 3:  i = 2; break;
      case 4:  i = 3; break;
      case 6:  i = 4; break;
      case 8:  i = 5; break;
      case 12: i = 6; break;
      case 16: i = 7; break;
    }
    int j = 3;
    switch(value) {
      case 1:  j = 0; break;
      case 2:  j = 1; break;
      case 3:  j = 2; break;
      case 4:  j = 3; break;
      case 6:  j = 4; break;
      case 8:  j = 5; break;
      case 12: j = 6; break;
      case 16: j = 7; break;
    }
    previousValue = value;
    int s = rhythmDistributions[j][i].sample();
    value = s;
    println("previous value: " + previousValue);
    println(" current value: " + value);
    return s;
  }
  
}