#ifndef __TRANSMIT_HPP__
#define __TRANSMIT_HPP__

#include <stdio.h>

#include "ap_int.h"
#include <hls_stream.h>
#include <stdio.h>

typedef struct{
    ap_uint<8>      txd;
    ap_uint<1>      en;
    ap_uint<1>      er;
}t_m_gmii;

typedef struct{
	ap_uint<8> data;
	ap_uint<1> user;
	ap_uint<1> last;
}t_axis;

typedef struct {
	ap_uint<14>     count;
	ap_uint<1>      good;
	ap_uint<1>      broad;
	ap_uint<1>      multi;
	ap_uint<1>      under;
	ap_uint<1>      len_err;
	ap_uint<1>      fcs_err;
	ap_uint<1>      data_err;
	ap_uint<1>      ext_err;
	ap_uint<1>      over;
}t_tx_status;

//void transmit( hls::stream<t_axis> &s_axis, hls::stream<t_m_gmii> &m_gmii, hls::stream<t_tx_status> &tx_status);
void transmit( hls::stream<t_axis> &s_axis, volatile t_m_gmii *m_gmii, hls::stream<t_tx_status> &tx_status);


#endif
