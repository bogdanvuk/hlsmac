#ifndef __FCS_HPP__
#define __FCS_HPP__

#include "ap_int.h"

//#define FCS_PARALLEL_BYTES 8

template<class T>
void crc32(T din, ap_uint<32> *crc_state){
#pragma HLS LATENCY max=0 min=0

	unsigned i, j;
	ap_uint<32> state = *crc_state;
	ap_uint<8> bytes[din.width];

	for (i = 0; i < din.width/8; i++) {
#pragma HLS UNROLL
		bytes[i] = (ap_uint<8>) (din >> (8*i));
	}

 CRC32_LOOP: for (j = 0; j < din.width; j++) {    // Do eight times for each bit.
#pragma HLS UNROLL
        if (j%8 == 0)
        	state ^= bytes[j/8];

        if (state & 1) {
            state = (state >> 1) ^ 0xEDB88320;
        } else {
            state = state >> 1;
        }
    }
    *crc_state = state;
}

#endif
