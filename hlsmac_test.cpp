#include <stdio.h>

#include "mac.hpp"

int frm1[] = {
		0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xd5,
		0x00, 0x10, 0xa4, 0x7b, 0xea, 0x80, 0x00, 0x12,
		0x34, 0x56, 0x78, 0x90, 0x08, 0x00, 0x45, 0x00,
		0x00, 0x2e, 0xb3, 0xfe, 0x00, 0x00, 0x80, 0x11,
		0x05, 0x40, 0xc0, 0xa8, 0x00, 0x2c, 0xc0, 0xa8,
		0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1a,
		0x2d, 0xe8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
		0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,
		0x0e, 0x0f, 0x10, 0x11, 0xb3, 0x31, 0x88, 0x1b};
const int FRM1_LEN = sizeof(frm1) / sizeof(int);

#define FRAMES_CNT 3


int main()
{
  int i;
  int j;
  hls::stream<t_axis> B;
  int correct_frames = 0;

  // Place some idles at the beginning
  for (j = 0; j < 5; j++) {
	  mac((t_gmii) {0, 0, 0}, B);
  }

  for (j = 0; j < FRAMES_CNT; j++) {
	  //Put data into A
	  for(i=0; i < FRM1_LEN; i++){
		  mac((t_gmii) {frm1[i], 1, 0}, B);
	  }
	  mac((t_gmii) {0, 0, 0}, B);
  }

  // Place some idles at the end
  for (j = 0; j < 5; j++) {
	  mac((t_gmii) {0, 0, 0}, B);
  }


  //Call the hardware function
//  mac(A, B);

  t_axis m_axis;
  while (!B.empty()) {
	  m_axis=B.read();
      printf("Data 0x%x, LAST %d, USER %d\n", m_axis.data.to_int(), m_axis.last.to_int(), m_axis.user.to_int());
      if (m_axis.last) {
    	  if(!m_axis.user){
    		  correct_frames++;
    	  }
      }
 }

  if (correct_frames < FRAMES_CNT) {
	  printf("*****************************************************************\n");
	  printf("FRAME ERROR %d/%d\n", FRAMES_CNT-correct_frames, FRAMES_CNT);
	  printf("*****************************************************************\n");
	  return 1;
  } else {
	  printf("*****************************************************************\n");
	  printf("Frame correct %d/%d\n", FRAMES_CNT,FRAMES_CNT);
	  printf("*****************************************************************\n");
	  return 0;
  }

//  //Run a software version of the hardware function to validate results
//  for(i=0; i < 50; i++){
//    C[i] = A[i].data.to_int() + 5;
//  }
//
//  //Compare results
//  for(i=0; i < 50; i++){
//    if(B[i].data.to_int() != C[i]){
//      printf("ERROR HW and SW results mismatch\n");
//      return 1;
//    }
//  }


}

  

