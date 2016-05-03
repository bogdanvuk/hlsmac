#include "transmit.hpp"
#include "crc32.hpp"
#include "ap_utils.h"

//#define RELEASE

#define PREAMBLE_CNT  7
#define PREAMBLE_CHAR 0x55
#define SFD_CHAR      0xd5
#define IDLE_CHAR     0x07
#define IDLE_WORD     0x0707070707070707
#define START_WORD    0xd5555555555555fb
#define EOF           0xfd
#define LANES_NUM     8
#define FCS_BYTES     4

#define replace_byte(w, b, pos) ((w) & (~(0xffL << (pos)*8))) | ((((ap_uint<64>) b) & 0xff) << (pos)*8)
#define mask_up_to_bit(w, pos) (((ap_uint<w>) -1) >> ((w) - (pos) - 1))
//#define copy_word_part(src, spos, dest, dmask, dpos)        \
//    ((src) & (~(((dmask) >> (dpos)) << (spos)))) |          \
//    (((((ap_uint<64>) dest) & dmask) >> (dpos)) << (spos))

template<class S, class D>
S copy_word_part(S src, int spos, D dest, D dmask, int dpos) {
#pragma HLS LATENCY max=0 min=0
#pragma HLS INLINE
	S src_masked = src & (~((S) dmask >> dpos << spos));
	S part = ((S) (dest & dmask) >> dpos) << spos;
	return src_masked | part;
}

template<class T>
void pad_with_idles(T &data, int start_lane) {
	data = copy_word_part(data, 8*start_lane, (T) IDLE_WORD, ((T) -1), 0);
}

template<int fcs_start_lane>
void fcs_out(
		ap_uint<64> &txd, ap_uint<8> &txc,
		ap_uint<64> &next_txd, ap_uint<8> &next_txc,
		ap_uint<32> crc_state) {
//    int fcs_bytes_remain = (fcs_start_lane <= 4 ? 0 : 8 - fcs_start_lane);
	ap_uint<4> fcs_end_lane = fcs_start_lane + FCS_BYTES - 1;

    crc32((ap_uint<8*fcs_start_lane>) txd, &crc_state);
    crc_state = ~crc_state;
    txd = copy_word_part(txd, 8*fcs_start_lane, crc_state, (ap_uint<32>) 0xffffffff, 0);
    next_txd = IDLE_WORD;
    next_txc = 0xff;
    if (fcs_end_lane < LANES_NUM - 1) {
        txd = replace_byte(txd, EOF, fcs_end_lane + 1);
        if (fcs_end_lane < LANES_NUM - 2) {
            pad_with_idles(txd, fcs_end_lane + 2);
        }
        txc = ~mask_up_to_bit(8, fcs_end_lane);
    } else {
        txc = 0x00;
        if (fcs_end_lane >= LANES_NUM) {
        	next_txd = copy_word_part(next_txd, 0, crc_state >> 8*(LANES_NUM - fcs_start_lane), (ap_uint<32>) 0xffffffff >> 8*(LANES_NUM - fcs_start_lane), 0);
        }
        next_txd = replace_byte(next_txd, EOF, fcs_end_lane + 1 - LANES_NUM);
        next_txc = ~mask_up_to_bit(8, fcs_end_lane - LANES_NUM);
    }

    //

    // next_data = IDLE_WORD;

    // if (fcs_start_lane < 4) {

    // }
    // *fcs_bytes_remain = ;
}

#define wbit(w, pos) (((w) >> (pos)) & 0x1)
#define wbyte(w, pos) (((w) >> (8*(pos))) & 0xff)

#define xgmii_out(d, c) m_xgmii.write((t_m_xgmii){d, c})

#define fcs_cover_xgmii_data_out(d, err)        \
    do {                                        \
        frm_err |= err;                         \
        frm_cnt++;                              \
        crc32(d, &crc_state);                   \
        xgmii_out(d, 0x00);                     \
    } while(0)

//#define xgmii_data_out(d) xgmii_out(d, 1, 0)

t_axis idle_out_loop(hls::stream<t_axis> &s_axis, hls::stream<t_m_xgmii> &m_xgmii)
{
	t_axis din;
    do {
        xgmii_out(IDLE_WORD, 0xff);
    } while(!s_axis.read_nb(din));

    return din;
}

void transmit(
    hls::stream<t_axis> &s_axis,
    hls::stream<t_m_xgmii> &m_xgmii,
    hls::stream<t_tx_status> &tx_status
    )
{

#ifdef RELEASE
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS data_pack variable=m_gmii
#endif

#pragma HLS INTERFACE axis port=s_axis
#pragma HLS data_pack variable=tx_status

    int i;
    int frm_cnt;
    int frm_err;
    t_axis din;
    int start;

#ifdef RELEASE
    din = idle_out_loop(s_axis, m_xgmii);
#else
    xgmii_out(IDLE_WORD, 0xff);
    if (!s_axis.read_nb(din)) return;
#endif

MAIN: while (1) {
        xgmii_out(START_WORD, 0x01);
        ap_uint<32> crc_state = 0xffffffff;
        ap_uint<64> last_txd; // = din.data;
        ap_uint<8>  last_txc; // = ~din.keep;
        ap_uint<64> next_txd;
        ap_uint<8> next_txc;
        int user_data_end = 0;

        frm_cnt = 0;
        frm_err = 0;
    DATA: while(frm_cnt < 7){

    		if (!user_data_end) {
    			fcs_cover_xgmii_data_out(din.data, din.user);
    			if (din.last) user_data_end = 1;
    		    if (!s_axis.read_nb(din)) return;
            	last_txd = din.data;
                last_txc = ~din.keep;
    		} else {
    			fcs_cover_xgmii_data_out((ap_uint<64>) 0, 0);
            	last_txd = 0;
                last_txc = 0xf0;
    		}
        }

//    	if (frm_cnt < 7) {
//    		fcs_cover_xgmii_data_out(din.data, din.user);
//        PAD: while (frm_cnt < 7) {
//                fcs_cover_xgmii_data_out((ap_uint<64>) 0, 0);
//            }
//    	}

    	FCS_OUT: {
#pragma HLS LATENCY max=1 min=1

//    		if (frm_cnt < 7) {
//    			last_txd = din.data;
//    			last_txc = ~din.keep;
//    		} else {
//                last_txd = 0;
//                last_txc = 0xf0;
//    		}

            switch(last_txc) {
            case(0x00): fcs_out<8>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0x80): fcs_out<7>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xc0): fcs_out<6>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xe0): fcs_out<5>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xf0): fcs_out<4>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xf8): fcs_out<3>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xfc): fcs_out<2>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            case(0xfe): fcs_out<1>(last_txd, last_txc, next_txd, next_txc, &crc_state); break;
            }

            tx_status.write_nb((t_tx_status) {frm_cnt, !frm_err, 0, 0, 0, 0, 0});
            xgmii_out(last_txd, last_txc);
            xgmii_out(next_txd, next_txc);
    	}

#ifdef RELEASE
        din = idle_out_loop(s_axis, m_xgmii);
#else
        xgmii_out(IDLE_WORD, 0xff);
        if (!s_axis.read_nb(din)) return;
#endif

    }

}
