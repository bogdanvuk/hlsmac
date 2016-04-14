#include "fcs.hpp"

void crc32(ap_uint<8> din, ap_uint<32>* crc_state){
	unsigned j;

	*crc_state ^= din;
	CRC32_LOOP: for (j = 8; j > 0; j--) {    // Do eight times.
	#pragma HLS UNROLL
       ap_uint<32> mask = -(*crc_state & 1);
       *crc_state = (*crc_state >> 1) ^ (0xEDB88320 & mask);
    }
}
