#include "axi_lite.hpp"

ap_uint<64> tx_64 = 0;
ap_uint<64> tx_65_127 = 0;
ap_uint<64> tx_128_255 = 0;
ap_uint<64> tx_256_511 = 0;
ap_uint<64> tx_512_1023 = 0;
ap_uint<64> tx_1024_max = 0;

ap_uint<32> dummy_last = 0;

void axi_lite(
              hls::stream<t_tx_status> &tx_status
             )
{
#pragma HLS INTERFACE ap_fifo port=tx_status
#pragma HLS data_pack variable=tx_status

#pragma HLS INTERFACE s_axilite port=return bundle=axi_lite_bus
#pragma HLS INTERFACE s_axilite port=tx_64 bundle=axi_lite_bus offset=0x258
#pragma HLS INTERFACE s_axilite port=tx_65_127 bundle=axi_lite_bus offset=0x260
#pragma HLS INTERFACE s_axilite port=tx_128_255 bundle=axi_lite_bus offset=0x268
#pragma HLS INTERFACE s_axilite port=tx_256_511 bundle=axi_lite_bus offset=0x270
#pragma HLS INTERFACE s_axilite port=tx_512_1023 bundle=axi_lite_bus offset=0x278
#pragma HLS INTERFACE s_axilite port=tx_1024_max bundle=axi_lite_bus  offset=0x280
#pragma HLS INTERFACE s_axilite port=dummy_last bundle=axi_lite_bus offset=0x754

MAIN: while (1) {
//#pragma HLS PIPELINE rewind
  t_tx_status tx_din;
  if (tx_status.read_nb(tx_din)) {
    if (tx_din.count == 64) {
      tx_64++;
    } else if (tx_din.count < 128) {
      tx_65_127++;
    } else if (tx_din.count < 256) {
      tx_128_255++;
    } else if (tx_din.count < 512) {
      tx_256_511++;
    } else if (tx_din.count < 1024) {
      tx_512_1023++;
    } else {
      tx_1024_max++;
    }
    dummy_last++;
  } else {
	return;
  }
}
}

