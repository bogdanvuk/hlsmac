#ifndef __AXI_LITE_HPP__
#define __AXI_LITE_HPP__

#include "ap_int.h"
#include <hls_stream.h>
#include "transmit.hpp"

void axi_lite(
              hls::stream<t_tx_status> &tx_status,
	      ap_uint<64> *tx_64,
	      ap_uint<64> *tx_65_127,
	      ap_uint<64> *tx_128_255,
	      ap_uint<64> *tx_256_511,
	      ap_uint<64> *tx_512_1023,
	      ap_uint<64> *tx_1024_max
             );

#endif
