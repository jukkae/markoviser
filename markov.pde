enum Order {
  FIRST, SECOND;
}

class Markov {
  Order order = Order.SECOND;
  int state = 0;
  int previousState = 0;
  int value = 4;
  int previousValue = 4;
  int muting = 0;
  int previousMuting = 0;
  int legato = 0;
  int previousLegato = 0;
  
  //TODO proper matrix implementation
  int[] states = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
  int[] secOrdStates = {0, 2, 3, 5, 7, 8, 10};
  int[] mutingStates = {0, 1, 2};
  int[] rhythmStates = {1, 2, 3, 4, 6, 8, 12, 16};
  int[] legatoStates = {0, 1};
  
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
                             
  double[][][] secondOrderProbabilitiesLerpTarget = {
                                            {//A  B  C  D  E  F  G  cur  last
                                              {1, 1, 1, 0, 1, 0, 0}, //A <- A
                                              {1, 0, 1, 0, 1, 0, 0}, //A <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //A <- C
                                              {4, 0, 0, 2, 0, 1, 0}, //A <- D
                                              {4, 0, 0, 0, 0, 1, 0}, //A <- E
                                              {1, 0, 0, 0, 1, 0, 0}, //A <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //A <- G
                                            }, {
                                              {1, 1, 2, 0, 0, 1, 0}, //B <- A
                                              {0, 0, 1, 0, 0, 0, 0}, //B <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- C
                                              {0, 0, 1, 2, 0, 1, 0}, //B <- D
                                              {0, 0, 0, 0, 0, 1, 2}, //B <- E
                                              {1, 0, 0, 1, 0, 1, 0}, //B <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //B <- G
                                            }, {  
                                              {1, 0, 0, 2, 0, 0, 0}, //C <- A  
                                              {1, 0, 1, 2, 0, 0, 0}, //C <- B
                                              {1, 0, 1, 0, 0, 0, 0}, //C <- C
                                              {2, 1, 0, 0, 1, 0, 0}, //C <- D
                                              {1, 0, 0, 0, 0, 0, 0}, //C <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //C <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //C <- G
                                            }, {
                                              {1, 0, 0, 0, 0, 1, 0}, //D <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //D <- B
                                              {0, 0, 1, 1, 3, 0, 0}, //D <- C
                                              {2, 0, 2, 1, 0, 1, 0}, //D <- D
                                              {0, 0, 1, 0, 1, 0, 0}, //D <- E
                                              {1, 1, 0, 1, 0, 1, 0}, //D <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //D <- G
                                            }, {
                                              {1, 0, 0, 0, 1, 1, 0}, //E <- A
                                              {1, 1, 0, 0, 1, 0, 1}, //E <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //E <- C
                                              {0, 0, 0, 2, 0, 1, 0}, //E <- D
                                              {2, 0, 0, 2, 0, 1, 0}, //E <- E
                                              {2, 0, 1, 0, 0, 4, 0}, //E <- F
                                              {1, 0, 0, 0, 0, 1, 1}  //E <- G
                                            }, {
                                              {0, 0, 0, 0, 1, 0, 0}, //F <- A
                                              {0, 0, 0, 0, 1, 0, 0}, //F <- B
                                              {0, 0, 1, 0, 0, 0, 0}, //F <- C
                                              {1, 0, 0, 1, 0, 0, 0}, //F <- D
                                              {0, 0, 0, 0, 1, 1, 1}, //F <- E
                                              {0, 0, 0, 1, 1, 0, 0}, //F <- F
                                              {0, 0, 0, 0, 2, 0, 1}  //F <- G
                                            }, {
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- C
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- D
                                              {0, 0, 0, 0, 1, 1, 0}, //G <- E
                                              {0, 0, 0, 0, 1, 1, 0}, //G <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //G <- G
                                            }
                                          };

