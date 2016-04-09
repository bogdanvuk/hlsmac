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

void mac( hls::stream<t_gmii> &gmii, hls::stream<t_axis> &m_axis );

#endif
