#include "transmit.hpp"
#include "fcs.hpp"
#include "ap_utils.h"

#define PREAMBLE_CNT  7
#define PREAMBLE_CHAR 0x55
#define SFD_CHAR      0xd5

typedef struct {
    int a;
    int b;
}dout_t;

#define fcs_covered_append(d, err)		\
    do {					\
	frm_err |= err;				\
	frm_cnt++;				\
	crc32(d, &crc_state);			\
	m_gmii.write_nb((t_m_gmii){d, 1, err});	\
    } while(0)

#define fcs_uncovered_append(d) m_gmii.write_nb((t_m_gmii){d, 1, 0})

void transmit(
    hls::stream<t_axis> &s_axis,
    hls::stream<t_m_gmii> &m_gmii,
    t_tx_status* tx_status
    )
{

#pragma HLS interface ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=s_axis
#pragma HLS data_pack variable=m_gmii
#pragma HLS data_pack variable=tx_status
#pragma HLS INTERFACE ap_ovld port=tx_status

    int i;
    int frm_cnt;
    int frm_err;
    if(!s_axis.empty()) {
	t_axis din = s_axis.read();

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
}

m_gmii.write((t_m_gmii){0x07, 0, 0});

}
