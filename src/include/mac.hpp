#ifndef __MAC_HPP__
#define __MAC_HPP__

#include "ap_int.h"
#include <hls_stream.h>

typedef struct{
    ap_uint<8>      rxd;
    ap_uint<1>      dv;
    ap_uint<1>      er;
}t_gmii;

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
}t_rx_status;

typedef struct {
	ap_uint<32>      good_frames;
}t_rx_statistic_counters;

extern t_rx_statistic_counters rx_statistic_counters;

void mac(t_gmii gmii, hls::stream<t_axis> &m_axis, hls::stream<t_rx_status> &rx_status, int* test);

#endif