  double[][][] secondOrderProbabilities = {
                                            {//A  B  C  D  E  F  G  cur  last
                                              {2, 0, 2, 0, 1, 0, 0}, //A <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //A <- B
                                              {2, 0, 1, 0, 1, 0, 0}, //A <- C
                                              {1, 0, 0, 0, 0, 0, 0}, //A <- D
                                              {2, 0, 1, 0, 1, 0, 0}, //A <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //A <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //A <- G
                                            }, {
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- C
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- D
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //B <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //B <- G
                                            }, {  
                                              {1, 0, 2, 1, 2, 0, 0}, //C <- A  
                                              {1, 0, 0, 0, 0, 0, 0}, //C <- B
                                              {1, 0, 1, 0, 2, 0, 0}, //C <- C
                                              {1, 0, 0, 1, 0, 0, 0}, //C <- D
                                              {1, 0, 2, 0, 2, 0, 0}, //C <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //C <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //C <- G
                                            }, {
                                              {1, 0, 1, 0, 1, 0, 1}, //D <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //D <- B
                                              {1, 0, 0, 0, 1, 0, 1}, //D <- C
                                              {1, 0, 1, 0, 2, 0, 1}, //D <- D
                                              {1, 0, 1, 0, 1, 0, 1}, //D <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //D <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //D <- G
                                            }, {
                                              {1, 0, 1, 0, 1, 0, 0}, //E <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //E <- B
                                              {1, 0, 3, 1, 3, 0, 0}, //E <- C
                                              {1, 0, 2, 0, 0, 0, 1}, //E <- D
                                              {1, 0, 2, 0, 1, 0, 1}, //E <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //E <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //E <- G
                                            }, {
                                              {1, 0, 0, 0, 0, 0, 0}, //F <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //F <- B
                                              {1, 0, 0, 0, 0, 0, 0}, //F <- C
                                              {1, 0, 0, 1, 0, 0, 1}, //F <- D
                                              {1, 0, 0, 0, 0, 0, 0}, //F <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //F <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //F <- G
                                            }, {
                                              {0, 0, 0, 0, 1, 0, 0}, //G <- A
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- B
                                              {0, 0, 0, 0, 1, 0, 0}, //G <- C
                                              {0, 0, 0, 1, 1, 0, 0}, //G <- D
                                              {0, 0, 0, 1, 0, 0, 1}, //G <- E
                                              {1, 0, 0, 0, 0, 0, 0}, //G <- F
                                              {1, 0, 0, 0, 0, 0, 0}  //G <- G
                                            }
                                          };
  
  //TODO remove 8.!
  double[][][] secondOrderValueProbabilitiesLerpTarget = {
                                                 {//16 8  8. 4  4. 2  2. 1     cur  last
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //16 - 16
                                                   {1, 0, 0, 0, 0, 0, 0, 0}, //16 - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 2
                                                   {1, 0, 1, 0, 0, 0, 0, 0}, //16 - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //16 - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 16
                                                   {1, 6, 0, 2, 0, 1, 0, 1}, //8  - 8
                                                   {0, 0, 1, 3, 0, 0, 1, 0}, //8  - 8.
                                                   {1, 3, 0, 0, 0, 0, 0, 0}, //8  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 4.
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //8  - 2
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //8  - 2.
                                                   {0, 1, 0, 0, 0, 0, 0, 0}  //8  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 16
                                                   {0, 0, 1, 0, 0, 0, 0, 0}, //8. - 8
                                                   {1, 1, 0, 1, 0, 0, 0, 0}, //8. - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //8. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 16
                                                   {0, 2, 0, 8, 1, 0, 1, 1}, //4  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 8.
                                                   {0, 3, 0, 3, 1, 1, 1, 1}, //4  - 4
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
                                                   {1, 0, 0, 1, 0, 0, 0, 0}, //2. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 2
                                                   {0, 1, 0, 2, 1, 0, 0, 0}, //2. - 2.
                                                   {1, 0, 0, 1, 0, 0, 0, 0}  //2. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8.
                                                   {0, 1, 0, 3, 0, 0, 1, 0}, //1  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //1  - 1
                                                 }
                                               };
                                               
   double[][][] secondOrderValueProbabilities = {
                                                 {//16 8  8. 4  4. 2  2. 1     cur  last
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //16 - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //16 - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 16
                                                   {0, 1, 0, 1, 0, 0, 0, 0}, //8  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 8.
                                                   {0, 1, 0, 1, 0, 0, 0, 0}, //8  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8  - 4.
                                                   {0, 1, 0, 0, 0, 0, 0, 0}, //8  - 2
                                                   {0, 1, 0, 1, 0, 0, 0, 0}, //8  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //8  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //8. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //8. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 16
                                                   {0, 0, 0, 1, 0, 0, 1, 0}, //4  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 8.
                                                   {0, 1, 0, 4, 1, 1, 0, 0}, //4  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //4  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 8.
                                                   {0, 0, 0, 1, 1, 0, 0, 0}, //4. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //4. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //4. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 8.
                                                   {0, 1, 0, 1, 0, 0, 0, 0}, //2  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //2  - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //2. - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //2. - 1
                                                 }, {
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 16
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 8.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 4
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 4.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2
                                                   {0, 0, 0, 1, 0, 0, 0, 0}, //1  - 2.
                                                   {0, 0, 0, 1, 0, 0, 0, 0}  //1  - 1
                                                 }
                                               };
                                               
