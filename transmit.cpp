#include "transmit.hpp"
#include "fcs.hpp"
#include "ap_utils.h"

#define RELEASE

#define PREAMBLE_CNT  7
#define PREAMBLE_CHAR 0x55
#define SFD_CHAR      0xd5

typedef struct {
    int a;
    int b;
}dout_t;

#define gmii_out(d, en, err) m_gmii.write((t_m_gmii){d, en, err})

#define fcs_covered_append(d, err)		\
    do {					\
	frm_err |= err;				\
	frm_cnt++;				\
	crc32(d, &crc_state);			\
	gmii_out(d, 1, err);	\
    } while(0)

#define fcs_uncovered_append(d) gmii_out(d, 1, 0)

void transmit(
    hls::stream<t_axis> &s_axis,
	hls::stream<t_m_gmii> &m_gmii,
    t_tx_status* tx_status
    )
{

#ifdef RELEASE
    #pragma HLS interface ap_ctrl_none port=return
    #pragma HLS data_pack variable=m_gmii
#endif

#pragma HLS INTERFACE axis port=s_axis
#pragma HLS data_pack variable=tx_status
#pragma HLS INTERFACE ap_ovld port=tx_status

	#pragma HLS LATENCY max=0 min=0

    int i;
    int frm_cnt;
    int frm_err;
    t_axis din;
    int start;

    while (!s_axis.read_nb(din)) {
    	gmii_out(0x07, 0, 0);
    }

     PREAMBLE: for (i = 0; i < PREAMBLE_CNT; i++) {
	  #pragma HLS UNROLL
	  #pragma HLS LATENCY max=0 min=0
	    fcs_uncovered_append(PREAMBLE_CHAR);
	}
    ap_uint<32> crc_state = 0xffffffff;

    frm_cnt = 0;
    frm_err = 0;
	fcs_uncovered_append(SFD_CHAR);
       

	//fcs_covered_append(din.data, din.user);

      DATA: while(!s_axis.empty()){
#pragma HLS LATENCY max=0 min=0
	    ap_uint<8> data;

	    fcs_covered_append(din.data, din.user);
	    s_axis.read_nb(din);
	}

    fcs_covered_append(din.data, din.user);

    PAD: while (frm_cnt < 60) {
#pragma HLS LATENCY max=0 min=0
    	fcs_covered_append(0x00, 0);
    }

      FCS: for (i = 0; i < 4; i++) {
#pragma HLS UNROLL
//#pragma HLS LATENCY max=0 min=0
	    fcs_uncovered_append((~crc_state) & 0xff);
	    crc_state >>= 8;
	}

	*tx_status = (t_tx_status) {frm_cnt, !frm_err, 0, 0, 0, 0, 0};
	gmii_out(0x07, 0, 0);

}
