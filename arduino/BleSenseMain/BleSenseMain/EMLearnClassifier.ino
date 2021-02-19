/**
 * simple classifiers ported by emlearn
 */

#include "sonar.h"
 
//the maximum expected pressure value
//needed for mean centering certain datasets
int maxpressure = 3000;

//the maximum expected rms value
//needed for mean centering certain datasets
int maxrms = 50000;

//classify using a simple tree, pass in the pressure list and proximity list data
//note that there is no need for mean centering in this case
int32_t classifySimpleTree(float* pressureList, float* audioList){
  //an array to hold the data
  float data[400];

  //add the 300 pressure values to the list
  for(int i = 0; i < 200; i++){
    data[i] = pressureList[i];
  }
  
  //add the 300 audio values to the list
  for(int i = 0; i < 200; i++){
    data[i + 200] = audioList[i];
  }

  //make a prediction and return
  int32_t predicted_class = sonar_predict(data, 400);
  return predicted_class;
 }
