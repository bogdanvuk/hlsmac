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

#define fcs_covered_append(d)                   \
    do {                                        \
		frm_cnt++;                              \
        crc32(d, &crc_state);                   \
        m_gmii.write_nb((t_m_gmii){d, 1, 0});   \
    } while(0)

#define fcs_uncovered_append(d) m_gmii.write_nb((t_m_gmii){d, 1, 0})

void transmit(
              hls::stream<t_axis> &s_axis,
              hls::stream<t_m_gmii> &m_gmii,
              hls::stream<t_tx_status> &tx_status
              )
{
    //#pragma HLS INTERFACE ap_hs port=m_gmii
#pragma HLS data_pack variable=tx_status
#pragma HLS INTERFACE axis port=s_axis

	t_axis din;
    int i;
    if(!s_axis.empty()) {
    	int frm_cnt = 0;
        din = s_axis.read();
    PREAMBLE: for (i = 0; i < PREAMBLE_CNT; i++) {
            fcs_uncovered_append(PREAMBLE_CHAR);
        }
        fcs_uncovered_append(SFD_CHAR);
       
        crc_state = 0xffffffff;
        fcs_covered_append(din.data);
//    DATA: while(!s_axis.empty()) {
//            din = s_axis.read();
//            fcs_covered_append(din.data);
//#ifndef __SYNTHESIS__
//            printf("din 0x%x, crc: 0x%x\n", din.data.to_int(), (~crc_state));
//#endif
//
//        } ;
//
//    PADDING: while (frm_cnt < 60) {
//            fcs_covered_append(0x00);
//        }

    DATA: while((!s_axis.empty()) || (frm_cnt < 60) ) {
            if (s_axis.read_nb(din)) {
            	fcs_covered_append(din.data);
            } else {
            	fcs_covered_append(0x00);
            }
        }

    	ap_uint<32> fcs = ~crc_state;
    	fcs_uncovered_append(fcs & 0xff);
    	fcs_uncovered_append(fcs & 0xff);
    	fcs_uncovered_append(fcs & 0xff);
    	fcs_uncovered_append(fcs & 0xff);
///
//    	FCS: for (i = 0; i < 4; i++) {
//#pragma HLS UNROLL
//    		fcs_uncovered_append(fcs & 0xff);
//    		fcs >>= 8;
//    	}
    }

    m_gmii.write((t_m_gmii){0x07, 0, 0});

}
