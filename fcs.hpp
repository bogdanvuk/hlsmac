#ifndef __CRC32_HPP__
#define __CRC32_HPP__

#include "ap_int.h"

void crc32(ap_uint<8> din, ap_uint<32>* crc_state);
#endif