  double[][][] mutingProbabilities = {
                                       {//0  1  2   cur   last
                                         {8, 1, 0}, //0 - 0
                                         {2, 1, 0}, //0 - 1
                                         {1, 0, 0}  //0 - 2
                                       }, {
                                         {3, 1, 0}, //1 - 0
                                         {1, 7, 0}, //1 - 1
                                         {1, 0, 0}  //1 - 2
                                       }, {
                                         {1, 0, 0}, //2 - 0
                                         {1, 0, 0}, //2 - 1
                                         {1, 0, 0}  //2 - 2
                                       }
                                     };
                                     
  double[][][] mutingProbabilitiesLerpTarget = {
                                       {//0  1  2   cur   last
                                         {0, 0, 1}, //0 - 0
                                         {0, 0, 1}, //0 - 1
                                         {0, 0, 1}  //0 - 2
                                       }, {
                                         {0, 0, 1}, //1 - 0
                                         {0, 0, 1}, //1 - 1
                                         {0, 0, 1}  //1 - 2
                                       }, {
                                         {0, 0, 1}, //2 - 0
                                         {0, 0, 1}, //2 - 1
                                         {0, 1, 7}  //2 - 2
                                       }
                                     };
                                     
  double[][][] legatoProbabilities = {
                                       {
                                         {1, 1},
                                         {1, 0}
                                       }, {
                                         {1, 0},
                                         {1, 0}
                                       }
                                     };
                                                
  
  EnumeratedIntegerDistribution[]   firstOrderDistributions; 
  EnumeratedIntegerDistribution[][] secondOrderDistributions;
  EnumeratedIntegerDistribution[][] rhythmDistributions;
  EnumeratedIntegerDistribution[][] mutingDistributions;
  EnumeratedIntegerDistribution[][] legatoDistributions;
  
  Markov() {
    initFirstOrderDistributions();
    initSecondOrderDistributions();
    initRhythmDistributions();
    initMutingDistributions();
    initLegatoDistributions();
  }
  
  void initFirstOrderDistributions() {
    firstOrderDistributions = new EnumeratedIntegerDistribution[12];
    for(int i = 0; i < firstOrderDistributions.length; i++) {
      firstOrderDistributions[i] = new EnumeratedIntegerDistribution(states, firstOrderProbabilities[i]);
    }
  }
  
  void initSecondOrderDistributions() {
    secondOrderDistributions = new EnumeratedIntegerDistribution[7][7];
    for(int i = 0; i < 7; i++) {
      for(int j = 0; j < 7; j++) {
        secondOrderDistributions[i][j] = new EnumeratedIntegerDistribution(secOrdStates, secondOrderProbabilities[i][j]);
      }
    }
  }
  
