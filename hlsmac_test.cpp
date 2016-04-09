#include <stdio.h>

#include "mac.hpp"

int frm1[] = {
		0x00, 0x10, 0xa4, 0x7b, 0xea, 0x80, 0x00, 0x12,
		0x34, 0x56, 0x78, 0x90, 0x08, 0x00, 0x45, 0x00,
		0x00, 0x2e, 0xb3, 0xfe, 0x00, 0x00, 0x80, 0x11,
		0x05, 0x40, 0xc0, 0xa8, 0x00, 0x2c, 0xc0, 0xa8,
		0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1a,
		0x2d, 0xe8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
		0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,
		0x0e, 0x0f, 0x10, 0x11, 0xb3, 0x31, 0x88, 0x1b};
const int FRM1_LEN = sizeof(frm1) / sizeof(int);

int main()
{
  int i;
  hls::stream<t_gmii> A;
  hls::stream<t_axis> B;
  int C[50];

  //Put data into A
  for(i=0; i < FRM1_LEN; i++){
	t_gmii dat;
	dat.rxd = frm1[i];
	dat.dv = 1;
	dat.er = 0;
    A.write(dat);
  }
  t_gmii dat;
  dat.dv = 0;
  A.write(dat);
  A.write(dat);
  A.write(dat);
  A.write(dat);
  A.write(dat);

  //Call the hardware function
  mac(A, B);

  t_axis m_axis;
  while (!B.empty()) {
	  m_axis=B.read();
      printf("Data 0x%d, LAST %d, USER %d\n", m_axis.data.to_int(), m_axis.last.to_int(), m_axis.user.to_int());
 }

  if(!((m_axis.last == 1) && (m_axis.user == 0))){
	printf("FRAME ERROR\n");
	return 1;
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
  printf("Frame correct\n");
  return 0;
}

  

