#include "transmit.hpp"
#include "fcs.hpp"
#include "ap_utils.h"


#define PREAMBLE_CNT  7
#define PREAMBLE_CHAR 0x55
#define SFD_CHAR      0xd5

ap_uint<32> crc_state = 0xffffffff;

typedef struct {
	int a;
	int b;
}dout_t;

void transmit(
	      hls::stream<t_axis> &s_axis,
	      //hls::stream<t_m_gmii> &m_gmii,
		  volatile t_m_gmii *m_gmii,
	      hls::stream<t_tx_status> &tx_status
	      )
{
	#pragma HLS INTERFACE ap_none port=m_gmii
	#pragma HLS data_pack variable=tx_status
	#pragma HLS INTERFACE axis port=s_axis


//
  int i;
//  dout_t acc_out;
//  //t_m_gmii bla = (t_m_gmii){PREAMBLE_CHAR, 1, 0};
//
  if(!s_axis.empty()) {
	  volatile t_m_gmii proba((t_m_gmii){PREAMBLE_CHAR, 1, 0});
	  *m_gmii = proba;

//    //t_axis first = s_axis.read();
//    for (i = 0; i < PREAMBLE_CNT; i++) {
////      //m_gmii.write((t_m_gmii){PREAMBLE_CHAR, 1, 0});
////    	acc_out = (dout_t){1, 1};
//      (*(m_gmii+i)).txd = PREAMBLE_CHAR;
//      (*(m_gmii+i)).en = 1;
//      (*(m_gmii+i)).er = 0;
//    }
//    //m_gmii.write((t_m_gmii){SFD_CHAR, 1, 0});
//    acc_out = (dout_t){1, 1};
//    *m_gmii = acc_out; //(t_m_gmii){SFD_CHAR, 1, 0};
//
//    crc_state = 0xffffffff;
//
//    while(!s_axis.empty()) {
//      t_axis din = s_axis.read();
//      crc32(din.data, &crc_state);
//#ifndef __SYNTHESIS__
//      printf("din 0x%x, crc: 0x%x\n", din.data.to_int(), (~crc_state));
//#endif
//      *m_gmii = 1; // (t_m_gmii){din.data, 1, 0};
////      m_gmii.write((t_m_gmii){din.data, 1, 0});
//    }
//    ap_uint<32> crc = ~crc_state;
////    m_gmii.write((t_m_gmii){crc & 0xff, 1, 0});
////    m_gmii.write((t_m_gmii){(crc >> 8) & 0xff, 1, 0});
////    m_gmii.write((t_m_gmii){(crc >> 16) & 0xff, 1, 0});
////    m_gmii.write((t_m_gmii){(crc >> 24) & 0xff, 1, 0});
//
//
  }
//
//  m_gmii.write((t_m_gmii){0x07, 0, 0});

}