  //TODO variable naming! rhythm vs value etc
  void initRhythmDistributions() {
    rhythmDistributions = new EnumeratedIntegerDistribution[8][8];
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        rhythmDistributions[i][j] = new EnumeratedIntegerDistribution(rhythmStates, secondOrderValueProbabilities[i][j]);
      }
    }
  }
  
  void initMutingDistributions() {
    mutingDistributions = new EnumeratedIntegerDistribution[3][3];
    for(int i = 0; i < 3; i++) {
      for(int j = 0; j < 3; j++) {
        mutingDistributions[i][j] = new EnumeratedIntegerDistribution(mutingStates, mutingProbabilities[i][j]);
      }
    }
  }

  void initLegatoDistributions() {
    legatoDistributions = new EnumeratedIntegerDistribution[2][2];
    for(int i = 0; i < 2; i++) {
      for(int j = 0; j < 2; j++) {
        legatoDistributions[i][j] = new EnumeratedIntegerDistribution(legatoStates, legatoProbabilities[i][j]);
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
    return s;
  }
  
  //TODO ughh
  private int getNextSecondOrderNote() {
    int i = 0;
    switch(previousState) {
      case 0:  i = 0; break;
      case 2:  i = 1; break;
      case 3:  i = 2; break;
      case 5:  i = 3; break;
      case 7:  i = 4; break;
      case 8:  i = 5; break;
      case 10: i = 6; break;
    }
    int j = 0;
    switch(state) {
      case 0:  j = 0; break;
      case 2:  j = 1; break;
      case 3:  j = 2; break;
      case 5:  j = 3; break;
      case 7:  j = 4; break;
      case 8:  j = 5; break;
      case 10: j = 6; break;
    }
    previousState = state;
    int s = secondOrderDistributions[j][i].sample();
    state = s;
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
    return s;
  }
  
  int getNextMute() {
    int m = mutingDistributions[muting][previousMuting].sample();
    previousMuting = muting;
    muting = m;
    return m;
  }
  
  // TODO fix this
  int getNextLegato() {
    int l = legatoDistributions[legato][previousLegato].sample();
    previousLegato = legato;
    legato = l;
    return l;

  }
  
  void lerpAllMatrices(float f) {
    // lerp muting
    mutingDistributions = new EnumeratedIntegerDistribution[3][3];
    for(int i = 0; i < 3; i++) { // TODO yeah i know these should be dynamic
      for(int j = 0; j < 3; j++) { // well sue me
        double[] lerpedRow = lerpRow(mutingProbabilities[i][j], mutingProbabilitiesLerpTarget[i][j], f);
        mutingDistributions[i][j] = new EnumeratedIntegerDistribution(mutingStates, lerpedRow);
      }
    }
    
    // lerp notes
    secondOrderDistributions = new EnumeratedIntegerDistribution[7][7];
    for(int i = 0; i < 7; i++) {
      for(int j = 0; j < 7; j++) {
        double[] lerpedRow = lerpRow(secondOrderProbabilities[i][j], secondOrderProbabilitiesLerpTarget[i][j], f);
        secondOrderDistributions[i][j] = new EnumeratedIntegerDistribution(secOrdStates, lerpedRow);
      }
    }

    // lerp values
    rhythmDistributions = new EnumeratedIntegerDistribution[8][8];
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        double[] lerpedRow = lerpRow(secondOrderValueProbabilities[i][j], secondOrderValueProbabilitiesLerpTarget[i][j], f);
        rhythmDistributions[i][j] = new EnumeratedIntegerDistribution(rhythmStates, lerpedRow);
      }
    }
  }
  
  void lerpMatricesA(float f) {
    // lerp notes
    secondOrderDistributions = new EnumeratedIntegerDistribution[7][7];
    for(int i = 0; i < 7; i++) {
      for(int j = 0; j < 7; j++) {
        double[] lerpedRow = lerpRow(secondOrderProbabilities[i][j], secondOrderProbabilitiesLerpTarget[i][j], f);
        secondOrderDistributions[i][j] = new EnumeratedIntegerDistribution(secOrdStates, lerpedRow);
      }
    }

    // lerp values
    rhythmDistributions = new EnumeratedIntegerDistribution[8][8];
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        double[] lerpedRow = lerpRow(secondOrderValueProbabilities[i][j], secondOrderValueProbabilitiesLerpTarget[i][j], f);
        rhythmDistributions[i][j] = new EnumeratedIntegerDistribution(rhythmStates, lerpedRow);
      }
    }
  }
  
  void lerpMatricesB(float f) {
    // lerp muting
    mutingDistributions = new EnumeratedIntegerDistribution[3][3];
    for(int i = 0; i < 3; i++) { // TODO yeah i know these should be dynamic
      for(int j = 0; j < 3; j++) { // well sue me
        double[] lerpedRow = lerpRow(mutingProbabilities[i][j], mutingProbabilitiesLerpTarget[i][j], f);
        mutingDistributions[i][j] = new EnumeratedIntegerDistribution(mutingStates, lerpedRow);
      }
    }
  }
    
  double[] lerpRow(double[] initial, double[] target, float lerp) {
    //lerp = lerp/100; // TODO lerp comes in as 0-99 currently
    double[] lerped = new double[initial.length];
    for(int i = 0; i < initial.length; i++) {
      lerped[i] = initial[i] + lerp*(target[i]-initial[i]);
    }
    return lerped;
  }
  
}