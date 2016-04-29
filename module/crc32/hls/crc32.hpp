#ifndef __CRC32_HPP__
#define __CRC32_HPP__

#include "ap_int.h"

template<class T>
void crc32(T din, ap_uint<32> *crc_state){
	unsigned j;
	ap_uint<32> state = *crc_state;

 CRC32_LOOP: for (j = 0; j < din.width; j++) {
#pragma HLS UNROLL
        if (j%8 == 0) // At the beginning of each new byte processed
        	state ^= (ap_uint<8>) (din >> j);

        if (state & 1) {
            state = (state >> 1) ^ 0xEDB88320;
        } else {
            state = state >> 1;
        }
    }
    *crc_state = state;
}

#endif
