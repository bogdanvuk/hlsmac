#include "transmit.hpp"
#include "crc32.hpp"
#include "ap_utils.h"

//#define RELEASE

#define PREAMBLE_CNT  7
#define PREAMBLE_CHAR 0x55
#define SFD_CHAR      0xd5

#define gmii_out(d, en, err) m_gmii.write((t_m_gmii){d, en, err})

#define fcs_cover_gmii_data_out(d, err)         \
    do {                                        \
        frm_err |= err;                         \
        frm_cnt++;                              \
        crc32(d, &crc_state);                   \
        gmii_out(d, 1, err);                    \
    } while(0)

#define gmii_data_out(d) gmii_out(d, 1, 0)

#define idle_out_loop() do {                    \
        gmii_out(0x07, 0, 0);                   \
    } while(!s_axis.read_nb(din))               \

void transmit(
    hls::stream<t_axis> &s_axis,
    hls::stream<t_m_gmii> &m_gmii,
    hls::stream<t_tx_status> &tx_status
    )
{

#ifdef RELEASE
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS data_pack variable=m_gmii
#endif

#pragma HLS INTERFACE axis port=s_axis
#pragma HLS data_pack variable=tx_status
//#pragma HLS INTERFACE ap_ovld port=tx_status

    int i;
    int frm_cnt;
    int frm_err;
    t_axis din;
    int start;

#ifdef RELEASE
IDLE_ONCE:  idle_out_loop();
#else
    gmii_out(0x07, 0, 0);
    if (!s_axis.read_nb(din)) return;
#endif

MAIN: while (1) {
#pragma HLS PIPELINE rewind
    PREAMBLE: for (i = 0; i < PREAMBLE_CNT; i++) {
#pragma HLS UNROLL
#pragma HLS LATENCY max=0 min=0
            gmii_data_out(PREAMBLE_CHAR);
        }
        ap_uint<32> crc_state = 0xffffffff;

        frm_cnt = 0;
        frm_err = 0;
        gmii_data_out(SFD_CHAR);

    DATA: while(!din.last){
#pragma HLS LATENCY max=0 min=0
            fcs_cover_gmii_data_out(din.data, din.user);
            if (!s_axis.read_nb(din)) return;
        }

        fcs_cover_gmii_data_out(din.data, din.user);

    PAD: while (frm_cnt < 60) {
#pragma HLS LATENCY max=0 min=0
            fcs_cover_gmii_data_out((ap_uint<8>) 0x00, 0);
        }

    FCS: for (i = 0; i < 4; i++) {
#pragma HLS UNROLL
            gmii_data_out((~crc_state) & 0xff);
            frm_cnt++;
            crc_state >>= 8;
        }

        tx_status.write_nb((t_tx_status) {frm_cnt, !frm_err, 0, 0, 0, 0, 0});
#ifdef RELEASE
    IDLE: idle_out_loop();
#else
        gmii_out(0x07, 0, 0);
        if (!s_axis.read_nb(din)) return;
#endif

    }

}
